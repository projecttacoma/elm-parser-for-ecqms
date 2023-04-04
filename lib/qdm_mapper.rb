# frozen_string_literal: true

class QdmDataElementMap
  attr_accessor :qdm_concept, :qi_profile, :us_core_profile, :fhir_resource,:negation_qi_profile
  attr_reader :attributes

  def initialize(qdm_concept, qi_profile, us_core_profile, fhir_resource)
    @qdm_concept = qdm_concept
    @qi_profile = qi_profile
    @us_core_profile = us_core_profile
    @fhir_resource = fhir_resource
    @attributes = []
  end

  def add_attribute(qdm_attribute, qi_field)
    @attributes << QdmAttributeMap.new(qdm_attribute, qi_field)
  end

  def get_attribute(qdm_attribute)
    @attributes.select { |att| att.qdm_attribute == qdm_attribute }
  end
end

class QdmAttributeMap
  attr_accessor :qdm_attribute, :qi_field

  def initialize(qdm_attribute, qi_field)
    @qdm_attribute = qdm_attribute
    @qi_field = qi_field
  end
end

class QdmMapper
  attr_reader :qdm_data_elements

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def initialize
    @qdm_data_elements = []
    prior_qdm_attribute = nil
    CSV.parse(File.read('mappings/QDMtoQICore.tsv'), headers: true, col_sep: "\t").each do |row|
      qdm_concept = row[0].nil? ? '' : row[0].strip
      qdm_data_element = get_qdm_data_elements(qdm_concept)
      if qdm_data_element.nil?
        qi_profile = row[3].nil? ? '' : row[3].strip
        us_core = ['#N/A', '0'].include?(row[8]) ? '' : row[8]
        resource = ['#N/A', '0'].include?(row[11]) ? '' : row[11]
        qdm_data_element = QdmDataElementMap.new(qdm_concept, qi_profile, us_core, resource)
        @qdm_data_elements << qdm_data_element
      end

      qdm_attribute = row[2].nil? ? '' : row[2].strip
      qdm_attribute = qdm_attribute.strip.empty? ? prior_qdm_attribute : qdm_attribute
      qdm_attribute = 'QDMContext' if row[1] == 'C'
      next if qdm_attribute.include?('*')
      next if qdm_attribute.include?(qdm_concept)
      next if qdm_attribute == ''

      qdm_attribute = qdm_attribute.gsub(/ /, '').downcase
      qdm_data_element.negation_qi_profile = row[3].strip if qdm_attribute == 'negationrationale'
      prior_qdm_attribute = qdm_attribute
      temp_qi_field = row[5].nil? ? '' : row[5].strip
      qi_field = temp_qi_field == '' ? row[4].strip : row[5].strip
      qdm_data_element.add_attribute(qdm_attribute.gsub(/ /, '').downcase, qi_field)
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  def get_qdm_data_elements(qdm_concept)
    @qdm_data_elements.select { |dt| dt.qdm_concept == qdm_concept }.first
  end

  def mapped_attribute_name(qdm_attribute)
    mapped_attribute = { 'diagnoses' => 'diagnosis(code)' }
    return mapped_attribute[qdm_attribute] if mapped_attribute[qdm_attribute]

    qdm_attribute.gsub(/ /, '')
  end

  # rubocop:disable Metrics/MethodLength
  def qdm_profile_attribute_as_qi_core(qdm_profile_name, qdm_attribute)
    qdm_attribute = 'expirationdatetime' if qdm_attribute == 'expiredDatetime'
    profile_name_map = {
      'AdverseEvent' => 'Adverse Event',
      'AllergyIntolerance' => 'Allergy/Intolerance',
      'Diagnosis' => 'Condition - Diagnosis - Problem',
      'MedicationActive' => 'Medication, Active',
      'NegativeAssessmentPerformed' => 'Assessment, Performed: General Use Case',
      'NegativeCommunicationPerformed' => 'Communication, Performed',
      'NegativeDeviceOrder' => 'Device, Order',
      'NegativeDiagnosticStudyOrder' => 'Diagnostic Study, Order',
      'NegativeDiagnosticStudyPerformed' => 'Diagnostic Study, Performed',
      'NegativeInterventionOrder' => 'Intervention, Order',
      'NegativeInterventionPerformed' => 'Intervention, Performed',
      'NegativeLaboratoryTestOrder' => 'Laboratory Test, Order',
      'NegativeMedicationAdministered' => 'Medication, Administered',
      'NegativeMedicationDischarge' => 'Medication, Discharge',
      'NegativeMedicationOrder' => 'Medication, Order',
      'NegativePhysicalExamPerformed' => 'Physical Exam, Performed - General',
      'NegativeProcedurePerformed' => 'Procedure, Performed',
      'PatientCharacteristicBirthdate' => 'Birthdate',
      'PatientCharacteristicEthnicity' => 'Ethnicity',
      'PatientCharacteristicExpired' => 'Expired',
      'PatientCharacteristicPayer' => 'Payer',
      'PatientCharacteristicRace' => 'Race',
      'PatientCharacteristicSex' => 'Sex',
      'PositiveAssessmentPerformed' => 'Assessment, Performed: General Use Case',
      'PositiveCommunicationPerformed' => 'Communication, Performed',
      'PositiveDeviceOrder' => 'Device, Order',
      'PositiveDiagnosticStudyOrder' => 'Diagnostic Study, Order',
      'PositiveDiagnosticStudyPerformed' => 'Diagnostic Study, Performed',
      'PositiveEncounterOrder' => 'Encounter, Order',
      'PositiveEncounterPerformed' => 'Encounter, Performed',
      'PositiveImmunizationAdministered' => 'Immunization, Administered',
      'PositiveInterventionOrder' => 'Intervention, Order',
      'PositiveInterventionPerformed' => 'Intervention, Performed',
      'PositiveLaboratoryTestOrder' => 'Laboratory Test, Order',
      'PositiveLaboratoryTestPerformed' => 'Laboratory Test, Performed',
      'PositiveMedicationAdministered' => 'Medication, Administered',
      'PositiveMedicationDischarge' => 'Medication, Discharge',
      'PositiveMedicationDispensed' => 'Medication, Dispensed',
      'PositiveMedicationOrder' => 'Medication, Order',
      'PositivePhysicalExamPerformed' => 'Physical Exam, Performed - General',
      'PositiveProcedureOrder' => 'Procedure, Order',
      'PositiveProcedurePerformed' => 'Procedure, Performed',
      'PositiveSubstanceAdministered' => 'Substance, Administered',
      'Symptom' => 'Symptom'
    }

    qdm_element = get_qdm_data_elements(profile_name_map[qdm_profile_name])
    return unless qdm_element
    attributes = qdm_element.get_attribute(qdm_attribute.downcase)
    [qdm_element.qi_profile, attributes, qdm_element.negation_qi_profile]
  end
  # rubocop:enable Metrics/MethodLength
end
