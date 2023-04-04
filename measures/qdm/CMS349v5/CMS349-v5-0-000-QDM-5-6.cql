library HIVScreening version '5.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Human Immunodeficiency Virus (HIV) Laboratory Test Codes (Ab and Ag)": 'urn:oid:2.16.840.1.113762.1.4.1056.50'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "HIV 1 and 2 tests - Meaningful Use set": '75622-1' from "LOINC" display 'HIV 1 and 2 tests - Meaningful Use set'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Has HIV Test Performed":
  exists ( ["Laboratory Test, Performed": "Human Immunodeficiency Virus (HIV) Laboratory Test Codes (Ab and Ag)"]
    union ["Laboratory Test, Performed": "HIV 1 and 2 tests - Meaningful Use set"] ) HIVTest
    where AgeInYearsAt(date from start of Global."NormalizeInterval"(HIVTest.relevantDatetime, HIVTest.relevantPeriod))in Interval[15, 65]
      and Global."NormalizeInterval" ( HIVTest.relevantDatetime, HIVTest.relevantPeriod ) starts before 
      end of "Measurement Period"

define "Numerator":
  ( "Has HIV Test Performed" )

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services-Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services - Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Office Visit"] ) Encounter
    where Encounter.relevantPeriod during "Measurement Period"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")in Interval[15, 65]
    and exists "Qualifying Encounters"

define "Denominator Exclusions":
  exists ( ["Diagnosis": "HIV"] HIV
      where HIV.prevalencePeriod starts before start of "Measurement Period"
  )