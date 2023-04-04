library AppropriateTreatmentforUpperRespiratoryInfectionURI version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Antibiotic Medications for Pharyngitis": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1001'
valueset "Comorbid Conditions for Respiratory Conditions": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1025'
valueset "Competing Conditions for Respiratory Conditions": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1017'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Initial Hospital Observation Care": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Medical Disability Exam": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1073'
valueset "Observation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1086'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Upper Respiratory Infection": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1022'

code "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])": '99217' from "CPT" display 'Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  "In Hospice"
    union "Encounter with Upper Respiratory Infection and Antibiotics Active 30 Days Prior Or The First Day of the Encounter"
    union "Encounter with Competing Diagnosis for Upper Respiratory Infection"
    union "Encounter with Comorbid Condition for Upper Respiratory Infection Prior"

define "Encounter with Competing Diagnosis for Upper Respiratory Infection":
  ( "Encounter with Upper Respiratory Infection" EncounterWithURI
      with ["Diagnosis": "Competing Conditions for Respiratory Conditions"] CompetingCondition
        such that CompetingCondition.prevalencePeriod starts 3 days or less on or after day of start of EncounterWithURI.relevantPeriod
      return EncounterWithURI
  )

define "In Hospice":
  "Initial Population" InitialPopulation
    where Hospice."Has Hospice Services"

define "Initial Population":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    where AgeInMonthsAt(date from start of "Measurement Period")>= 3
    return EncounterWithURI

define "Numerator":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    without ["Medication, Order": "Antibiotic Medications for Pharyngitis"] OrderedAntibiotic
      such that OrderedAntibiotic.authorDatetime 3 days or less on or after start of EncounterWithURI.relevantPeriod
    return EncounterWithURI

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Stratification 1":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    where AgeInMonthsAt(date from start of "Measurement Period")>= 3
      and AgeInYearsAt(date from start of "Measurement Period")<= 17
    return EncounterWithURI

define "Stratification 2":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    where AgeInYearsAt(date from start of "Measurement Period")in Interval[18, 64]
    return EncounterWithURI

define "Stratification 3":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    where AgeInYearsAt(date from start of "Measurement Period")>= 65
    return EncounterWithURI

define "Encounter with Comorbid Condition for Upper Respiratory Infection Prior":
  ( "Encounter with Upper Respiratory Infection" EncounterWithURI
      with ["Diagnosis": "Comorbid Conditions for Respiratory Conditions"] ComorbidCondition
        such that start of ComorbidCondition.prevalencePeriod in day of Interval[start of EncounterWithURI.relevantPeriod - 1 year, start of EncounterWithURI.relevantPeriod]
      return EncounterWithURI
  )

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])"]
    union ["Encounter, Performed": "Emergency Department Visit"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Initial Hospital Observation Care"]
    union ["Encounter, Performed": "Medical Disability Exam"]
    union ["Encounter, Performed": "Observation"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Preventive Care Services Group Counseling"]
    union ["Encounter, Performed": "Preventive Care Services Individual Counseling"]
    union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Telephone Visits"]
    union ["Encounter, Performed": "Online Assessments"]
    union ["Encounter, Performed": "Unlisted preventive medicine service"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "Encounter with Upper Respiratory Infection":
  from
    "Qualifying Encounters" QualifyingEncounters,
    ["Diagnosis": "Upper Respiratory Infection"] URI
    where URI.prevalencePeriod starts during day of QualifyingEncounters.relevantPeriod
      or URI.prevalencePeriod overlaps before QualifyingEncounters.relevantPeriod
    return QualifyingEncounters

define "Encounter with Upper Respiratory Infection and Antibiotics Active 30 Days Prior Or The First Day of the Encounter":
  "Encounter with Upper Respiratory Infection" EncounterWithURI
    with ["Medication, Active": "Antibiotic Medications for Pharyngitis"] ActiveAntibiotic
      such that ( Global."NormalizeInterval" ( ActiveAntibiotic.relevantDatetime, ActiveAntibiotic.relevantPeriod ) overlaps day of Interval[start of EncounterWithURI.relevantPeriod - 30 days, start of EncounterWithURI.relevantPeriod - 1 day])
    return EncounterWithURI