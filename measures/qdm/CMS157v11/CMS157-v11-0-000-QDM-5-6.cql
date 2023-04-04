library OncologyPainIntensityQuantified version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.1010'
valueset "Chemotherapy Administration": 'urn:oid:2.16.840.1.113883.3.526.3.1027'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Radiation Treatment Management": 'urn:oid:2.16.840.1.113883.3.526.3.1026'
valueset "Standardized Pain Assessment Tool": 'urn:oid:2.16.840.1.113883.3.526.3.1028'

code "Radiation treatment management, 5 treatments": '77427' from "CPT" display 'Radiation treatment management, 5 treatments'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator 1":
  "Initial Population 1"

define "Denominator 2":
  "Initial Population 2"

define "Initial Population 1":
  "Face to Face or Telehealth Encounter with Ongoing Chemotherapy"

define "Initial Population 2":
  "Radiation Treatment Management During Measurement Period with Cancer Diagnosis"

define "Numerator 1":
  "Face to Face or Telehealth Encounter with Ongoing Chemotherapy" FaceToFaceOrTelehealthEncounterWithChemo
    with ["Assessment, Performed": "Standardized Pain Assessment Tool"] PainAssessed
      such that Global."NormalizeInterval" ( PainAssessed.relevantDatetime, PainAssessed.relevantPeriod ) during FaceToFaceOrTelehealthEncounterWithChemo.relevantPeriod
        and PainAssessed.result is not null

define "Radiation Treatment Management During Measurement Period with Cancer Diagnosis":
  ["Encounter, Performed": "Radiation Treatment Management"] RadiationTreatmentManagement
    with ["Diagnosis": "Cancer"] Cancer
      such that Cancer.prevalencePeriod overlaps RadiationTreatmentManagement.relevantPeriod
    where RadiationTreatmentManagement.relevantPeriod during "Measurement Period"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Numerator 2":
  ( "Radiation Treatment Management During Measurement Period with Cancer Diagnosis" RadiationTherapy
      with ["Assessment, Performed": "Standardized Pain Assessment Tool"] PainAssessed
        such that Global."NormalizeInterval" ( PainAssessed.relevantDatetime, PainAssessed.relevantPeriod ) during RadiationTherapy.relevantPeriod
          and PainAssessed.result is not null
  )
    union ( ["Encounter, Performed": "Radiation treatment management, 5 treatments"] RadiationTreatment
        with ["Assessment, Performed": "Standardized Pain Assessment Tool"] PainAssessed
          such that Global."NormalizeInterval" ( PainAssessed.relevantDatetime, PainAssessed.relevantPeriod ) 6 days or less on or before day of start of RadiationTreatment.relevantPeriod
            and PainAssessed.result is not null
        where RadiationTreatment.relevantPeriod during "Measurement Period"
    )

define "Chemotherapy Within 31 Days Prior and During Measurement Period":
  ["Procedure, Performed": "Chemotherapy Administration"] ChemoAdministration
    where Global."NormalizeInterval" ( ChemoAdministration.relevantDatetime, ChemoAdministration.relevantPeriod ) during Interval[start of "Measurement Period" - 31 days, 
    end of "Measurement Period"]

define "Face to Face or Telehealth Encounter with Ongoing Chemotherapy":
  from
    ["Encounter, Performed": "Office Visit"] FaceToFaceOrTelehealthEncounter,
    "Chemotherapy Within 31 Days Prior and During Measurement Period" ChemoBeforeEncounter,
    "Chemotherapy Within 31 Days Prior and During Measurement Period" ChemoAfterEncounter,
    ["Diagnosis": "Cancer"] Cancer
    where Global."NormalizeInterval" ( ChemoBeforeEncounter.relevantDatetime, ChemoBeforeEncounter.relevantPeriod ) starts 30 days or less on or before day of 
    end of FaceToFaceOrTelehealthEncounter.relevantPeriod
      and Global."NormalizeInterval" ( ChemoAfterEncounter.relevantDatetime, ChemoAfterEncounter.relevantPeriod ) starts 30 days or less on or after day of 
      end of FaceToFaceOrTelehealthEncounter.relevantPeriod
      and not ( Global."NormalizeInterval" ( ChemoAfterEncounter.relevantDatetime, ChemoAfterEncounter.relevantPeriod ) same day as Global."NormalizeInterval" ( ChemoBeforeEncounter.relevantDatetime, ChemoBeforeEncounter.relevantPeriod ) )
      and Cancer.prevalencePeriod overlaps FaceToFaceOrTelehealthEncounter.relevantPeriod
      and FaceToFaceOrTelehealthEncounter.relevantPeriod during "Measurement Period"
    return FaceToFaceOrTelehealthEncounter