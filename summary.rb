# frozen_string_literal: true

require 'optparse'
require 'nokogiri'
require 'csv'
require 'json'
require 'byebug'
require './lib/qdm_mapper'

def compile_data_type_information_from_qdm_csv(file_path)
  qdm_map = QdmMapper.new

  dt_hash = {}
  attribute_measure_hash = {}
  CSV.foreach(file_path, col_sep: '|', headers: :first_row, return_headers: false) do |row|
    measure = row[0]
    qdm_profile_name = row[1]
    qdm_attribute = row[4]

    profile_name, attributes, qi_negation_profile_name = qdm_map.qdm_profile_attribute_as_qi_core(qdm_profile_name, qdm_attribute)

    profile = qdm_profile_name.include?('Negative') ? qi_negation_profile_name : profile_name
    attributes.each do |attribute|
      hash_lookup = "#{profile}|#{attribute.qi_field}"
      attribute_measure_hash[hash_lookup] = { measures: [] } unless attribute_measure_hash[hash_lookup]
      attribute_measure_hash[hash_lookup][:measures] << measure unless attribute_measure_hash[hash_lookup][:measures].include? measure

      unless dt_hash[profile]
        dt_hash[profile] = { qi_core_attributes: [], attributes: [], measures: [], valuesets: [], eh_count: 0, ec_count: 0, us_core_profile: '' }
      end

      dt_hash[profile][:attributes] << attribute.qi_field
      dt_hash[profile][:measures] << measure
      dt_hash[profile][:valuesets] << row[3]
    end
  end
  [dt_hash, attribute_measure_hash]
end

def generate_qdm_summary(bundle, qi_to_uscore_mappings)
  dt_hash, attribute_measure_hash = compile_data_type_information_from_qdm_csv("data_requirements/#{bundle}_all.csv")

  dt_hash.each do |profile_name, hash|
    hash[:measures].uniq.each do |measure_name|
      eh_measure?(measure_name) ? hash[:eh_count] += 1 : hash[:ec_count] += 1
    end

    hash[:us_core_profile] = qi_to_uscore_mappings[profile_name]['uscoreprofile']
    hash[:attributes].uniq.each do |attribute|
      ms_in_uscore = qi_to_uscore_mappings[profile_name]['fields'].any? do |field_name, field_hash|
        field_name.split('.')[0].gsub('[x]', '') == attribute && field_hash['ms']['uscore']
      end
      hash[:qi_core_attributes] << attribute unless ms_in_uscore
    end
  end
  csv_for_qdm_hash(dt_hash, attribute_measure_hash, bundle)
end

def csv_for_qdm_hash(dt_hash, attribute_measure_hash, bundle)
  headers = ['QI Core Profile', 'US Core Profile', 'All Attributes', 'QI Core Specific Attributes', 'EH Measure Count', 'EC Measure Count']
  CSV.open("data_requirements/#{bundle}_summary.csv", 'w', col_sep: '|', write_headers: true,
                                                           headers: headers) do |csv|
    dt_hash.each do |profile_name, hash|
      csv << [profile_name,
              hash[:us_core_profile],
              hash[:attributes].uniq.compact.reject(&:empty?).join(','),
              hash[:qi_core_attributes].map! do |sa|
                qi_core_attributes_with_count(sa, profile_name, attribute_measure_hash)
              end.compact.reject(&:empty?).join(','),
              hash[:eh_count],
              hash[:ec_count]]
    end
  end
end

def compile_data_type_information_from_qicore_csv(file_path)
  dt_hash = {}
  attribute_measure_hash = {}

  CSV.foreach(file_path, col_sep: '|', headers: :first_row, return_headers: false) do |row|
    measure = row[0]
    profile_url = row[2]
    attribute = row[4]

    hash_lookup = "#{profile_url}|#{attribute}"
    attribute_measure_hash[hash_lookup] = { measures: [] } unless attribute_measure_hash[hash_lookup]
    attribute_measure_hash[hash_lookup][:measures] << measure unless attribute_measure_hash[hash_lookup][:measures].include? measure

    unless dt_hash[profile_url]
      dt_hash[profile_url] = { qi_core_attributes: [], attributes: [], measures: [], valuesets: [], eh_count: 0, ec_count: 0, us_core_profile: '' }
    end
    dt_hash[profile_url][:attributes] << attribute
    dt_hash[profile_url][:measures] << measure
    dt_hash[profile_url][:valuesets] << row[3]
  end
  [dt_hash, attribute_measure_hash]
end

def generate_qicore_summary(bundle, qi_to_uscore_mappings)
  dt_hash, attribute_measure_hash = compile_data_type_information_from_qicore_csv("data_requirements/#{bundle}_all.csv")

  dt_hash.each do |profile_url, hash|
    hash[:measures].uniq.each do |measure_name|
      eh_measure?(measure_name) ? hash[:eh_count] += 1 : hash[:ec_count] += 1
    end

    # TODO: Profile name for a url can be found in Model Info File.  However, we are currently using 4.1.1 where the QI/USCORE is for v5
    profile = profile_name_for_url(profile_url)
    next unless profile
    hash[:us_core_profile] = qi_to_uscore_mappings[profile]['uscoreprofile']
    hash[:attributes].uniq.each do |attribute|
      ms_in_uscore = qi_to_uscore_mappings[profile]['fields'].any? do |field_name, field_hash|
        field_name.split('.')[0].gsub('[x]', '') == attribute && field_hash['ms']['uscore']
      end
      hash[:qi_core_attributes] << attribute unless ms_in_uscore
    end
  end
  csv_for_qicore_hash(dt_hash, attribute_measure_hash, bundle)
end

def csv_for_qicore_hash(dt_hash, attribute_measure_hash, bundle)
  headers = ['QI Core Profile URL', 'QI Core Profile', 'US Core Profile', 'All Attributes', 'QI Core Specific Attributes',
             'EH Measure Count', 'EC Measure Count']
  CSV.open("data_requirements/#{bundle}_summary.csv", 'w', col_sep: '|', write_headers: true,
                                                           headers: headers) do |csv|
    dt_hash.each do |profile_url, hash|
      csv << [profile_url,
              profile_name_for_url(profile_url),
              hash[:us_core_profile],
              hash[:attributes].uniq.compact.reject(&:empty?).join(','),
              hash[:qi_core_attributes].map! do |sa|
                qi_core_attributes_with_count(sa, profile_url, attribute_measure_hash)
              end.compact.reject(&:empty?).join(','),
              hash[:eh_count],
              hash[:ec_count]]
    end
  end
end

def qi_core_attributes_with_count(attribute, profile_url, attribute_measure_hash)
  "#{attribute}(#{attribute_measure_hash["#{profile_url}|#{attribute}"][:measures].size})"
end

# rubocop:disable Metrics/MethodLength
def eh_measure?(measure_name)
  eh_measure_names = ['AnticoagulationTherapyforAtrialFibrillationFlutterQICore4.xml',
                      'AntithromboticTherapyByEndofHospitalDay2QICore4.xml',
                      'DischargedonAntithromboticTherapyQICore4.xml',
                      'IntensiveCareUnitVenousThromboembolismProphylaxisQICore4.xml',
                      'JuliaExam190QICore4.xml',
                      'CMS9-v11-1-000-QDM-5-6.xml',
                      'CMS71-v12-0-000-QDM-5-6.xml',
                      'CMS72-v11-1-000-QDM-5-6.xml',
                      'CMS1028-v1-3-000-QDM-5-6.xml',
                      'CMS104-v11-0-000-QDM-5-6.xml',
                      'CMS105-v11-0-000-QDM-5-6.xml',
                      'CMS108-v11-1-000-QDM-5-6.xml',
                      'CMS111-v11-1-000-QDM-5-6.xml',
                      'CMS190-v11-1-000-QDM-5-6.xml',
                      'CMS334-v4-0-QDM-5-6.xml',
                      'CMS506-v5-0-000-QDM-5-6.xml',
                      'CMS816-v2-0-000-QDM-5-6.xml',
                      'CMS871-v2-0-000-QDM-5-6.xml',
                      'CMS986-v1-9-000-QDM-5-6.xml',
                      'CMS819-v1-0-000-QDM-5-6.xml',
                      'CMS844-v3-1-000-QDM-5-6.xml',
                      'CMS529-v3-1-000-QDM-5-6.xml',
                      'CMS996-v3-2-000-QDM-5-6.xml']
  return true if eh_measure_names.include?(measure_name)
end
# rubocop:enable Metrics/MethodLength

def profile_name_for_url(url)
  profile_hash = {
    # "QICoreAdverseEvent",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-allergyintolerance' => 'QICoreAllergyIntolerance',
    # "QICoreCommunication",
    # "QICoreCommunicationNotDone",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-condition' => 'QICoreConditionProblemsHealthConcerns',
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-coverage' => 'QICoreCoverage',
    # "QICoreDeviceNotRequested",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-devicerequest' => 'QICoreDeviceRequest',
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-encounter' => 'QICoreEncounter',
    # "QICoreFamilyMemberHistory",
    # "QICoreGoal",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-immunization' => 'QICoreImmunization',
    # "QICoreImmunizationNotDone",
    # "QICoreLaboratoryResultObservation",
    # "QICoreLocation",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medicationadministration' => 'QICoreMedicationAdministration',
    # "QICoreMedicationAdministrationNotDone",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medicationdispense' => 'QICoreMedicationDispense',
    # "QICoreMedicationDispenseNotDone",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-mednotrequested' => 'QICoreMedicationNotRequested',
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medicationrequest' => 'QICoreMedicationRequest',
    # "QICoreNutritionOrder",
    'http://hl7.org/fhir/StructureDefinition/heartrate' => 'QICoreObservation',
    'http://hl7.org/fhir/StructureDefinition/bp' => 'QICoreObservation',
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-observation' => 'QICoreObservation',
    # "QICoreObservationClinicalTestResult",
    # "QICoreObservationNotDone",
    # "QICoreOrganization",
    # "QICorePatient",
    # "QICorePractitioner",
    # "QICorePractitionerRole",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-procedure' => 'QICoreProcedure',
    # "QICoreProcedureNotDone",
    # "QICoreRelatedPerson",
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-servicenotrequested' => 'QICoreServiceNotRequested',
    'http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-servicerequest' => 'QICoreServiceRequest'
  }
  profile_hash[url]
end

# ruby summary.rb --bundle qdm
options = {}
OptionParser.new do |parser|
  parser.on('-b', '--bundle [String]', String, 'fhir, qdm, or qicore') do |what|
    options[:bundle] = what
  end
end.parse!

qi_to_uscore_mappings = JSON.parse(File.read('mappings/QICoreToUSCore.json'))
generate_qicore_summary(options[:bundle], qi_to_uscore_mappings) if options[:bundle] == 'qicore'
generate_qdm_summary(options[:bundle], qi_to_uscore_mappings) if options[:bundle] == 'qdm'
