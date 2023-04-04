library ExclusiveBreastMilkFeeding version '11.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include PCNewborn version '2.0.000' called PCNewborn

valueset "Breast Milk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.30'
valueset "Dietary Intake Other than Breast Milk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.27'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Galactosemia": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.35'
valueset "Intensive Care Unit": 'urn:oid:2.16.840.1.113762.1.4.1029.206'
valueset "Neonatal Intensive Care Unit (NICU)": 'urn:oid:2.16.840.1.113762.1.4.1029.205'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Other Health Care Facility": 'urn:oid:2.16.840.1.113762.1.4.1029.67'
valueset "Parenteral Nutrition": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.38'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Total Parenteral Nutrition": 'urn:oid:2.16.840.1.113762.1.4.1110.54'

context Patient

define "Denominator":
  "Initial Population"

define "Initial Population":
  PCNewborn."Single Live Term Newborn Encounter Ends During Measurement Period"

define "Numerator":
  "Single Live Term Newborn Encounter with Newborn Fed Breast Milk Only Since Birth"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Single Live Term Newborn Encounter with Length of Stay More Than 120 days":
  PCNewborn."Single Live Term Newborn Encounter Ends During Measurement Period" QualifyingEncounter
    where Global."LengthInDays" ( QualifyingEncounter.relevantPeriod ) > 120

define "Single Live Term Newborn Encounter with Newborn Fed Breast Milk Only Since Birth":
  PCNewborn."Single Live Term Newborn Encounter Ends During Measurement Period" QualifyingEncounter
    with ["Substance, Administered": "Breast Milk"] BreastMilkFeeding
      such that Global."NormalizeInterval" ( BreastMilkFeeding.relevantDatetime, BreastMilkFeeding.relevantPeriod ) starts during QualifyingEncounter.relevantPeriod
    without ["Substance, Administered": "Dietary Intake Other than Breast Milk"] OtherFeeding
      such that Global."NormalizeInterval" ( OtherFeeding.relevantDatetime, OtherFeeding.relevantPeriod ) starts during QualifyingEncounter.relevantPeriod

define "Single Live Term Newborn Encounter with Galactosemia or Parenteral Nutrition":
  ( PCNewborn."Single Live Term Newborn Encounter Ends During Measurement Period" QualifyingEncounter
      with ( ["Procedure, Performed": "Parenteral Nutrition"]
        union ["Medication, Administered": "Total Parenteral Nutrition"] ) ParenteralNutrition
        such that Global."NormalizeInterval" ( ParenteralNutrition.relevantDatetime, ParenteralNutrition.relevantPeriod ) starts during QualifyingEncounter.relevantPeriod
  )
    union ( PCNewborn."Single Live Term Newborn Encounter Ends During Measurement Period" QualifyingEncounter
        where exists ( QualifyingEncounter.diagnoses BirthEncounterDiagnoses
            where BirthEncounterDiagnoses.code in "Galactosemia"
        )
    )

define "Denominator Exclusions":
  "Single Live Term Newborn Encounter with NICU or ICU Admission or Selected Discharge Disposition"
    union "Single Live Term Newborn Encounter with Length of Stay More Than 120 days"
    union "Single Live Term Newborn Encounter with Galactosemia or Parenteral Nutrition"

define "Single Live Term Newborn Encounter with NICU or ICU Admission or Selected Discharge Disposition":
  PCNewborn."Single Live Term Newborn Encounter Ends During Measurement Period" QualifyingEncounter
    where exists ( QualifyingEncounter.facilityLocations Location
        where Location.code in "Neonatal Intensive Care Unit (NICU)"
          or Location.code in "Intensive Care Unit" //in case newborn was transferred to regular Intensive Care Unit for special care.
    )
      or QualifyingEncounter.dischargeDisposition in "Patient Expired"
      or QualifyingEncounter.dischargeDisposition in "Discharge To Acute Care Facility"
      or QualifyingEncounter.dischargeDisposition in "Other Health Care Facility"