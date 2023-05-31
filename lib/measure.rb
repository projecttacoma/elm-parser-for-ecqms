# frozen_string_literal: true
require 'fhir_models'
require 'uri'
require 'addressable/uri'

class Measure
  include ElmHelper
  attr_accessor :root_file, :data_model, :elm_helper
  attr_reader :data_requirements, :statements, :definitions, :function_references, :valuesets

  def initialize(root_file, data_model)
    @valuesets = {}
    @data_requirements = []
    @statements = []
    @definitions = []
    @function_references = []
    @root_file = root_file
    @data_model = data_model
    @elm_helper = MeasureElmHelper.new(self)
  end

  def add_valuesets_from_elm(doc)
    doc.xpath('//elm:valueSets/elm:def').each do |valueset_statement|
      valueset_name = valueset_statement['name']
      valueset_oid = valueset_statement['id']
      @valuesets[valueset_name] = valueset_oid
    end
    # Direct Reference Codes
    doc.xpath('//elm:codes/elm:def').each do |code_statement|
      code_name = code_statement['name']
      code = code_statement['id']
      code_system = code_statement.at_xpath('elm:codeSystem/@name').value
      @valuesets[code_name] = "#{code}:#{code_system}"
    end
  end

  def add_data_requirement(data_requirement)
    @data_requirements << data_requirement
  end

  def add_definition(definition_name, library = nil)
    return if @definitions.any? { |defs| defs.name == definition_name && defs.library == library }

    @definitions << Reference.new(definition_name, library)
  end

  def add_statement(statement)
    return if @statements.any? { |s| s.name == statement.name && s.library == statement.library }

    @statements << statement
    data_requirements_from_statement(statement)
    function_references_from_statement(statement, statement.local_id_map)
    add_definition(statement.name, statement.library)
  end

  def get_statement(name, library)
    @statements.select { |s| s.name == name && s.library == library }.first
  end

  # If there "path_statements"
  def extract_data_requirements_from_statements
    statements.each do |statement|
      # If a statement doesn't have any path statments, only the 'codeProperty' will be added to the appropriate retrieve
      data_type_expressions = statement.elm.xpath(".//*[@xsi:type='Retrieve']")
      data_type_expressions.each do |data_type_expression|
        @elm_helper.add_attribute_to_appropriate_data_requirement(data_type_expression, nil)
      end
      # if statement.path_statements.empty?
      #   @elm_helper.get_stuff_from_function(statement, nil) if elm_helper.function?(statement.elm)
      # end
      statement.path_statements.each do |path_statement|
        comp_alias_ex = statement.elm.xpath(".//elm:source[@alias='#{path_statement[:comparision_scope]}'] | .//elm:relationship[@alias='#{path_statement[:comparision_scope]}']")
        exp_ref_expressions = comp_alias_ex.xpath(".//*[@xsi:type='ExpressionRef']")
        exp_ref_expressions.each do |exp_ref_expression|
          comp_statement = statements.select { |st| st.name == exp_ref_expression['name'] }.first
          com_path_statement = comp_statement.path_statements.select { |ps| ps[:path] == path_statement[:comparision_path] }.first
          next unless com_path_statement
          path_statement[:mp_constrained] = com_path_statement[:mp_constrained]
        end

        # If the path statement directly references function
        @data_requirements.select { |dr| dr&.function_ref&.name == path_statement[:scope] }.each do |dr|
          dr.add_attribute(path_statement[:path], path_statement[:valueset])
        end

        if path_statement[:scope] == 'Patient' && path_statement[:path] == 'extension'
          data_requirement_to_update = @data_requirements.select do |dth|
            dth.data_type == 'Patient'
          end.first
          data_requirement_to_update.add_attribute(path_statement[:extension])
        end
        # If a statement does have path statments, look for the source of the alias (for the specified scope)
        alias_ex = statement.elm.xpath(".//elm:source[@alias='#{path_statement[:scope]}'] | .//elm:relationship[@alias='#{path_statement[:scope]}']")

        # The source can reference data types directly with a retrive
        data_type_expressions = alias_ex.xpath(".//*[@xsi:type='Retrieve']")
        data_type_expressions.each do |data_type_expression|
          @elm_helper.add_attribute_to_appropriate_data_requirement(data_type_expression, path_statement)
        end

        # If the statement is a function, the data types can come from the functions or statements that call the function
        @elm_helper.get_stuff_from_function(statement, path_statement) if elm_helper.function?(statement.elm)

        # The source can reference data type from a nested expression
        exp_ref_expressions = alias_ex.xpath(".//*[@xsi:type='ExpressionRef']")
        exp_ref_expressions.each do |exp_ref_expression|
          @elm_helper.follow_expression_ref(exp_ref_expression, path_statement, statement.local_id_map)
        end
      end
    end
  end

  def establish_function_hierarchy
    @elm_helper.establish_function_hierarchy
  end

  private

  def data_requirements_from_statement(statement)
    data_type_operands = statement.elm.xpath(".//*[@xsi:type='Retrieve']")
    data_type_operands.each do |data_type_operand|
      @data_requirements << DataRequirement.new(data_type_operand, statement)
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def function_references_from_statement(statement, local_id_map)
    function_expressions = statement.elm.xpath(".//*[@xsi:type='FunctionRef']")
    function_expressions.each do |function_expression|
      function_library = local_id_map[function_expression['libraryName']]
      function_library ||= statement.library
      # TODO:  need to support a list
      function_alias_expressions = function_expression.xpath(".//elm:operand[@xsi:type='AliasRef']")
      function_dt_expressions = function_expression.xpath(".//elm:operand[@xsi:type='Retrieve']")
      function_op_expressions = function_expression.xpath(".//elm:operand[@xsi:type='OperandRef']")
      function_property_expressions = function_expression.xpath(".//elm:operand[@xsi:type='Property']")
      function_alias_expressions.each do |function_alias_expression|
        @function_references << FunctionReference.new('AliasRef', function_alias_expression['name'],
                                                      function_expression['name'], function_library, statement)
      end
      function_dt_expressions.each do |function_dt_expression|
        dt = function_dt_expression['dataType'].split(':')[1]
        data_type_hash = @data_requirements.select do |dth|
          dth.data_type == dt && dth.valueset == valueset_from_retrieve(function_dt_expression)
        end.first
        @function_references << FunctionReference.new('Retrieve', data_type_hash, function_expression['name'],
                                                      function_library, statement)
      end
      function_op_expressions.each do |function_op_expression|
        @function_references << FunctionReference.new('OperandRef', function_op_expression['name'],
                                                      function_expression['name'], function_library, statement)
      end
      function_property_expressions.each do |function_property_expression|
        @function_references << FunctionReference.new('OperandRef', "#{function_property_expression['scope']}.#{function_property_expression['path']}",
                                                      function_expression['name'], function_library, statement)
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize

class FunctionReference
  attr_accessor :type, :scope, :function, :library, :og_statement

  def initialize(type, scope, function, library, og_statement)
    @type = type
    @scope = scope
    @function = function
    @library = library
    @og_statement = og_statement
  end
end

class DataRequirement
  include ElmHelper
  attr_accessor :data_type, :valueset, :template, :function_ref
  attr_reader :attributes

  def initialize(elm, statement)
    @data_type = elm['dataType'].split(':')[1]
    @valueset = valueset_from_retrieve(elm)
    @template = elm['templateId']
    @attributes = []
    @function_ref = Reference.new(statement.name, statement.library) if (function?(statement.elm) && @valueset.nil?)
  end

  def add_attribute(attribute, valueset = nil, code = nil, literals = nil, mp_constrained = false)
    return unless attribute
    if @attributes.any? { |att| att.name == attribute }
      attribute_to_update = @attributes.select { |th| th.name == attribute }.first
      attribute_to_update.valuesets << valueset if valueset
      attribute_to_update.literals.merge(literals) if literals && !literals.empty?
      attribute_to_update.codes << code if code
      attribute_to_update.mp_constrained = mp_constrained unless attribute_to_update.mp_constrained
    else
      @attributes << Attribute.new(attribute, valueset, code, literals, mp_constrained)
    end
  end

  def as_fhir_dr(measure)
    dr = FHIR::DataRequirement.new
    dr.type = @data_type
    @attributes.each do |att|
      dr.mustSupport << att.name unless att.name == 'extension'
      if att.mp_constrained
        df = FHIR::DataRequirement::DateFilter.new
        df.path = att.name
        df.valuePeriod = FHIR::Period.new('start' => '2019-01-01T00:00:00.000Z', 'end' => '2019-12-31T00:00:00.000Z')
        dr.dateFilter << df
      end
      if att.valuesets.size.positive?
        cf = FHIR::DataRequirement::CodeFilter.new
        cf.path = att.name
        att.valuesets.each do |vs|
          cf.valueSet = measure.valuesets[vs]
        end
        dr.codeFilter << cf
      end
      if att.codes.size.positive?
        cf = FHIR::DataRequirement::CodeFilter.new
        cf.path = att.name
        att.codes.each do |code|
          next unless code
          cv, cs = measure.valuesets[code].split(':')
          cd = FHIR::Coding.new
          cd.code = cv
          cd.system = cs
          cf.code << cd
        end
        dr.codeFilter << cf unless cf.code.empty?
      end
      if att.literals.size.positive?
        cf = FHIR::DataRequirement::CodeFilter.new
        cf.path = att.name
        att.literals.each do |lit|
          next unless lit
          cd = FHIR::Coding.new
          cd.code = lit
          cf.code << cd
        end
        dr.codeFilter << cf unless cf.code.empty?
      end
    end
    self.to_type_fiter(dr)
    dr
  end

  def to_type_fiter(data_requirement)
    query_string = "#{data_requirement.type}?"
    first_param = true
    parameters = []
    data_requirement.codeFilter.each do |code_filter|
      next if code_filter.path == 'extension'
      if code_filter.valueSet
        query_string += "&" unless first_param
        first_param = false
        query_string += "#{code_filter.path}:in="
        query_string += code_filter.valueSet
      end
      if !code_filter.code.empty?
        query_string += "&" unless first_param
        first_param = false
        query_string += "#{code_filter.path}="
        query_string += code_filter.code.first.code
      end
    end
    data_requirement.dateFilter.each do |date_filter|
      query_string += "&" unless first_param
      first_param = false
      query_string += "#{date_filter.path}="
      query_string += "ge#{date_filter.valuePeriod.start}"
      query_string += "&" 
      query_string += "#{date_filter.path}="
      query_string += "le#{date_filter.valuePeriod.end}"
    end
    return if first_param
    data_requirement.extension << FHIR::Extension.new( 'url' => 'http://hl7.org/fhir/us/cqfmeasures/StructureDefinition/cqfm-fhirQueryPattern', 'valueString' => query_string )
    return query_string
    # puts Addressable::URI.encode_component(query_string, Addressable::URI::CharacterClasses::UNRESERVED)
  end
end

class Attribute
  attr_accessor :name, :valuesets, :codes, :literals, :mp_constrained

  def initialize(name, valueset = nil, code = nil, literals = nil, mp_constrained = false)
    @name = name
    @valuesets = Set.new
    @codes = Set.new
    @literals = Set.new
    @valuesets << valueset if valueset
    @codes << code if code
    @literals.merge(literals) if literals && !literals.empty?
    @mp_constrained = mp_constrained
  end
end

class Statement
  attr_accessor :name, :library, :elm, :local_id_map
  attr_reader :path_statements, :parents, :children

  def initialize(elm, local_id_map, library = nil)
    @name = elm['name']
    @library = library
    @local_id_map = local_id_map
    @elm = elm
    @children = []
    @parents = []
    @path_statements = path_hashes_from_def
  end

  def add_child(child)
    @children << child
  end

  def add_parent(parent)
    @parents << parent
  end

  private

  # path statements record the path (i.e., attribute) being evaluated for a specific scope (e.g., alias)
  def path_hashes_from_def
    path_hashes = []
    extension_expressions = @elm.xpath(".//*[elm:source[@alias='$this']/elm:expression[@path='extension']]")
    extension_expressions.each do |extension_expression|
      path_expression = extension_expression.at_xpath(".//*[@xsi:type='Property']")
      vs = if extension_expression.parent.parent.parent.at_xpath("@xsi:type")&.value == 'InValueSet'
            extension_expression.parent.parent.parent.at_xpath('.//elm:valueset')['name']
           else
            nil
           end
      scope = path_scope(path_expression)
      next unless scope
      path_hashes << { path: path_expression['path'], scope: scope,
                       localId: path_expression['localId'], extension: extension_expression.at_xpath(".//elm:where/elm:operand[@xsi:type='Literal']")['value'], valueset: vs }
    end
    path_expressions = @elm.xpath(".//*[@xsi:type='Property']")
    operand_expressions = @elm.xpath(".//*[@xsi:type='OperandRef']")
    if path_expressions.empty?
      operand_expressions.each do |operand_expression|
        subelements = []
        code = nil
        literal = nil
        if operand_expression.parent.at_xpath("@xsi:type")&.value == 'Equivalent'
          ex = operand_expression.parent.xpath(".//*[@xsi:type='CodeRef']")
          code = expression_value_at_locator(ex, operand_expression['locator'], 'name')
        end
        path_hashes << { path: nil, scope: operand_expression['name'],
                         localId: operand_expression['localId'], code: code, literals: literal, subelements: subelements }
      end
    end
    path_expressions.each do |path_expression|
      next if path_expression['path'] == 'extension'

      subelements = []
      if path_expression.parent['alias']
        parent_alias = path_expression.parent['alias']
        subelement_expressions = path_expression.parent.parent.xpath(".//*[@xsi:type='Property' and @scope='#{parent_alias}']")
        subelement_expressions.each do |subelement_expression|
          subelement_vs = subelement_expression.parent.at_xpath('elm:valueset/@name')
          subelement_code = subelement_expression.parent.at_xpath("elm:operand[@xsi:type='CodeRef']/@name") unless
          subelements << { name: subelement_expression['path'], valueset: subelement_vs&.value, code: subelement_code }
        end
      end
      vs = nil
      code = nil
      literals = []
      scope = path_scope(path_expression)

      if path_expression.parent.xpath(".//*[@xsi:type='NamedTypeSpecifier' and @name='t:DateTime']")
        if ['IncludedIn', 'In'].include? path_expression.parent.at_xpath("@xsi:type")&.value
          mp_constrained = !path_expression.parent.xpath(".//*[@xsi:type='ParameterRef' and @name='Measurement Period']").empty?
          c_scope, c_path = comparision_scope(path_expression.parent, scope)
        elsif ['IncludedIn', 'In'].include? path_expression.parent.parent.at_xpath("@xsi:type")&.value
          mp_constrained = !path_expression.parent.parent.xpath(".//*[@xsi:type='ParameterRef' and @name='Measurement Period']").empty?
          c_scope, c_path = comparision_scope(path_expression.parent.parent, scope)
        elsif ['IncludedIn', 'In'].include? path_expression.parent.parent.parent.at_xpath("@xsi:type")&.value
          mp_constrained = !path_expression.parent.parent.parent.xpath(".//*[@xsi:type='ParameterRef' and @name='Measurement Period']").empty?
          c_scope, c_path = comparision_scope(path_expression.parent.parent.parent, scope)
        elsif ['IncludedIn', 'In'].include? path_expression.parent.parent.parent.parent.at_xpath("@xsi:type")&.value
          mp_constrained = !path_expression.parent.parent.parent.parent.xpath(".//*[@xsi:type='ParameterRef' and @name='Measurement Period']").empty?
          c_scope, c_path = comparision_scope(path_expression.parent.parent.parent.parent, scope)
        elsif path_expression.parent.parent.parent.parent.name != 'document' && (['IncludedIn', 'In'].include? path_expression.parent.parent.parent.parent.parent.at_xpath("@xsi:type")&.value)
          mp_constrained = !path_expression.parent.parent.parent.parent.parent.xpath(".//*[@xsi:type='ParameterRef' and @name='Measurement Period']").empty?
        elsif path_expression.parent.parent.parent.parent.name != 'document' && (['IncludedIn', 'In'].include? path_expression.parent.parent.parent.parent&.parent&.parent&.at_xpath("@xsi:type")&.value)
          mp_constrained = !path_expression.parent.parent.parent.parent.parent.parent.xpath(".//*[@xsi:type='ParameterRef' and @name='Measurement Period']").empty?
        end
      end
      if path_expression.name == 'code'
        vs = path_expression.parent.at_xpath('elm:valueset')['name']
      elsif path_expression.parent.at_xpath("@xsi:type")&.value == 'Equivalent' || path_expression.parent.parent.at_xpath("@xsi:type")&.value == 'Equivalent' || path_expression.parent.parent.parent.at_xpath("@xsi:type")&.value == 'Equivalent'
        if path_expression.parent.parent.parent.at_xpath(".//*[@xsi:type='CodeRef']")
          ex = path_expression.parent.parent.parent.xpath(".//*[@xsi:type='CodeRef']")
          code = expression_value_at_locator(ex, nearest_locator(path_expression), 'name')
        elsif path_expression.parent.parent.parent.at_xpath(".//*[@xsi:type='Literal']")
          ex = path_expression.parent.parent.parent.xpath(".//*[@xsi:type='Literal']")
          literals << expression_value_at_locator(ex, nearest_locator(path_expression), 'value')
        end
      elsif path_expression.parent.parent.at_xpath("@xsi:type")&.value == 'InValueSet' || path_expression.parent.parent.parent.at_xpath("@xsi:type")&.value == 'InValueSet'
        ex = path_expression.parent.parent.parent.xpath('.//elm:valueset')
        vs = expression_value_at_locator(ex, nearest_locator(path_expression), 'name')
      elsif path_expression.parent.at_xpath("@xsi:type")&.value == 'Equal' || path_expression.parent.parent.at_xpath("@xsi:type")&.value == 'Equal'
        ex = path_expression.parent.parent.xpath(".//*[@xsi:type='Literal']")
        literals << expression_value_at_locator(ex, path_expression.parent['locator'], 'value') if ex
      elsif path_expression.parent.parent.parent.at_xpath("@xsi:type")&.value == 'AnyInValueSet' || path_expression.parent.parent.parent.parent.at_xpath("@xsi:type")&.value == 'AnyInValueSet'
        ex = path_expression.parent.parent.parent.parent.xpath('.//elm:valueset')
        vs = expression_value_at_locator(ex, nearest_locator(path_expression), 'name')
      elsif path_expression.parent.parent.at_xpath("@xsi:type")&.value == 'In'
        literals.concat(path_expression.parent.parent.xpath(".//*[@xsi:type='Literal']").map { |pe| pe['value'] })
      elsif path_expression.parent.parent.parent.parent.at_xpath("@xsi:type")&.value == 'Query'
        if path_expression.parent.parent.parent.parent.at_xpath(".//*[@xsi:type='CodeRef']")
          ex = path_expression.parent.parent.parent.parent.xpath(".//*[@xsi:type='CodeRef']")
          code = expression_value_at_locator(ex, nearest_locator(path_expression), 'name')
        elsif path_expression.parent.parent.parent.parent.at_xpath(".//*[@xsi:type='Literal']")
          ex = path_expression.parent.parent.parent.parent.xpath(".//*[@xsi:type='Literal']")
          literals << expression_value_at_locator(ex, nearest_locator(path_expression), 'value')
        end
      end

      next unless scope
      path_hashes << { path: path_expression['path'], scope: scope, comparision_scope: c_scope, comparision_path: c_path,
                       localId: path_expression['localId'], valueset: vs, code: code, literals: literals, subelements: subelements, mp_constrained: mp_constrained }
    end
    path_hashes
  end

  def comparision_scope(expression, original_scope)
    comparision_expressions = expression.xpath(".//*[@xsi:type='Property']")
    comparision_expressions.each do |comparision_expression|
      next if comparision_expression['scope'] == original_scope
      return [comparision_expression['scope'], comparision_expression['path']]
    end
  end

  def nearest_locator(path_expression)
    return path_expression['locator'] if path_expression['locator']
    nearest_locator(path_expression.parent)
  end

  def expression_value_at_locator(expressions, referencing_locator, attribute)
    expressions.each do |expression|
      return expression[attribute] if referencing_locator && (nearest_locator(expression).split(':')[0].to_i == referencing_locator.split(':')[0].to_i)
    end
    nil
  end

  def path_scope(path_expression)
    return path_expression['scope'] if path_expression['scope']
    return if path_expression.at_xpath(".//elm:source[@xsi:type='Property']")
    return if path_expression.at_xpath(".//elm:source/@name").nil?
    return path_expression.at_xpath(".//elm:source[@xsi:type='FunctionRef']/elm:operand/@name").value if path_expression.at_xpath(".//elm:source[@xsi:type='FunctionRef']/elm:operand/@name")
    return path_expression.at_xpath(".//elm:source/@name").value
  end
end

class Reference
  attr_accessor :name, :library

  def initialize(name, library = nil)
    @name = name
    @library = library
  end
end
