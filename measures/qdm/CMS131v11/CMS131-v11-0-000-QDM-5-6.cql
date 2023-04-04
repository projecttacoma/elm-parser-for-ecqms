library DiabetesEyeExam version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice
include PalliativeCareExclusionECQM version '2.0.000' called PalliativeCare
include AdvancedIllnessandFrailtyExclusionECQM version '7.0.000' called AIFrailLTCF

valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Diabetic Retinopathy": 'urn:oid:2.16.840.1.113883.3.526.3.327'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Ophthalmological Services": 'urn:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Retinal or Dilated Eye Exam": 'urn:oid:2.16.840.1.113883.3.464.1003.115.12.1088'
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

define "Numerator":
  ( "Diabetic Retinopathy Overlapping Measurement Period"
      and exists ( "Retinal Exam in Measurement Period" )
  )
    or ( not ( "Diabetic Retinopathy Overlapping Measurement Period" )
        and exists ( "Retinal Exam in Measurement Period or Year Prior" )
    )

define "Diabetic Retinopathy Overlapping Measurement Period":
  exists ( ["Diagnosis": "Diabetic Retinopathy"] Retinopathy
      where Retinopathy.prevalencePeriod overlaps "Measurement Period"
  )

define "Retinal Exam in Measurement Period":
  ["Physical Exam, Performed": "Retinal or Dilated Eye Exam"] RetinalExam
    where Global."NormalizeInterval" ( RetinalExam.relevantDatetime, RetinalExam.relevantPeriod ) during day of "Measurement Period"

define "Retinal Exam in Measurement Period or Year Prior":
  ["Physical Exam, Performed": "Retinal or Dilated Eye Exam"] RetinalExam
    where Global."NormalizeInterval" ( RetinalExam.relevantDatetime, RetinalExam.relevantPeriod ) during day of Interval[start of "Measurement Period" - 1 year, 
    end of "Measurement Period"]

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[18, 75]
    and exists ( "Qualifying Encounters" )
    and exists ( ["Diagnosis": "Diabetes"] Diabetes
        where Diabetes.prevalencePeriod overlaps "Measurement Period"
    )

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Ophthalmological Services"]
    union ["Encounter, Performed": "Telephone Visits"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or AIFrailLTCF."Is Age 66 or Older with Advanced Illness and Frailty"
    or AIFrailLTCF."Is Age 66 or Older Living Long Term in a Nursing Home"
    or PalliativeCare."Palliative Care in the Measurement Period"