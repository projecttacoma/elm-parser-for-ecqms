# frozen_string_literal: true

module ElmHelper
  def function?(def_expression)
    def_expression.at_xpath('@xsi:type') && def_expression.at_xpath('@xsi:type').value == 'FunctionDef'
  end

  # Returns a hash of the local identifiers for shared libraries.  The NCQAHealthPlanEnrollment maybe be referred to locally as Enrollment
  def local_ids(doc)
    local_id_map = {}
    local_identifier_expressions = doc.xpath('//elm:includes/elm:def')
    local_identifier_expressions.each do |local_identifier_expression|
      local_id_map[local_identifier_expression['localIdentifier']] = local_identifier_expression['path']
    end
    local_id_map
  end

  def valueset_from_retrieve(data_type_expression)
    vs_name = nil
    if data_type_expression.at_xpath('elm:codes')
      vs_name = data_type_expression.at_xpath('elm:codes')['name']
      vs_name ||= data_type_expression.at_xpath('elm:codes/elm:operand')['name']
    end
    vs_name
  end
end

class MeasureElmHelper
  include ElmHelper

  def initialize(measure)
    @measure = measure
  end

  def follow_expression_ref(elm, path_statement, local_id_map, library_name = nil)
    library_name ||= local_id_map[elm['libraryName']]
    referenced_statement = @measure.get_statement(elm['name'], library_name)
    return unless referenced_statement

    data_type_expressions = if referenced_statement.elm.xpath('.//elm:source[@alias]').empty?
                              referenced_statement.elm.xpath(".//*[@xsi:type='Retrieve']")
                            else
                              alias_expression = referenced_statement.elm.xpath(".//elm:source[@alias='#{path_statement[:scope]}']")
                              alias_expression.xpath(".//*[@xsi:type='Retrieve']")
                            end
    data_type_expressions.each do |data_type_expression|
      add_attribute_to_appropriate_data_requirement(data_type_expression, path_statement[:path], path_statement[:extension])
    end
    exp_ref_expressions = referenced_statement.elm.xpath(".//*[@xsi:type='ExpressionRef']")
    exp_ref_expressions.each do |exp_ref_expression|
      library_name = local_id_map[exp_ref_expression['libraryName']] if exp_ref_expression['libraryName']
      follow_expression_ref(exp_ref_expression, path_statement, local_id_map, library_name)
    end
  end

  def get_stuff_from_function(statement, path_statement)
    if !statement.elm.xpath('./elm:expression/elm:source').empty?
      extract_information_from_function_source(statement, path_statement)
    elsif path_statement[:scope].nil?
      extract_information_from_function_body(statement, path_statement)
    end
    operand_name = statement.elm.at_xpath('./elm:operand/@name')&.value
    return unless operand_name

    if !statement.elm.xpath(".//elm:source[@name='#{operand_name}' and @xsi:type='OperandRef']").empty?
      extract_information_from_function_operand(statement, path_statement, operand_name)
    end
  end

  def extract_information_from_function_operand(statement, path_statement, operand_name)
    @measure.function_references.select { |fh| fh.function == statement.name }.each do |function_reference|
      if function_reference.type == 'AliasRef' && operand_name == path_statement[:scope]
        add_attributes_from_og_expression(function_reference, path_statement)
      elsif function_reference.type == 'Retrieve' && operand_name == path_statement[:scope]
        next unless attribute_appropriate_for_dt(function_reference.scope.data_type, path_statement[:path])

        function_reference.scope.add_attribute(path_statement[:path])
      else
        extract_information_from_function_parent(function_reference, path_statement)
      end
    end
  end

  def extract_information_from_function_source(statement, path_statement)
    function_alias_path = statement.elm.xpath(".//elm:source[./elm:expression/@xsi:type='OperandRef'] "\
                                              "| .//elm:source[./elm:expression/elm:source/@xsi:type='OperandRef']").first
    return unless function_alias_path

    function_alias = function_alias_path['alias']
    @measure.function_references.select { |fh| fh.function == statement.name }.each do |function_reference|
      if function_reference.type == 'AliasRef' && function_alias == path_statement[:scope]
        add_attributes_from_og_expression(function_reference, path_statement)
      elsif function_reference.type == 'Retrieve' && function_alias == path_statement[:scope]
        next unless attribute_appropriate_for_dt(function_reference.scope.data_type, path_statement[:path])

        function_reference.scope.add_attribute(path_statement[:path])
      else
        extract_information_from_function_parent(function_reference, path_statement)
      end
    end
  end

  def extract_information_from_function_body(statement, path_statement)
    @measure.function_references.select { |fh| fh.function == statement.name }.each do |function_reference|
      case function_reference.type
      when 'AliasRef'
        add_attributes_from_og_expression(function_reference, path_statement)
      when 'Retrieve'
        next unless attribute_appropriate_for_dt(function_reference.scope.data_type, path_statement[:path])

        function_reference.scope.add_attribute(path_statement[:path])
      else
        extract_information_from_function_parent(function_reference, path_statement)
      end
    end
  end

  def add_attributes_from_og_expression(function_reference, path_statement)
    alias_expression = function_reference.og_expression.xpath(".//elm:source[@alias='#{function_reference.scope}']")
    data_type_expressions = alias_expression.xpath(".//*[@xsi:type='Retrieve']")
    data_type_expressions.each do |data_type_expression|
      add_attribute_to_appropriate_data_requirement(data_type_expression, path_statement[:path], path_statement[:extension])
    end
  end

  def extract_information_from_function_parent(function_reference, path_statement)
    parents = @measure.statements.select do |mes_statement|
      mes_statement.children.any? do |chld|
        chld.name == function_reference.function && chld.library == function_reference.library
      end
    end
    parents.each do |parent|
      get_stuff_from_function(parent, path_statement)
    end
  end

  def add_attribute_to_appropriate_data_requirement(data_type_expression, attribute, extension = nil)
    dt = data_type_expression['dataType'].split(':')[1]
    data_requirement_to_update = @measure.data_requirements.select do |dth|
      dth.data_type == dt && dth.valueset == valueset_from_retrieve(data_type_expression)
    end.first
    data_requirement_to_update.add_attribute(data_type_expression['codeProperty'])
    return unless attribute && attribute_appropriate_for_dt(data_requirement_to_update.data_type, attribute)

    extension ? data_requirement_to_update.add_attribute(extension) : data_requirement_to_update.add_attribute(attribute)
  end

  def establish_function_hierarchy
    @measure.function_references.each do |function_reference|
      statement = @measure.get_statement(function_reference.function, function_reference.library)
      child_function_expressions = statement.elm.xpath(".//*[@xsi:type='FunctionRef']")
      child_function_expressions.each do |child_function_expression|
        referenced_library = statement.local_id_map[child_function_expression['libraryName']]
        referenced_library ||= statement.library
        statement.add_child(Reference.new(child_function_expression['name'], referenced_library))
      end
      statement.children.each do |child_function|
        if child_function
          child_statement = @measure.get_statement(child_function.name, child_function.library)
          child_statement.add_parent(Reference.new(function_reference.function, function_reference.library))
        end
      end
    end
  end

  def attribute_appropriate_for_dt(data_type, attribute)
    return true if attribute == 'modifierExtension'
    return true if attribute == 'extension'

    @measure.data_model.get_data_type(data_type).attributes.include?(attribute)
  end
end
