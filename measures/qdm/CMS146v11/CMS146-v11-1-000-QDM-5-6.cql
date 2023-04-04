library AppropriateTestingforPharyngitis version '11.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Acute Pharyngitis": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1011'
valueset "Acute Tonsillitis": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1012'
valueset "Antibiotic Medications for Pharyngitis": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1001'
valueset "Comorbid Conditions for Respiratory Conditions": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1025'
valueset "Competing Conditions for Respiratory Conditions": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1017'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Group A Streptococcus Test": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1012'
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

code "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])": '99217' from "CPT" display 'Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Group A Streptococcus Lab Test With Result":
  ["Laboratory Test, Performed": "Group A Streptococcus Test"] GroupAStreptococcusTest
    where GroupAStreptococcusTest.result is not null

define "In Hospice":
  "Initial Population" EligibleEncounters
    where Hospice."Has Hospice Services"

define "Pharyngitis or Tonsillitis":
  ( ["Diagnosis": "Acute Pharyngitis"]
      union ["Diagnosis": "Acute Tonsillitis"]
  )

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Denominator Exclusions":
  "In Hospice"
    union "Encounter With Antibiotic Active In 30 Days Prior Or The First Day of the Encounter"
    union "Encounter With Competing Diagnosis for Upper Respiratory Infection"
    union "Encounter With Comorbid Condition Prior"

define "Encounter With Competing Diagnosis for Upper Respiratory Infection":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    with ["Diagnosis": "Competing Conditions for Respiratory Conditions"] CompetingCondition
      such that CompetingCondition.prevalencePeriod starts 3 days or less on or after day of start of EncounterWithPharyngitis.relevantPeriod
    return EncounterWithPharyngitis

define "Encounter With Comorbid Condition Prior":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    with ["Diagnosis": "Comorbid Conditions for Respiratory Conditions"] ComorbidCondition
      such that start of ComorbidCondition.prevalencePeriod in day of Interval[start of EncounterWithPharyngitis.relevantPeriod - 1 year, start of EncounterWithPharyngitis.relevantPeriod]
    return EncounterWithPharyngitis

define "Numerator":
  from
    "Group A Streptococcus Lab Test With Result" GroupAStreptococcusTest,
    "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where ( Global."NormalizeInterval" ( GroupAStreptococcusTest.relevantDatetime, GroupAStreptococcusTest.relevantPeriod ) starts during day of Interval[( 
        end of EncounterWithPharyngitis.relevantPeriod
      ) - 3 days, ( 
        end of EncounterWithPharyngitis.relevantPeriod
      ) + 3 days]
    )
    return EncounterWithPharyngitis

define "Encounter With Antibiotic Ordered Within Three Days":
  "Qualifying Encounters" EDOrAmbulatoryVisit
    with ["Medication, Order": "Antibiotic Medications for Pharyngitis"] AntibioticOrdered
      such that ( start of EDOrAmbulatoryVisit.relevantPeriod ) 3 days or less on or before day of AntibioticOrdered.authorDatetime

define "Encounter With Pharyngitis or Tonsillitis With Antibiotic":
  from
    "Encounter With Antibiotic Ordered Within Three Days" VisitWithAntibiotic,
    "Pharyngitis or Tonsillitis" AcutePharyngitisTonsillitis
    where AcutePharyngitisTonsillitis.prevalencePeriod starts during day of VisitWithAntibiotic.relevantPeriod
    return VisitWithAntibiotic

define "Initial Population":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where AgeInYearsAt(date from start of "Measurement Period")>= 3
    return EncounterWithPharyngitis

define "Stratification 1":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where AgeInYearsAt(date from start of "Measurement Period")in Interval[3, 17]
    return EncounterWithPharyngitis

define "Stratification 2":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where AgeInYearsAt(date from start of "Measurement Period")in Interval[18, 64]
    return EncounterWithPharyngitis

define "Stratification 3":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    where AgeInYearsAt(date from start of "Measurement Period")>= 65
    return EncounterWithPharyngitis

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])"]
    union ["Encounter, Performed": "Emergency Department Visit"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Initial Hospital Observation Care"]
    union ["Encounter, Performed": "Medical Disability Exam"]
    union ["Encounter, Performed": "Observation"]
    union ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Telephone Visits"]
    union ["Encounter, Performed": "Online Assessments"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Group Counseling"]
    union ["Encounter, Performed": "Unlisted preventive medicine service"]
    union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services Individual Counseling"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "Encounter With Antibiotic Active In 30 Days Prior Or The First Day of the Encounter":
  "Encounter With Pharyngitis or Tonsillitis With Antibiotic" EncounterWithPharyngitis
    with ["Medication, Active": "Antibiotic Medications for Pharyngitis"] ActiveAntibiotic
      such that ( Global."NormalizeInterval" ( ActiveAntibiotic.relevantDatetime, ActiveAntibiotic.relevantPeriod ) overlaps day of Interval[start of EncounterWithPharyngitis.relevantPeriod - 30 days, start of EncounterWithPharyngitis.relevantPeriod - 1 day])
    return EncounterWithPharyngitis