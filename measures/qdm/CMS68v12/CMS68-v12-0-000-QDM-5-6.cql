library DocumentationofCurrentMedications version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Encounter to Document Medications": 'urn:oid:2.16.840.1.113883.3.600.1.1834'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Documentation of current medications (procedure)": '428191000124101' from "SNOMEDCT" display 'Documentation of current medications (procedure)'

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

define "Denominator Exceptions":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    with ( ["Procedure, Not Performed": "Documentation of current medications (procedure)"]
      union ["Intervention, Not Performed": "Documentation of current medications (procedure)"] ) MedicationsNotDocumented
      such that MedicationsNotDocumented.authorDatetime during QualifyingEncounter.relevantPeriod
        and MedicationsNotDocumented.negationRationale in "Medical Reason"

define "Initial Population":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    where AgeInYearsAt(date from start of "Measurement Period")>= 18

define "Qualifying Encounter during Measurement Period":
  ["Encounter, Performed": "Encounter to Document Medications"] ValidEncounter
    where ValidEncounter.relevantPeriod during "Measurement Period"

define "Numerator":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    with ( ["Procedure, Performed": "Documentation of current medications (procedure)"]
      union ["Intervention, Performed": "Documentation of current medications (procedure)"] ) MedicationsDocumented
      such that Global."NormalizeInterval" ( MedicationsDocumented.relevantDatetime, MedicationsDocumented.relevantPeriod ) during QualifyingEncounter.relevantPeriod