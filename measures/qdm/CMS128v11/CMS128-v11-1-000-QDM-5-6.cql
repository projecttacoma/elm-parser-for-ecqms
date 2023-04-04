library AntidepressantMedicationManagement version '11.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice
include CumulativeMedicationDuration version '1.0.000' called CMD

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Antidepressant Medication": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1213'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Major Depression": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1007'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psych Visit Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Denominator":
  "Initial Population"

define "Initial Population":
  AgeInYearsAt(date from "April 30 of the Measurement Period")>= 18
    and "Has Initial Major Depression Diagnosis"
    and exists "Qualifying Encounters"

define "Intake Period":
  Interval["May 1 of the Year Prior to the Measurement Period", "April 30 of the Measurement Period"]

define "May 1 of the Year Prior to the Measurement Period":
  DateTime((year from start of "Measurement Period" - 1), 5, 1, 0, 0, 0, 0, 0)

define "April 30 of the Measurement Period":
  DateTime((year from start of "Measurement Period"), 4, 30, 23, 59, 59, 0, 0)

define "Numerator 2":
  "Cumulative Medication Duration Greater Than or Equal to 180 Days"

define "Numerator 1":
  "Cumulative Medication Duration Greater Than or Equal to 84 Days"

define "Cumulative Medication Duration Greater Than or Equal to 180 Days":
  CMD."CumulativeDuration" ( "Antidepressant Medication Period Between IPSD and 231 Days After IPSD" ) >= 180

define "Cumulative Medication Duration Greater Than or Equal to 84 Days":
  CMD."CumulativeDuration" ( "Antidepressant Medication Period Between IPSD and 114 Days After IPSD" ) >= 84

define "Has Initial Major Depression Diagnosis":
  exists ( ["Diagnosis": "Major Depression"] MajorDepression
      let IPSD: date from start of Global."NormalizeInterval" ( "Earliest Antidepressant Dispensed During Intake Period".relevantDatetime, "Earliest Antidepressant Dispensed During Intake Period".relevantPeriod )
      where IPSD is not null
        and date from start of MajorDepression.prevalencePeriod within 60 days of IPSD
  )

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Psych Visit Diagnostic Evaluation"]
    union ["Encounter, Performed": "Psych Visit Psychotherapy"]
    union ["Encounter, Performed": "Telephone Visits"]
    union ["Encounter, Performed": "Online Assessments"] ) ValidEncounter
    let IPSD: date from start of Global."NormalizeInterval" ( "Earliest Antidepressant Dispensed During Intake Period".relevantDatetime, "Earliest Antidepressant Dispensed During Intake Period".relevantPeriod )
    where date from start of ValidEncounter.relevantPeriod within 60 days of IPSD

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or exists ( ["Medication, Active": "Antidepressant Medication"] ActiveAntidepressant
        let ActiveMedPeriod: ActiveAntidepressant Meds
          return Meds.relevantPeriod
            intersect Interval[start of "Intake Period", 
            end of "Measurement Period"],
        IPSD: date from start of Global."NormalizeInterval" ( "Earliest Antidepressant Dispensed During Intake Period".relevantDatetime, "Earliest Antidepressant Dispensed During Intake Period".relevantPeriod )
        where IPSD is not null
          and Global."ToDateInterval" ( ActiveMedPeriod ) overlaps Interval[IPSD - 105 days, IPSD )
    )

define "Antidepressant Medication Period Between IPSD and 114 Days After IPSD":
  ["Medication, Dispensed": "Antidepressant Medication"] Antidepressant
    let IPSD: date from start of Global."NormalizeInterval" ( "Earliest Antidepressant Dispensed During Intake Period".relevantDatetime, "Earliest Antidepressant Dispensed During Intake Period".relevantPeriod ),
    MedicationPeriod: CMD."MedicationDispensedPeriod" ( Antidepressant )
    return MedicationPeriod
      intersect Interval[IPSD, IPSD + 114 days]

define "Antidepressant Medication Period Between IPSD and 231 Days After IPSD":
  ["Medication, Dispensed": "Antidepressant Medication"] Antidepressant
    let IPSD: date from start of Global."NormalizeInterval" ( "Earliest Antidepressant Dispensed During Intake Period".relevantDatetime, "Earliest Antidepressant Dispensed During Intake Period".relevantPeriod ),
    MedicationPeriod: CMD."MedicationDispensedPeriod" ( Antidepressant )
    return MedicationPeriod
      intersect Interval[IPSD, IPSD + 231 days]

define "Earliest Antidepressant Dispensed During Intake Period":
  First(["Medication, Dispensed": "Antidepressant Medication"] Antidepressant
      where start of Global."NormalizeInterval"(Antidepressant.relevantDatetime, Antidepressant.relevantPeriod)in day of "Intake Period"
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )