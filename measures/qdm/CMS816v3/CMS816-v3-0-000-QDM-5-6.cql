library HospitalHarmSevereHypoglycemia version '3.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Glucose Lab Test Mass Per Volume": 'urn:oid:2.16.840.1.113762.1.4.1248.34'
valueset "Hypoglycemics Severe Hypoglycemia": 'urn:oid:2.16.840.1.113762.1.4.1196.393'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Encounter with Hypoglycemic Medication Administration":
  "Qualifying Encounter" InpatientHospitalization
    with "Hypoglycemic Medication Administration" HypoglycemicMedication
      such that Global."NormalizeInterval" ( HypoglycemicMedication.relevantDatetime, HypoglycemicMedication.relevantPeriod ) starts during Global.HospitalizationWithObservation ( InpatientHospitalization )

define "Encounter with Severe Hypoglycemic Harm Event":
  from
    "Denominator" QualifyingEncounter,
    "Severe Hypoglycemic Harm Event" HypoglycemicEvent
    let GlucoseTestTime: Global."EarliestOf" ( HypoglycemicEvent.relevantDatetime, HypoglycemicEvent.relevantPeriod ),
    HospitalizationInterval: Global."HospitalizationWithObservation" ( QualifyingEncounter )
    where GlucoseTestTime during HospitalizationInterval
    return QualifyingEncounter

define "Glucose Test with Result Less Than 40":
  from
    "Denominator" QualifyingEncounter,
    "Hypoglycemic Medication Administration" HypoglycemicMedication,
    ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] GlucoseTest
    let HospitalizationInterval: Global."HospitalizationWithObservation" ( QualifyingEncounter ),
    HypoglycemicMedicationStart: Global."NormalizeInterval" ( HypoglycemicMedication.relevantDatetime, HypoglycemicMedication.relevantPeriod ),
    GlucoseTestTime: Global."EarliestOf" ( GlucoseTest.relevantDatetime, GlucoseTest.relevantPeriod )
    where GlucoseTestTime during HospitalizationInterval
      and GlucoseTest.result < 40 'mg/dL'
      and HypoglycemicMedicationStart starts 24 hours or less before or on GlucoseTestTime
    return GlucoseTest

define "Hypoglycemic Medication Administration":
  ["Medication, Administered": "Hypoglycemics Severe Hypoglycemia"]

define "Initial Population":
  "Encounter with Hypoglycemic Medication Administration"

define "Low Glucose Test Followed By Glucose Test Result Greater Than 80":
  from
    "Denominator" QualifyingEncounter,
    "Glucose Test with Result Less Than 40" LowGlucoseTest,
    ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] FollowupGlucoseTest
    let GlucoseTestTime: Global."EarliestOf" ( LowGlucoseTest.relevantDatetime, LowGlucoseTest.relevantPeriod ),
    FollowupGlucoseTestTime: Global."EarliestOf" ( FollowupGlucoseTest.relevantDatetime, FollowupGlucoseTest.relevantPeriod )
    where FollowupGlucoseTestTime 5 minutes or less after GlucoseTestTime
      and GlucoseTestTime during Global."HospitalizationWithObservation" ( QualifyingEncounter )
      and FollowupGlucoseTestTime during Global."HospitalizationWithObservation" ( QualifyingEncounter )
      and FollowupGlucoseTest.id !~ LowGlucoseTest.id
      and FollowupGlucoseTest.result > 80 'mg/dL'
    return LowGlucoseTest

define "Numerator":
  "Encounter with Severe Hypoglycemic Harm Event"

define "Qualifying Encounter":
  ["Encounter, Performed": "Encounter Inpatient"] InpatientEncounter
    where InpatientEncounter.relevantPeriod ends during day of "Measurement Period"
      and AgeInYearsAt(date from start of InpatientEncounter.relevantPeriod)>= 18

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Severe Hypoglycemic Harm Event":
  "Glucose Test with Result Less Than 40" LowGlucoseTest
    where not ( LowGlucoseTest.id in "Low Glucose Test Followed By Glucose Test Result Greater Than 80".id )