library CervicalCancerScreening version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice
include PalliativeCareExclusionECQM version '2.0.000' called PalliativeCare

codesystem "AdministrativeGender": 'urn:oid:2.16.840.1.113883.5.1'

valueset "Congenital or Acquired Absence of Cervix": 'urn:oid:2.16.840.1.113883.3.464.1003.111.12.1016'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "HPV Test": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1059'
valueset "Hysterectomy with No Residual Cervix": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1014'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Pap Test": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Female": 'F' from "AdministrativeGender" display 'Female'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Absence of Cervix":
  ( ["Procedure, Performed": "Hysterectomy with No Residual Cervix"] NoCervixProcedure
      where Global."NormalizeInterval" ( NoCervixProcedure.relevantDatetime, NoCervixProcedure.relevantPeriod ) ends on or before 
      end of "Measurement Period"
  )
    union ( ["Diagnosis": "Congenital or Acquired Absence of Cervix"] NoCervixDiagnosis
        where NoCervixDiagnosis.prevalencePeriod starts on or before 
        end of "Measurement Period"
    )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or exists "Absence of Cervix"
    or PalliativeCare."Palliative Care in the Measurement Period"

define "Numerator":
  exists "Cervical Cytology Within 3 Years"
    or exists "HPV Test Within 5 Years for Women Age 30 and Older"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Cervical Cytology Within 3 Years":
  ["Laboratory Test, Performed": "Pap Test"] CervicalCytology
    where Global."LatestOf" ( CervicalCytology.relevantDatetime, CervicalCytology.relevantPeriod ) during day of Interval[start of "Measurement Period" - 2 years, 
    end of "Measurement Period"]
      and CervicalCytology.result is not null

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )in Interval[24, 64]
    and exists ( ["Patient Characteristic Sex": "Female"] )
    and exists "Qualifying Encounters"

define "HPV Test Within 5 Years for Women Age 30 and Older":
  ["Laboratory Test, Performed": "HPV Test"] HPVTest
    where AgeInYearsAt(date from Global."LatestOf"(HPVTest.relevantDatetime, HPVTest.relevantPeriod))>= 30
      and Global."LatestOf" ( HPVTest.relevantDatetime, HPVTest.relevantPeriod ) during day of Interval[start of "Measurement Period" - 4 years, 
      end of "Measurement Period"]
      and HPVTest.result is not null

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Telephone Visits"]
    union ["Encounter, Performed": "Online Assessments"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"