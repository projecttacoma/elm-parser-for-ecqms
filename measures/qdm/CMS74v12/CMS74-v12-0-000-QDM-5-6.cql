library PrimaryCariesPreventionasOfferedbyDentists version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

valueset "Clinical Oral Evaluation": 'urn:oid:2.16.840.1.113883.3.464.1003.125.12.1003'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fluoride Varnish Application for Children": 'urn:oid:2.16.840.1.113883.3.464.1003.125.12.1002'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

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

define "Denominator Exclusions":
  Hospice."Has Hospice Services"

define "Numerator":
  exists ["Procedure, Performed": "Fluoride Varnish Application for Children"] FluorideApplication
    where Global."NormalizeInterval" ( FluorideApplication.relevantDatetime, FluorideApplication.relevantPeriod ) during day of "Measurement Period"

define "Initial Population":
  AgeInMonthsAt(date from start of "Measurement Period")>= 6
    and AgeInYearsAt(date from start of "Measurement Period")<= 20
    and exists ( "Qualifying Encounters" )

define "Stratification 1":
  AgeInMonthsAt(date from start of "Measurement Period")>= 6
    and AgeInYearsAt(date from start of "Measurement Period")<= 5

define "Stratification 2":
  AgeInYearsAt(date from start of "Measurement Period")in Interval[6, 12]

define "Stratification 3":
  AgeInYearsAt(date from start of "Measurement Period")in Interval[13, 20]

define "Qualifying Encounters":
  ["Encounter, Performed": "Clinical Oral Evaluation"] ValidEncounter
    where ValidEncounter.relevantPeriod during day of "Measurement Period"