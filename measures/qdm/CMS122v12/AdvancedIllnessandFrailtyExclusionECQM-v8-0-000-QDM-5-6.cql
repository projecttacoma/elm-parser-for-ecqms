library AdvancedIllnessandFrailtyExclusionECQM version '8.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1' 
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96' 

valueset "Acute Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1083' 
valueset "Advanced Illness": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1082' 
valueset "Dementia Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1510' 
valueset "Emergency Department Evaluation and Management Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010' 
valueset "Frailty Device": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1300' 
valueset "Frailty Diagnosis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1074' 
valueset "Frailty Encounter": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1088' 
valueset "Frailty Symptom": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1075' 
valueset "Nonacute Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1084' 
valueset "Observation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1086' 
valueset "Outpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1087' 

code "Housing status": '71802-3' from "LOINC" display 'Housing status'
code "Lives in a nursing home (finding)": '160734000' from "SNOMEDCT" display 'Lives in a nursing home (finding)'
code "Medical equipment used": '98181-1' from "LOINC" display 'Medical equipment used'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Is Age 66 or Older with Advanced Illness and Frailty":
  ( AgeInYearsAt(date from 
      end of "Measurement Period"
    )>= 66
      and "Has Criteria Indicating Frailty"
      and ( "Has Two Outpatient Encounters with Advanced Illness on Different Dates of Service"
          or "Has Inpatient Encounter with Advanced Illness"
          or "Has Dementia Medications in Year Before or During Measurement Period"
      )
  )

define "Has Dementia Medications in Year Before or During Measurement Period":
  exists (["Medication, Active": "Dementia Medications"] DementiaMedication
    where Global."NormalizeInterval" ( DementiaMedication.relevantDatetime, DementiaMedication.relevantPeriod ) overlaps Interval[start of "Measurement Period" - 1 year, 
    end of "Measurement Period"])

define "Has Inpatient Encounter with Advanced Illness":
  exists( ["Encounter, Performed": "Acute Inpatient"] InpatientEncounter
    where exists ( InpatientEncounter.diagnoses Diagnosis
        where Diagnosis.code in "Advanced Illness"
    )
      and InpatientEncounter.relevantPeriod starts during day of Interval[start of "Measurement Period" - 1 year, 
      end of "Measurement Period"])

define "Outpatient Encounters with Advanced Illness":
  ( ["Encounter, Performed": "Outpatient"]
    union ["Encounter, Performed": "Observation"]
    union ["Encounter, Performed": "Emergency Department Evaluation and Management Visit"]
    union ["Encounter, Performed": "Nonacute Inpatient"] ) OutpatientEncounter
    where exists ( OutpatientEncounter.diagnoses Diagnosis
        where Diagnosis.code in "Advanced Illness"
    )
      and OutpatientEncounter.relevantPeriod starts during day of Interval[start of "Measurement Period" - 1 year, 
      end of "Measurement Period"]

define "Has Two Outpatient Encounters with Advanced Illness on Different Dates of Service":
  exists (
  from
    "Outpatient Encounters with Advanced Illness" OutpatientEncounter1,
    "Outpatient Encounters with Advanced Illness" OutpatientEncounter2
    where OutpatientEncounter2.relevantPeriod ends 1 day or more after day of 
    end of OutpatientEncounter1.relevantPeriod
    return OutpatientEncounter1
    )

define "Is Age 66 or Older Living Long Term in a Nursing Home":
  ( AgeInYearsAt(date from 
      end of "Measurement Period"
    )>= 66
  )
    and ( ( Last(["Assessment, Performed": "Housing status"] HousingStatus
          where Global."NormalizeInterval"(HousingStatus.relevantDatetime, HousingStatus.relevantPeriod)ends on or before 
          end of "Measurement Period"
          sort by 
          end of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)asc
      )) LastHousingStatus
        where LastHousingStatus.result ~ "Lives in a nursing home (finding)"
    ) is not null

define "Is Age 66 to 80 with Advanced Illness and Frailty or Is Age 81 or Older with Frailty":
  ( AgeInYearsAt(date from 
      end of "Measurement Period"
    )in Interval[66, 80]
      and "Has Criteria Indicating Frailty"
      and ( "Has Two Outpatient Encounters with Advanced Illness on Different Dates of Service"
          or "Has Inpatient Encounter with Advanced Illness"
          or "Has Dementia Medications in Year Before or During Measurement Period"
      )
  )
    or ( AgeInYearsAt(date from 
        end of "Measurement Period"
      )>= 81
        and "Has Criteria Indicating Frailty"
    )

define "Has Criteria Indicating Frailty":
  exists ( ["Device, Order": "Frailty Device"] FrailtyDeviceOrder
      where FrailtyDeviceOrder.authorDatetime during day of "Measurement Period"
  )
    or exists ( ["Assessment, Performed": "Medical equipment used"] EquipmentUsed
        where EquipmentUsed.result in "Frailty Device"
          and Global."NormalizeInterval" ( EquipmentUsed.relevantDatetime, EquipmentUsed.relevantPeriod ) ends during day of "Measurement Period"
    )
    or exists ( ["Diagnosis": "Frailty Diagnosis"] FrailtyDiagnosis
        where FrailtyDiagnosis.prevalencePeriod overlaps "Measurement Period"
    )
    or exists ( ["Encounter, Performed": "Frailty Encounter"] FrailtyEncounter
        where FrailtyEncounter.relevantPeriod overlaps "Measurement Period"
    )
    or exists ( ["Symptom": "Frailty Symptom"] FrailtySymptom
        where FrailtySymptom.prevalencePeriod overlaps "Measurement Period"
    )

