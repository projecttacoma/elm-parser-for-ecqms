# frozen_string_literal: true

require 'optparse'
require 'nokogiri'
require 'csv'
require './lib/measure_bundle_helper'
require './lib/data_model'
require './lib/qdm_mapper'
require './lib/elm_helper'
require './lib/measure'
require 'byebug'

def generate_elm_data_csv(bundle)
  measures = []

  data_model = DataModel.new(bundle)
  measure_artifacts_list = MeasureBundleHelper.new.get_files_from_bundle(bundle)

  measure_artifacts_list.each do |measure_artifacts|
    measure = Measure.new(measure_artifacts[:root], data_model)

    dependencies = []
    root_file_path = "measures/#{bundle}/#{measure_artifacts[:measure_folder]}/#{measure_artifacts[:root]}"
    parse_statements_from_root_file(measure, root_file_path, dependencies)

    # Follow dependencies into supporting files
    dependencies.each_with_index do |dependency, _index|
      next unless dependency

      file_directory = "measures/#{bundle}/#{measure_artifacts[:measure_folder]}/"
      extract_dependency_from_supporting_file(measure, measure_artifacts[:supporting_files], file_directory, dependency, dependencies)
    end

    measure.establish_function_hierarchy
    measure.extract_data_requirements_from_statements
    output_csv_for_measure(measure)
    measures << measure
  end
  bundle == 'qdm' ? output_csv_for_qdm_measures(measures, bundle) : output_csv_for_fhir_measures(measures, bundle)
end

def parse_statements_from_root_file(measure, file_path, dependencies)
  # Get dependencies from root file
  doc = build_document(file_path)
  measure.add_valuesets_from_elm(doc)

  # Find locally used identifiers for supporting libraries
  local_id_map = measure.elm_helper.local_ids(doc)

  # Get all Definitions in the Root Library
  root_def_expressions = doc.xpath('//elm:statements/elm:def')

  root_def_expressions.each do |root_def_expression|
    measure.add_statement(Statement.new(root_def_expression, local_id_map))
    measure.add_definition(root_def_expression['name'])
    dependencies << Reference.new(root_def_expression['name'])
  end

  dependency_expressions = doc.xpath(".//*[@xsi:type='ExpressionRef'] | .//*[@xsi:type='FunctionRef']")
  dependency_expressions.each do |dependency_expression|
    measure.add_definition(dependency_expression['name'], local_id_map[dependency_expression['libraryName']])
    next if dependencies.any? do |depen|
              depen.name == dependency_expression['name'] && depen.library == local_id_map[dependency_expression['libraryName']]
            end

    dependencies << Reference.new(dependency_expression['name'], local_id_map[dependency_expression['libraryName']])
  end
end

def extract_dependency_from_supporting_file(measure, files, file_directory, dependency, dependencies)
  files.each_with_index do |file_name, _index|
    next unless file_name.include? '.xml'
    doc = build_document("#{file_directory}#{file_name}")
    measure.add_valuesets_from_elm(doc)
    local_id_map = measure.elm_helper.local_ids(doc)

    # TODO: Definitions with apostrophes throws off parser
    next if dependency.name.include?("'")

    library_name = doc.at_xpath('//elm:library/elm:identifier/@id').value
    next if library_name != dependency.library

    def_expression = doc.xpath("//elm:library/elm:statements/elm:def[@name='#{dependency.name}']").first
    next unless def_expression

    measure.add_statement(Statement.new(def_expression, local_id_map, library_name))

    dependency_expressions = def_expression.xpath(".//*[@xsi:type='ExpressionRef'] | .//*[@xsi:type='FunctionRef']")
    dependency_expressions.each do |dependency_expression|
      next if dependencies.any? do |depen|
                depen.name == dependency_expression['name'] && depen.library == local_id_map[dependency_expression['libraryName']]
              end

      referenced_library = local_id_map[dependency_expression['libraryName']]
      referenced_library ||= library_name
      dependencies << Reference.new(dependency_expression['name'], referenced_library)
    end
  end
end

def output_csv_for_measure(measure)
  CSV.open("data_requirements/by_measure/#{measure.root_file}.csv", 'w', col_sep: '|') do |csv|
    measure.data_requirements.each do |data_requirement|
      # csv << [data_type_hash[:dataType],data_type_hash[:vs_name], 'code']
      data_requirement.attributes.each do |attribute|
        next if attribute.nil?

        csv << [data_requirement.data_type, data_requirement.template, data_requirement.valueset, attribute]
      end
    end
  end
end

def output_csv_for_qdm_measures(measures, bundle)
  headers = ['Measure', 'Data Type', 'Template Id', 'Data Type Value Set', 'Data Type Value OID', 'Attribute', 'Mapped QI Core Profile', 'Mapped QI Core Attribute']
  qdm_map = QdmMapper.new

  CSV.open("data_requirements/#{bundle}_all.csv", 'w', col_sep: '|', write_headers: true,
                                                       headers: headers) do |combined_csv|
    measures.each do |measure|
      measure.data_requirements.each do |data_requirement|
        data_requirement.attributes << 'qdmcontext'
        data_requirement.attributes.compact.each do |attribute|

          qi_profile_name, qi_attributes, qi_negation_profile_name = qdm_map.qdm_profile_attribute_as_qi_core(data_requirement.data_type,
                                                                                                              attribute)
          profile = data_requirement.attributes.any? { |att| att == 'negationRationale' } ? qi_negation_profile_name : qi_profile_name
          qi_attributes&.each do |qi_attribute|
            combined_csv << [measure.root_file, data_requirement.data_type, data_requirement.template,
                             data_requirement.valueset, measure.valuesets[data_requirement.valueset],
                             attribute, profile, qi_attribute.qi_field.gsub('[x]', '')]
          end
        end
      end
    end
  end
end

def output_csv_for_fhir_measures(measures, bundle)
  headers = ['Measure', 'Data Type', 'Template Id', 'Data Type Value Set', 'Data Type Value OID', 'Attribute']

  CSV.open("data_requirements/#{bundle}_all.csv", 'w', col_sep: '|', write_headers: true,
                                                       headers: headers) do |combined_csv|
    measures.each do |measure|
      measure.data_requirements.each do |data_requirement|
        # csv << [folder, data_type_hash[:dataType],data_type_hash[:vs_name], 'code']
        data_requirement.attributes.each do |attribute|
          next if attribute.nil?

          combined_csv << [measure.root_file, data_requirement.data_type, data_requirement.template, data_requirement.valueset,
                           measure.valuesets[data_requirement.valueset], attribute]
        end
      end
    end
  end
end

def build_document(file_path)
  doc = File.open(file_path) { |f| Nokogiri::XML(f) }
  doc.root.add_namespace_definition('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
  doc.root.add_namespace_definition('elm', 'urn:hl7-org:elm:r1')
  doc
end

# ruby parse_elm.rb --bundle qdm
options = {}
OptionParser.new do |parser|
  parser.on('-b', '--bundle [String]', String, 'fhir, qdm, or qicore') do |what|
    options[:bundle] = what
  end
end.parse!

generate_elm_data_csv(options[:bundle])
