# frozen_string_literal: true

class DataModel
  attr_reader :data_types

  def initialize(bundle)
    @data_types = []
    types_from_model_info(bundle)
  end

  def get_data_type(type_name)
    @data_types.select { |dt| dt.name == type_name }.first
  end

  def get_or_create_data_type(type_name, namespace, identifier)
    data_type = @data_types.select { |dt| dt.name == type_name }.first
    return data_type unless data_type.nil?

    data_type = DataType.new(type_name, namespace, identifier)
    @data_types << data_type
    data_type
  end

  def get_data_type_by_identifier(identifier)
    @data_types.select { |dt| dt.identifier == identifier }.first
  end

  def types_from_model_info(bundle)
    doc = build_document(bundle)
    types = doc.xpath('//elm:typeInfo')

    # Iterate twice to grab information from base types that might appear after the type that references them
    2.times do
      types.each do |type|
        # The QDM model info uses "QDM" before every type, this it probably synonymous to the namespace in FHIR based model info files
        type_name = type['name'].include?('QDM.') ? type['name'].split('.')[1] : type['name']

        data_type = get_or_create_data_type(type_name, type['namespace'], type['idnetifier'])
        # Add an attribute for each nexted element
        type.xpath('elm:element').each do |attribute|
          data_type.add_attribute(attribute['name'])
        end
        base_type_name = type['baseType']
        next unless base_type_name

        # If a baseType exists, add the nested attributes from the base type
        base_type = get_data_type(type['baseType'].include?('QDM.') ? type['baseType'].split('.')[1] : type['baseType'])
        data_type.add_attributes(base_type.attributes) if base_type
      end
    end
  end

  def build_document(bundle)
    model_info_file_hash = { 'fhir' => 'model_info/fhir-modelinfo-4.0.1.xml',
                             'qdm' => 'model_info/qdm-modelinfo-5.6.xml',
                             'qicore' => 'model_info/qicore-modelinfo-4.1.1.xml' }

    filename = model_info_file_hash[bundle]

    doc = File.open(filename.to_s) { |f| Nokogiri::XML(f) }
    doc.root.add_namespace_definition('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
    doc.root.add_namespace_definition('elm', 'urn:hl7-org:elm-modelinfo:r1')
    doc
  end
end

class DataType
  attr_accessor :name, :namespace, :identifier
  attr_reader :attributes

  def initialize(name, namespace, identifier)
    @name = name
    @namespace = namespace
    @identifier = identifier
    @attributes = Set.new
  end

  def add_attribute(attribute)
    @attributes << attribute
  end

  def add_attributes(attributes)
    attributes.each { |att| @attributes << att }
  end
end
