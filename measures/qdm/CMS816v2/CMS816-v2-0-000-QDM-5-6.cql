library HospitalHarmSevereHypoglycemia version '2.0.000'

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

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Hypoglycemic Medication Administration":
  ["Medication, Administered": "Hypoglycemics Severe Hypoglycemia"]

define "Numerator":
  "Encounter With Severe Hypoglycemic Harm Event"

define "Encounter With Hypoglycemic Medication Administration":
  "Qualifying Encounter" InpatientEncounter
    with "Hypoglycemic Medication Administration" HypoglycemicMed
      such that Global."NormalizeInterval" ( HypoglycemicMed.relevantDatetime, HypoglycemicMed.relevantPeriod ) starts during Global.HospitalizationWithObservation ( InpatientEncounter )

define "Initial Population":
  "Encounter With Hypoglycemic Medication Administration"

define "Qualifying Encounter":
  ["Encounter, Performed": "Encounter Inpatient"] InpatientEncounter
    where InpatientEncounter.relevantPeriod ends during day of "Measurement Period"
      and AgeInYearsAt(date from start of Global."HospitalizationWithObservation"(InpatientEncounter))>= 18

define "Encounter With Severe Hypoglycemic Harm Event":
  "Encounter With Hypoglycemic Medication Administration" QualifyingEncounter
    where exists ( ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] BloodGlucoseLab1
        with ["Medication, Administered": "Hypoglycemics Severe Hypoglycemia"] HypoglycemicMed
          such that Global."NormalizeInterval" ( HypoglycemicMed.relevantDatetime, HypoglycemicMed.relevantPeriod ) starts 24 hours or less before or on BloodGlucoseLab1.relevantDatetime
            and Global."NormalizeInterval" ( HypoglycemicMed.relevantDatetime, HypoglycemicMed.relevantPeriod ) starts during Global."HospitalizationWithObservation" ( QualifyingEncounter )
        without ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] BloodGlucoseLab2
          such that BloodGlucoseLab2.relevantDatetime during Global."HospitalizationWithObservation" ( QualifyingEncounter )
            and BloodGlucoseLab2.relevantDatetime 5 minutes or less after BloodGlucoseLab1.relevantDatetime
            and BloodGlucoseLab2.result > 80 'mg/dL'
        where BloodGlucoseLab1.relevantDatetime during Global."HospitalizationWithObservation" ( QualifyingEncounter )
          and BloodGlucoseLab1.result < 40 'mg/dL'
    )