library PalliativeCareExclusionECQM version '2.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "ICD10CM": 'urn:oid:2.16.840.1.113883.6.90' 
codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1' 

valueset "Palliative Care Encounter": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1090' 
valueset "Palliative Care Intervention": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1135' 

code "Encounter for palliative care": 'Z51.5' from "ICD10CM" display 'Encounter for palliative care'
code "Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)": '71007-9' from "LOINC" display 'Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Palliative Care in the Measurement Period":
  exists ( ["Assessment, Performed": "Functional Assessment of Chronic Illness Therapy - Palliative Care Questionnaire (FACIT-Pal)"] PalliativeAssessment
      where Global."NormalizeInterval"(PalliativeAssessment.relevantDatetime, PalliativeAssessment.relevantPeriod) overlaps "Measurement Period"
  )
  or exists (["Diagnosis": "Encounter for palliative care"] PalliativeDiagnosis
  where PalliativeDiagnosis.prevalencePeriod overlaps "Measurement Period")
    or exists ( ["Encounter, Performed": "Palliative Care Encounter"] PalliativeEncounter
        where PalliativeEncounter.relevantPeriod overlaps "Measurement Period"
    )
    or exists ( ["Intervention, Performed": "Palliative Care Intervention"] PalliativeIntervention
        where Global."NormalizeInterval"(PalliativeIntervention.relevantDatetime, PalliativeIntervention.relevantPeriod) overlaps "Measurement Period"
    )

