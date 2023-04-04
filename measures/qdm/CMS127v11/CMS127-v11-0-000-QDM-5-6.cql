library PneumococcalVaccinationStatusforOlderAdults version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Adult Pneumococcal Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.1161'
valueset "Adult Pneumococcal Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.1162'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Care Services in Long Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Discharge Services Nursing Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Office or other outpatient visit for the evaluation and management of an established patient, that may not require the presence of a physician or other qualified health care professional. Usually, the presenting problem(s) are minimal.": '99211' from "CPT" display 'Office or other outpatient visit for the evaluation and management of an established patient, that may not require the presence of a physician or other qualified health care professional. Usually, the presenting problem(s) are minimal.'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Numerator":
  "Has Adult Pneumococcal Vaccine Administered"

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")>= 66
    and exists "Qualifying Encounters"

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Discharge Services Nursing Facility"]
    union ["Encounter, Performed": "Online Assessments"]
    union ["Encounter, Performed": "Telephone Visits"]
    union ["Encounter, Performed": "Office or other outpatient visit for the evaluation and management of an established patient, that may not require the presence of a physician or other qualified health care professional. Usually, the presenting problem(s) are minimal."] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "Has Adult Pneumococcal Vaccine Administered":
  exists ( ( ["Immunization, Administered": "Adult Pneumococcal Vaccine"]
      union ["Procedure, Performed": "Adult Pneumococcal Vaccine Administered"] ) PneumococcalVaccination
      where AgeInYearsAt(date from start of Global."NormalizeInterval"(PneumococcalVaccination.relevantDatetime, PneumococcalVaccination.relevantPeriod))>= 60
        and Global."NormalizeInterval" ( PneumococcalVaccination.relevantDatetime, PneumococcalVaccination.relevantPeriod ) on or before day of 
        end of "Measurement Period"
  )