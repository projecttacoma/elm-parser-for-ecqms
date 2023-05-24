# frozen_string_literal: true

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

  def add_attribute(attribute, valueset = nil, literals = nil)
    return unless attribute
    if @attributes.any? { |att| att.name == attribute }
      attribute_to_update = @attributes.select { |th| th.name == attribute }.first
      attribute_to_update.valuesets << valueset if valueset
      attribute_to_update.literals.merge(literals) if literals && !literals.empty?
    else
      @attributes << Attribute.new(attribute, valueset, literals)
    end
  end
end

class Attribute
  attr_accessor :name, :valuesets, :literals

  def initialize(name, valueset = nil, literals = nil)
    @name = name
    @valuesets = Set.new
    @literals = Set.new
    @valuesets << valueset if valueset
    @literals.merge(literals) if literals && !literals.empty?
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
        vs = nil
        literal = nil
        if operand_expression.parent.at_xpath("@xsi:type")&.value == 'Equivalent'
          ex = operand_expression.parent.xpath(".//*[@xsi:type='CodeRef']")
          vs = expression_value_at_locator(ex, operand_expression['locator'], 'name')
        end
        path_hashes << { path: nil, scope: operand_expression['name'],
                         localId: operand_expression['localId'], valueset: vs, literals: literal, subelements: subelements }
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
          subelement_vs ||= subelement_expression.parent.at_xpath("elm:operand[@xsi:type='CodeRef']/@name")
          subelements << { name: subelement_expression['path'], valueset: subelement_vs&.value }
        end
      end
      vs = nil
      literals = []
      if path_expression.name == 'code'            
        vs = path_expression.parent.at_xpath('elm:valueset')['name']
      elsif path_expression.parent.at_xpath("@xsi:type")&.value == 'Equivalent' || path_expression.parent.parent.at_xpath("@xsi:type")&.value == 'Equivalent' || path_expression.parent.parent.parent.at_xpath("@xsi:type")&.value == 'Equivalent'
        if path_expression.parent.parent.parent.at_xpath(".//*[@xsi:type='CodeRef']")
          ex = path_expression.parent.parent.parent.xpath(".//*[@xsi:type='CodeRef']")
          vs = expression_value_at_locator(ex, nearest_locator(path_expression), 'name')
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
          vs = expression_value_at_locator(ex, nearest_locator(path_expression), 'name')
        elsif path_expression.parent.parent.parent.parent.at_xpath(".//*[@xsi:type='Literal']")
          ex = path_expression.parent.parent.parent.parent.xpath(".//*[@xsi:type='Literal']")
          literals << expression_value_at_locator(ex, nearest_locator(path_expression), 'value')
        end
      end
      scope = path_scope(path_expression)
      next unless scope
      path_hashes << { path: path_expression['path'], scope: scope,
                       localId: path_expression['localId'], valueset: vs, literals: literals, subelements: subelements }
    end
    path_hashes
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
