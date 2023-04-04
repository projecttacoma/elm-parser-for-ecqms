library FollowUpCareforChildrenPrescribedADHDMedicationADD version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice
include CumulativeMedicationDuration version '1.0.000' called CMD

codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "ADHD Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1171'
valueset "Ambulatory": 'urn:oid:2.16.840.1.113883.3.464.1003.122.12.1003'
valueset "Behavioral Health Follow up Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1054'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Initial Hospital Observation Care": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Mental Behavioral and Neurodevelopmental Disorders": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1203'
valueset "Narcolepsy": 'urn:oid:2.16.840.1.113883.3.464.1003.114.12.1011'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Group Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1027'
valueset "Preventive Care Services Individual Counseling": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1026'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Psych Visit Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Psychotherapy and Pharmacologic Management": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1055'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])": '99217' from "CPT" display 'Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])'

parameter "Measurement Period" Interval<DateTime>

context Patient

/*Note relevantPeriod.low represents the interval's lower boundary and its usage is to ensure appropriate evaluation of the coalesce.*/

define "ADHD Medication Prescribed During Intake Period":
  ["Medication, Order": "ADHD Medications"] ADHDMedicationOrder
    where Coalesce(ADHDMedicationOrder.relevantPeriod.low, ADHDMedicationOrder.authorDatetime)during "Intake Period"
    sort by Coalesce(relevantPeriod.low, authorDatetime)asc

define "ADHD Medications Taken on IPSD or During Continuation and Maintenance Phase":
  "ADHD Medication Prescribed During Intake Period" ADHDMedication
    let IPSD: date from Coalesce("First ADHD Medication Prescribed During Intake Period".relevantPeriod.low, "First ADHD Medication Prescribed During Intake Period".authorDatetime),
    IPSDAndContinuationMaintenancePhase: Interval[IPSD, IPSD + 300 days]
    return CMD."MedicationOrderPeriod" ( ADHDMedication )
      intersect IPSDAndContinuationMaintenancePhase

define "Denominator 1":
  "Initial Population 1"

define "Denominator 2":
  "Initial Population 2"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or exists ( "Narcolepsy Exclusion" )

define "Encounter 31 to 300 Days into Continuation and Maintenance Phase":
  "Qualifying Numerator Encounter" ValidNumeratorEncounter
    with "First ADHD Medication Prescribed During Intake Period" InitialADHDMedication
      such that ValidNumeratorEncounter.relevantPeriod starts during day of Interval[Coalesce("InitialADHDMedication".relevantPeriod.low, "InitialADHDMedication".authorDatetime)+ 31 days, Coalesce("InitialADHDMedication".relevantPeriod.low, "InitialADHDMedication".authorDatetime)+ 300 days]

define "Encounter During Initiation Phase":
  ( "Qualifying Numerator Encounter" ValidNumeratorEncounter
      with "First ADHD Medication Prescribed During Intake Period" InitialADHDMedication
        such that ValidNumeratorEncounter.relevantPeriod starts 30 days or less after day of Coalesce(InitialADHDMedication.relevantPeriod.low, InitialADHDMedication.authorDatetime)
  )

define "First ADHD Medication Prescribed During Intake Period":
  First("ADHD Medication Prescribed During Intake Period")

define "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days":
  CMD."CumulativeDuration" ( "ADHD Medications Taken on IPSD or During Continuation and Maintenance Phase" ) >= 210

define "Initial Population 1":
  AgeInYearsAt(date from start of "Intake Period")>= 6
    and AgeInYearsAt(date from 
      end of "Intake Period"
    )<= 12
    and exists "Qualifying Encounter"
    and "First ADHD Medication Prescribed During Intake Period" is not null
    and not exists "Previously on ADHD Medication"
    and not exists "Inpatient Stay with Qualifying Diagnosis During Initiation Phase"

define "Initial Population 2":
  AgeInYearsAt(date from start of "Intake Period")>= 6
    and AgeInYearsAt(date from 
      end of "Intake Period"
    )<= 12
    and exists "Qualifying Encounter"
    and "First ADHD Medication Prescribed During Intake Period" is not null
    and "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days"
    and not exists "Previously on ADHD Medication"
    and not exists "Inpatient Stay with Qualifying Diagnosis During Continuation and Maintenance Phase"

define "Inpatient Stay with Qualifying Diagnosis":
  ( ["Encounter, Performed": "Encounter Inpatient"] InpatientStay
      where exists ( InpatientStay.diagnoses EncounterDiagnoses
          where ( EncounterDiagnoses.rank = 1
              and EncounterDiagnoses.code in "Mental Behavioral and Neurodevelopmental Disorders"
          )
      )
  )

define "Inpatient Stay with Qualifying Diagnosis During Continuation and Maintenance Phase":
  "Inpatient Stay with Qualifying Diagnosis" InpatientStay
    with "First ADHD Medication Prescribed During Intake Period" InitialADHDMedication
      such that InpatientStay.relevantPeriod starts 300 days or less after day of Coalesce("InitialADHDMedication".relevantPeriod.low, "InitialADHDMedication".authorDatetime)

define "Inpatient Stay with Qualifying Diagnosis During Initiation Phase":
  "Inpatient Stay with Qualifying Diagnosis" InpatientStay
    with "First ADHD Medication Prescribed During Intake Period" InitialADHDMedication
      such that InpatientStay.relevantPeriod starts 30 days or less after day of Coalesce(InitialADHDMedication.relevantPeriod.low, InitialADHDMedication.authorDatetime)

define "Intake Period":
  Interval["March 1 of Year Prior to Measurement Period", "Last Calendar Day of February of Measurement Period"]

define "Last Calendar Day of February of Measurement Period":
  ( DateTime(year from start of "Measurement Period", 3, 1, 23, 59, 59, 0, 0)) - 1 day

define "March 1 of Year Prior to Measurement Period":
  DateTime((year from start of "Measurement Period" - 1), 3, 1, 0, 0, 0, 0, 0)

define "Narcolepsy Exclusion":
  ["Diagnosis": "Narcolepsy"] Narcolepsy
    where Narcolepsy.prevalencePeriod starts on or before 
    end "Measurement Period"

define "Numerator 1":
  exists ( "Encounter During Initiation Phase" )

define "Numerator 2":
  exists ( "Encounter During Initiation Phase" )
    and ( ( "Two or More Encounters 31 to 300 Days into Continuation and Maintenance Phase" )
        or ( exists ( "Encounter 31 to 300 Days into Continuation and Maintenance Phase" )
            and exists ( "Online Assessment 31 to 300 Days into Continuation and Maintenance Phase" )
        )
    )

define "Online Assessment 31 to 300 Days into Continuation and Maintenance Phase":
  ["Encounter, Performed": "Online Assessments"] OnlineAssessment
    with "First ADHD Medication Prescribed During Intake Period" InitialADHDMedication
      such that OnlineAssessment.relevantPeriod starts during day of Interval[Coalesce("InitialADHDMedication".relevantPeriod.low, "InitialADHDMedication".authorDatetime)+ 31 days, Coalesce("InitialADHDMedication".relevantPeriod.low, "InitialADHDMedication".authorDatetime)+ 300 days]

define "Previously on ADHD Medication":
  ["Medication, Active": "ADHD Medications"] ActiveADHDMedication
    with "First ADHD Medication Prescribed During Intake Period" InitialADHDMedication
      such that Global."ToDateInterval" ( Global."NormalizeInterval" ( ActiveADHDMedication.relevantDatetime, ActiveADHDMedication.relevantPeriod ) ) overlaps Interval[date from Coalesce(InitialADHDMedication.relevantPeriod.low, InitialADHDMedication.authorDatetime)- 120 days, date from Coalesce(InitialADHDMedication.relevantPeriod.low, InitialADHDMedication.authorDatetime))

define "Qualifying Encounter":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during "Measurement Period"

define "Qualifying Numerator Encounter":
  ( ["Encounter, Performed": "Office Visit"]
      union ["Encounter, Performed": "Initial Hospital Observation Care"]
      union ["Encounter, Performed": "Preventive Care Services Group Counseling"]
      union ["Encounter, Performed": "Behavioral Health Follow up Visit"]
      union ["Encounter, Performed": "Preventive Care Services Individual Counseling"]
      union ( ["Encounter, Performed": "Psychotherapy and Pharmacologic Management"] PsychPharmManagement
          where exists ( PsychPharmManagement.facilityLocations Location
              where Location.code in "Ambulatory"
          )
      )
      union ["Encounter, Performed": "Observation care discharge day management (This code is to be utilized to report all services provided to a patient on discharge from outpatient hospital observation status if the discharge is on other than the initial date of observation status. To report services to a patient designated as observation status or inpatient status and discharged on the same date, use the codes for Observation or Inpatient Care Services [including Admission and Discharge Services, 99234-99236 as appropriate.])"]
      union ["Encounter, Performed": "Outpatient Consultation"]
      union ["Encounter, Performed": "Home Healthcare Services"]
      union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
      union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
      union ["Encounter, Performed": "Psych Visit Diagnostic Evaluation"]
      union ["Encounter, Performed": "Psych Visit Psychotherapy"]
      union ["Encounter, Performed": "Telephone Visits"]
  )

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Two or More Encounters 31 to 300 Days into Continuation and Maintenance Phase":
  Count("Encounter 31 to 300 Days into Continuation and Maintenance Phase")>= 2