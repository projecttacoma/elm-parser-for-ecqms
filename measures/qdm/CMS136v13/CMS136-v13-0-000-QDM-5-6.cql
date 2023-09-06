library FollowUpCareforChildrenPrescribedADHDMedicationADD version '13.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '5.0.000' called Hospice
include CumulativeMedicationDuration version '2.0.000' called CMD

codesystem "RXNORM": 'urn:oid:2.16.840.1.113883.6.88'

valueset "Ambulatory": 'urn:oid:2.16.840.1.113883.3.464.1003.122.12.1003'
valueset "Atomoxetine": 'urn:oid:2.16.840.1.113883.3.464.1003.1170'
valueset "Behavioral Health Follow up Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1054'
valueset "Clonidine": 'urn:oid:2.16.840.1.113883.3.464.1003.1171'
valueset "Dexmethylphenidate": 'urn:oid:2.16.840.1.113883.3.464.1003.1172'
valueset "Dextroamphetamine": 'urn:oid:2.16.840.1.113883.3.464.1003.1173'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Guanfacine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.11.1252'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Initial Hospital Observation Care": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Lisdexamfetamine": 'urn:oid:2.16.840.1.113883.3.464.1003.1174'
valueset "Mental Behavioral and Neurodevelopmental Disorders": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1203'
valueset "Methylphenidate": 'urn:oid:2.16.840.1.113883.3.464.1003.1176'
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

code "methamphetamine hydrochloride 5 MG Oral Tablet": '977860' from "RXNORM" display 'methamphetamine hydrochloride 5 MG Oral Tablet'

parameter "Measurement Period" Interval<DateTime>

context Patient

/*Index Prescription Start Date (IPSD)*/

define "IPSD":
  date from Coalesce("First ADHD Medication Prescribed During Intake Period".relevantPeriod.low, "First ADHD Medication Prescribed During Intake Period".authorDatetime)

define "Denominator 1":
  "Initial Population 1"

define "Denominator 2":
  "Initial Population 2"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or exists ( "Narcolepsy Exclusion" )

define "Encounter During Initiation Phase":
  "Qualifying Numerator Encounter" ValidNumeratorEncounter
    where Global."ToDateInterval" ( ValidNumeratorEncounter.relevantPeriod ) starts 30 days or less after day of "IPSD"

define "First ADHD Medication Prescribed During Intake Period":
  First("ADHD Medication Prescribed During Intake Period and Not Previously on ADHD Medication")

define "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days":
  "ADHD Cumulative Medication Duration" >= 210

define "ADHD Cumulative Medication Duration":
  CMD."CumulativeDuration" ( "ADHD Medications Taken on IPSD or During Continuation and Maintenance Phase" )

define "Initial Population 1":
  AgeInYearsAt(date from start of "Intake Period")>= 6
    and AgeInYearsAt(date from 
      end of "Intake Period"
    )<= 12
    and exists "Qualifying Encounter"
    and "First ADHD Medication Prescribed During Intake Period" is not null
    and not exists "Inpatient Stay with Qualifying Diagnosis During Initiation Phase"

define "Initial Population 2":
  AgeInYearsAt(date from start of "Intake Period")>= 6
    and AgeInYearsAt(date from 
      end of "Intake Period"
    )<= 12
    and exists "Qualifying Encounter"
    and "First ADHD Medication Prescribed During Intake Period" is not null
    and "Has ADHD Cumulative Medication Duration Greater Than or Equal to 210 Days"
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
    where Global."ToDateInterval" ( InpatientStay.relevantPeriod ) starts 300 days or less after day of "IPSD"

define "Inpatient Stay with Qualifying Diagnosis During Initiation Phase":
  "Inpatient Stay with Qualifying Diagnosis" InpatientStay
    where Global."ToDateInterval" ( InpatientStay.relevantPeriod ) starts 30 days or less after day of "IPSD"

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
        or ( exists ( "Encounter 31 to 300 Days into Continuation and Maintenance Phase" Encounter1
              with "Online Assessment 31 to 300 Days into Continuation and Maintenance Phase" Encounter2
                such that Encounter1 is not null
                  and Encounter2 is not null
                  and Encounter1 !~ Encounter2
          )
        )
    )

define "Qualifying Encounter":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"] ) ValidEncounters
    where Global."ToDateInterval" ( ValidEncounters.relevantPeriod ) during day of Interval["IPSD" - 6 months, "IPSD"]

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

/*Note relevantPeriod.low represents the interval's lower boundary and its usage is to ensure appropriate evaluation of the coalesce.*/

define "ADHD Medication Prescribed During Intake Period and Not Previously on ADHD Medication":
  ( ( ["Medication, Order": "Atomoxetine"]
    union ["Medication, Order": "Clonidine"]
    union ["Medication, Order": "Dexmethylphenidate"]
    union ["Medication, Order": "Dextroamphetamine"]
    union ["Medication, Order": "Lisdexamfetamine"]
    union ["Medication, Order": "methamphetamine hydrochloride 5 MG Oral Tablet"]
    union ["Medication, Order": "Methylphenidate"]
    union ["Medication, Order": "Guanfacine"] ) ADHDMedications
    where Coalesce(ADHDMedications.relevantPeriod.low, ADHDMedications.authorDatetime)during "Intake Period" ) ADHDMedicationOrder
    without ( ["Medication, Active": "Atomoxetine"]
      union ["Medication, Active": "Clonidine"]
      union ["Medication, Active": "Dexmethylphenidate"]
      union ["Medication, Active": "Dextroamphetamine"]
      union ["Medication, Active": "Lisdexamfetamine"]
      union ["Medication, Active": "methamphetamine hydrochloride 5 MG Oral Tablet"]
      union ["Medication, Active": "Methylphenidate"]
      union ["Medication, Active": "Guanfacine"] ) ActiveADHDMedication
      such that Global."ToDateInterval" ( Global."NormalizeInterval" ( ActiveADHDMedication.relevantDatetime, ActiveADHDMedication.relevantPeriod ) ) overlaps Interval[date from Coalesce(ADHDMedicationOrder.relevantPeriod.low, ADHDMedicationOrder.authorDatetime)- 120 days, date from Coalesce(ADHDMedicationOrder.relevantPeriod.low, ADHDMedicationOrder.authorDatetime))
    sort by Coalesce(relevantPeriod.low, authorDatetime)asc

define "Encounter 31 to 300 Days into Continuation and Maintenance Phase":
  "Qualifying Numerator Encounter" ValidNumeratorEncounter
    where Global."ToDateInterval" ( ValidNumeratorEncounter.relevantPeriod ) starts during day of Interval["IPSD" + 31 days, "IPSD" + 300 days]
    return date from start of ValidNumeratorEncounter.relevantPeriod

define "Online Assessment 31 to 300 Days into Continuation and Maintenance Phase":
  ["Encounter, Performed": "Online Assessments"] OnlineAssessment
    where Global."ToDateInterval" ( OnlineAssessment.relevantPeriod ) starts during day of Interval["IPSD" + 31 days, "IPSD" + 300 days]
    return date from start of OnlineAssessment.relevantPeriod

define "ADHD Medications Taken on IPSD or During Continuation and Maintenance Phase":
  ( ( CMD."RolloutIntervals" ( ( ["Medication, Order": "Atomoxetine"] AtomoxetineMed
        return all {
          period: CMD."MedicationOrderPeriod" ( AtomoxetineMed ),
          periodStart: start of CMD."MedicationOrderPeriod" ( AtomoxetineMed )
        }
        sort by periodStart
    ).period )
  )
    union ( CMD."RolloutIntervals" ( ( ["Medication, Order": "Clonidine"] ClonidineMed
          return all {
            period: CMD."MedicationOrderPeriod" ( ClonidineMed ),
            periodStart: start of CMD."MedicationOrderPeriod" ( ClonidineMed )
          }
          sort by periodStart
      ).period )
    )
    union ( CMD."RolloutIntervals" ( ( ["Medication, Order": "Dexmethylphenidate"] DexmethylphenidateMed
          return all {
            period: CMD."MedicationOrderPeriod" ( DexmethylphenidateMed ),
            periodStart: start of CMD."MedicationOrderPeriod" ( DexmethylphenidateMed )
          }
          sort by periodStart
      ).period )
    )
    union ( CMD."RolloutIntervals" ( ( ["Medication, Order": "Dextroamphetamine"] DextroamphetamineMed
          return all {
            period: CMD."MedicationOrderPeriod" ( DextroamphetamineMed ),
            periodStart: start of CMD."MedicationOrderPeriod" ( DextroamphetamineMed )
          }
          sort by periodStart
      ).period )
    )
    union ( CMD."RolloutIntervals" ( ( ["Medication, Order": "Lisdexamfetamine"] LisdexamfetamineMed
          return all {
            period: CMD."MedicationOrderPeriod" ( LisdexamfetamineMed ),
            periodStart: start of CMD."MedicationOrderPeriod" ( LisdexamfetamineMed )
          }
          sort by periodStart
      ).period )
    )
    union ( CMD."RolloutIntervals" ( ( ["Medication, Order": "Methylphenidate"] MethylphenidateMed
          return all {
            period: CMD."MedicationOrderPeriod" ( MethylphenidateMed ),
            periodStart: start of CMD."MedicationOrderPeriod" ( MethylphenidateMed )
          }
          sort by periodStart
      ).period )
    )
    union ( CMD."RolloutIntervals" ( ( ["Medication, Order": "Guanfacine"] GuanfacineMed
          return all {
            period: CMD."MedicationOrderPeriod" ( GuanfacineMed ),
            periodStart: start of CMD."MedicationOrderPeriod" ( GuanfacineMed )
          }
          sort by periodStart
      ).period )
    )
    union ( CMD."RolloutIntervals" ( ( ["Medication, Order": "methamphetamine hydrochloride 5 MG Oral Tablet"] MethamphetamineMed
          return all {
            period: CMD."MedicationOrderPeriod" ( MethamphetamineMed ),
            periodStart: start of CMD."MedicationOrderPeriod" ( MethamphetamineMed )
          }
          sort by periodStart
      ).period )
    ) ) ADHDMedication
    let IPSDAndContinuationMaintenancePhase: Interval["IPSD", "IPSD" + 300 days]
    return all ADHDMedication
      intersect IPSDAndContinuationMaintenancePhase