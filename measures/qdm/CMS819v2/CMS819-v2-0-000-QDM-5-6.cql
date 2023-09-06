library HospitalHarmOpioidRelatedAdverseEvents version '2.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "HSLOC": 'urn:oid:2.16.840.1.113883.6.259'

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Opioid Antagonist": 'urn:oid:2.16.840.1.113762.1.4.1248.119'
valueset "Opioids, All": 'urn:oid:2.16.840.1.113762.1.4.1196.226'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Routes of Administration for Opioid Antagonists": 'urn:oid:2.16.840.1.113762.1.4.1248.187'

code "Operating Room/Suite": '1096-7' from "HSLOC" display 'Operating Room/Suite'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Initial Population":
  "Encounter with Opioid Administration Outside of Operating Room"

define "Numerator":
  "Encounter with Non Enteral Opioid Antagonist Administration Outside of Operating Room and within 12 Hrs After Opioid"

define "Opioid Administration":
  ["Medication, Administered": "Opioids, All"]

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Encounter with Opioid Administration Outside of Operating Room":
  "Qualifying Encounter" InpatientEncounter
    with "Opioid Administration" OpioidGiven
      such that Global."NormalizeInterval" ( OpioidGiven.relevantDatetime, OpioidGiven.relevantPeriod ) starts during Global."HospitalizationWithObservation" ( InpatientEncounter )
        and not exists ( InpatientEncounter.facilityLocations EncounterLocation
            where EncounterLocation.code ~ "Operating Room/Suite"
              and Global."NormalizeInterval" ( OpioidGiven.relevantDatetime, OpioidGiven.relevantPeriod ) starts during EncounterLocation.locationPeriod
        )

define "Encounter with Non Enteral Opioid Antagonist Administration Outside of Operating Room and within 12 Hrs After Opioid":
  // Opioids administered before opioid antagonist AND excludes opioid antagonist administered in operating room AND limits opioid antagonist to non-enteral routes
  from
    ["Medication, Administered": "Opioid Antagonist"] OpioidAntagonistGiven,
    "Opioid Administration" OpioidGiven,
    "Denominator" EncounterWithQualifyingAge
    where not exists ( EncounterWithQualifyingAge.facilityLocations EncounterLocation
        where EncounterLocation.code ~ "Operating Room/Suite"
          and Global."NormalizeInterval" ( OpioidAntagonistGiven.relevantDatetime, OpioidAntagonistGiven.relevantPeriod ) starts during EncounterLocation.locationPeriod
    )
      and ( Global."NormalizeInterval" ( OpioidAntagonistGiven.relevantDatetime, OpioidAntagonistGiven.relevantPeriod ) starts during Global."HospitalizationWithObservation" ( EncounterWithQualifyingAge )
          and Global."NormalizeInterval" ( OpioidGiven.relevantDatetime, OpioidGiven.relevantPeriod ) starts during Global."HospitalizationWithObservation" ( EncounterWithQualifyingAge )
          and Global."NormalizeInterval" ( OpioidGiven.relevantDatetime, OpioidGiven.relevantPeriod ) ends 12 hours or less before start of Global."NormalizeInterval" ( OpioidAntagonistGiven.relevantDatetime, OpioidAntagonistGiven.relevantPeriod )
          and OpioidAntagonistGiven.route in "Routes of Administration for Opioid Antagonists"
      )
    return EncounterWithQualifyingAge

define "Qualifying Encounter":
  ["Encounter, Performed": "Encounter Inpatient"] InpatientHospitalization
    where InpatientHospitalization.relevantPeriod ends during day of "Measurement Period"
      and AgeInYearsAt(date from start of InpatientHospitalization.relevantPeriod)>= 18