library KidneyHealthEvaluation version '2.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '5.0.000' called Hospice
include PalliativeCareExclusionECQM version '3.0.000' called PalliativeCare

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Chronic Kidney Disease, Stage 5": 'urn:oid:2.16.840.1.113883.3.526.3.1002'
valueset "Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "End Stage Renal Disease": 'urn:oid:2.16.840.1.113883.3.526.3.353'
valueset "Estimated Glomerular Filtration Rate": 'urn:oid:2.16.840.1.113883.3.6929.3.1000'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Urine Albumin Creatinine Ratio": 'urn:oid:2.16.840.1.113883.3.6929.3.1007'

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

define "Has Outpatient Visit During Measurement Period":
  exists ( ( ["Encounter, Performed": "Annual Wellness Visit"]
      union ["Encounter, Performed": "Home Healthcare Services"]
      union ["Encounter, Performed": "Office Visit"]
      union ["Encounter, Performed": "Outpatient Consultation"]
      union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
      union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
      union ["Encounter, Performed": "Telephone Visits"] ) ValidEncounter
      where ValidEncounter.relevantPeriod during "Measurement Period"
  )

define "Numerator":
  "Has Kidney Panel Performed During Measurement Period"

define "Has CKD Stage 5 or ESRD Diagnosis Overlaps Measurement Period":
  ( ["Diagnosis": "Chronic Kidney Disease, Stage 5"]
    union ["Diagnosis": "End Stage Renal Disease"] ) CKDOrESRD
    where CKDOrESRD.prevalencePeriod overlaps "Measurement Period"

define "Has Active Diabetes at the start of the Measurement Period":
  exists ( ["Diagnosis": "Diabetes"] Diabetes
      where Diabetes.prevalencePeriod overlaps before "Measurement Period"
  )

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")in Interval[18, 75]
    and "Has Active Diabetes at the start of the Measurement Period"
    and "Has Outpatient Visit During Measurement Period"

define "Denominator Exclusions":
  exists "Has CKD Stage 5 or ESRD Diagnosis Overlaps Measurement Period"
    or Hospice."Has Hospice Services"
    or PalliativeCare."Has Palliative Care in the Measurement Period"

define "Has Kidney Panel Performed During Measurement Period":
  exists ( ["Laboratory Test, Performed": "Estimated Glomerular Filtration Rate"] eGFRTest
      where Global."NormalizeInterval" ( eGFRTest.relevantDatetime, eGFRTest.relevantPeriod ) during day of "Measurement Period"
        and eGFRTest.result is not null
  )
    and exists ( ["Laboratory Test, Performed": "Urine Albumin Creatinine Ratio"] uACRTest
        where Global."NormalizeInterval" ( uACRTest.relevantDatetime, uACRTest.relevantPeriod ) during day of "Measurement Period"
          and uACRTest.result is not null
    )