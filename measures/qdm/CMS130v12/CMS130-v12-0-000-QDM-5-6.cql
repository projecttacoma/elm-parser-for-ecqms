library ColorectalCancerScreening version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include AdultOutpatientEncounters version '3.0.000' called AdultOutpatientEncounters
include Hospice version '5.0.000' called Hospice
include PalliativeCareExclusionECQM version '3.0.000' called PalliativeCare
include AdvancedIllnessandFrailtyExclusionECQM version '8.0.000' called AIFrailLTCF

valueset "Colonoscopy": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1020'
valueset "CT Colonography": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1038'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fecal Occult Blood Test (FOBT)": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1011'
valueset "Flexible Sigmoidoscopy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1010'
valueset "Malignant Neoplasm of Colon": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "sDNA FIT Test": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1039'
valueset "Total Colectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1019'

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
  exists "Fecal Occult Blood Test Performed"
    or exists "Stool DNA with FIT Test Performed"
    or exists "Flexible Sigmoidoscopy Performed"
    or exists "CT Colonography Performed"
    or exists "Colonoscopy Performed"

define "Fecal Occult Blood Test Performed":
  ["Laboratory Test, Performed": "Fecal Occult Blood Test (FOBT)"] FecalOccultResult
    where FecalOccultResult.result is not null
      and Global."LatestOf" ( FecalOccultResult.relevantDatetime, FecalOccultResult.relevantPeriod ) during day of "Measurement Period"

define "Malignant Neoplasm":
  ["Diagnosis": "Malignant Neoplasm of Colon"] ColorectalCancer
    where ColorectalCancer.prevalencePeriod starts on or before day of 
    end of "Measurement Period"

define "Total Colectomy Performed":
  ["Procedure, Performed": "Total Colectomy"] Colectomy
    where Global."NormalizeInterval" ( Colectomy.relevantDatetime, Colectomy.relevantPeriod ) ends on or before day of 
    end of "Measurement Period"

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[46, 75]
    and exists AdultOutpatientEncounters."Qualifying Encounters"

define "Stratification 1":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[46, 49]

define "Stratification 2":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[50, 75]

define "Colonoscopy Performed":
  ["Procedure, Performed": "Colonoscopy"] Colonoscopy
    where Global."NormalizeInterval" ( Colonoscopy.relevantDatetime, Colonoscopy.relevantPeriod ) ends during day of Interval[start of "Measurement Period" - 9 years, 
    end of "Measurement Period"]

define "Flexible Sigmoidoscopy Performed":
  ["Procedure, Performed": "Flexible Sigmoidoscopy"] FlexibleSigmoidoscopy
    where Global."NormalizeInterval" ( FlexibleSigmoidoscopy.relevantDatetime, FlexibleSigmoidoscopy.relevantPeriod ) ends during day of Interval[start of "Measurement Period" - 4 years, 
    end of "Measurement Period"]

define "CT Colonography Performed":
  ["Diagnostic Study, Performed": "CT Colonography"] Colonography
    where Global."NormalizeInterval" ( Colonography.relevantDatetime, Colonography.relevantPeriod ) ends during day of Interval[start of "Measurement Period" - 4 years, 
    end of "Measurement Period"]

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or exists "Malignant Neoplasm"
    or exists "Total Colectomy Performed"
    or AIFrailLTCF."Is Age 66 or Older with Advanced Illness and Frailty"
    or AIFrailLTCF."Is Age 66 or Older Living Long Term in a Nursing Home"
    or PalliativeCare."Has Palliative Care in the Measurement Period"

define "Stool DNA with FIT Test Performed":
  ["Laboratory Test, Performed": "sDNA FIT Test"] sDNATest
    where sDNATest.result is not null
      and Global."LatestOf" ( sDNATest.relevantDatetime, sDNATest.relevantPeriod ) during day of Interval[start of "Measurement Period" - 2 years, 
      end of "Measurement Period"]