library HospitalHarmHyperglycemiainHospitalizedPatients version '2.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

valueset "Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Glucose Lab Test Mass Per Volume": 'urn:oid:2.16.840.1.113762.1.4.1248.34'
valueset "Hypoglycemics Treatment Medications": 'urn:oid:2.16.840.1.113762.1.4.1196.394'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Days in Hospitalization":
  "Initial Population" EligibleInpatientHospitalization
    let period: Global."HospitalizationWithObservation" ( EligibleInpatientHospitalization ),
    relevantPeriod: "Hospital Days Max 10"(period)
    return Tuple {
      encounter: EligibleInpatientHospitalization,
      hospitalizationPeriod: period,
      relevantPeriod: relevantPeriod,
      relevantDays: "Days In Period"(relevantPeriod)
    }

define "Days With Glucose Results":
  "Days in Hospitalization" InpatientHospitalDays
    return Tuple {
      encounter: InpatientHospitalDays.encounter,
      relevantPeriod: InpatientHospitalDays.relevantPeriod,
      relevantDays: ( InpatientHospitalDays.relevantDays EncounterDay
          return Tuple {
            dayIndex: EncounterDay.dayIndex,
            dayPeriod: EncounterDay.dayPeriod,
            hasSevereResult: exists ( ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] BloodGlucoseLab1
                where BloodGlucoseLab1.result > 300 'mg/dL'
                  and BloodGlucoseLab1.relevantDatetime during EncounterDay.dayPeriod
            ),
            hasElevatedResult: exists ( ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] BloodGlucoseLab2
                where BloodGlucoseLab2.result >= 200 'mg/dL'
                  and BloodGlucoseLab2.relevantDatetime during EncounterDay.dayPeriod
            ),
            hasNoGlucoseTest: not exists ( ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] BloodGlucoseLab3
                where BloodGlucoseLab3.relevantDatetime during EncounterDay.dayPeriod
            )
          }
      )
    }

/*# days with hyper events uses "Days With Glucose Results" to find if hyper event on each day. Skips 1st day in 'RelevantDays`. Returns boolean based on: Today high result OR Today no result AND Yesterday high result AND 2 days ago high result*/

define "Days With Hyperglycemic Events":
  "Days With Glucose Results" EncounterWithResultDays
    let eligibleEventDays: EncounterWithResultDays.relevantDays EncounterDay
      where EncounterDay.dayIndex > 1
      return Tuple {
        dayIndex: EncounterDay.dayIndex,
        dayPeriod: EncounterDay.dayPeriod,
        hasHyperglycemicEvent: ( EncounterDay.hasSevereResult
            or ( EncounterDay.hasNoGlucoseTest
                and EncounterWithResultDays.relevantDays[EncounterDay.dayIndex - 2].hasElevatedResult
                and EncounterWithResultDays.relevantDays[EncounterDay.dayIndex - 3].hasElevatedResult
            )
        )
      }
    return Tuple {
      encounter: EncounterWithResultDays.encounter,
      relevantPeriod: EncounterWithResultDays.relevantPeriod,
      eligibleEventDays: eligibleEventDays
    }

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  "Encounter With First Blood Glucose Greater Than or Equal to 1000"

/** Using the already calculated pairing of hospitalization periods with encounters, filter on ones with 
 * any elevated (>= 200) blood glucose reading during the hospitalization*/

define "Encounter With Elevated Blood Glucose Lab":
  "Encounter With Hospitalization Period" Hospitalization
    with ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] BloodGlucoseLab
      such that BloodGlucoseLab.relevantDatetime during Hospitalization.hospitalizationPeriod
        and BloodGlucoseLab.result >= 200 'mg/dL'
    return Hospitalization.encounter

/** Using the already calculated pairing of hospitalization periods with encounters, filter on ones with 
 * diabetes and return the encounter.*/

define "Encounter With Existing Diabetes Diagnosis":
  "Encounter With Hospitalization Period" Hospitalization
    with ["Diagnosis": "Diabetes"] Diabetes
      such that Diabetes.prevalencePeriod starts before 
      end of Hospitalization.hospitalizationPeriod
    return Hospitalization.encounter

define "Encounter With First Blood Glucose Greater Than or Equal to 1000":
  "Qualifying Encounter" InpatientHospitalization
    with "First Blood Glucose Within 1 Hour Prior To and 6 Hours After Encounter Start" FirstGlucoseResult
      such that FirstGlucoseResult.result >= 1000 'mg/dL'

/** Create paring of encounters to hospitalization period so this calculation can be inspected and the result 
 * can be reused, making the logic faster.*/

define "Encounter With Hospitalization Period":
  "Qualifying Encounter" InpatientHospitalization
    return Tuple {
      encounter: InpatientHospitalization,
      hospitalizationPeriod: Global."HospitalizationWithObservation" ( InpatientHospitalization )
    }

define "Encounter With Hyperglycemic Events":
  "Days With Hyperglycemic Events" HyperglycemicEventDays
    where exists ( HyperglycemicEventDays.eligibleEventDays EligibleEventDay
        where EligibleEventDay.hasHyperglycemicEvent
    )
    return HyperglycemicEventDays.encounter

define "Encounter With Hypoglycemic Medication":
  "Encounter With Hospitalization Period" Hospitalization
    with ["Medication, Administered": "Hypoglycemics Treatment Medications"] HypoglycemicMed
      such that Global."NormalizeInterval" ( HypoglycemicMed.relevantDatetime, HypoglycemicMed.relevantPeriod ) starts during Hospitalization.hospitalizationPeriod
    return Hospitalization.encounter

define "First Blood Glucose Within 1 Hour Prior To and 6 Hours After Encounter Start":
  First(["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] FirstBloodGlucose
      with("Qualifying Encounter")InpatientEncounter
        such that FirstBloodGlucose.relevantDatetime during Interval[(start of Global."HospitalizationWithObservation"(InpatientEncounter)- 1 hour),(start of Global."HospitalizationWithObservation"(InpatientEncounter)+ 6 hours)]
      sort by relevantDatetime
  )

define "Initial Population":
  "Encounter With Existing Diabetes Diagnosis"
    union "Encounter With Hypoglycemic Medication"
    union "Encounter With Elevated Blood Glucose Lab"

define "Numerator":
  "Encounter With Hyperglycemic Events"

define "Qualifying Encounter":
  ["Encounter, Performed": "Encounter Inpatient"] InpatientEncounter
    where InpatientEncounter.relevantPeriod ends during day of "Measurement Period"
      and AgeInYearsAt(date from start of Global."HospitalizationWithObservation"(InpatientEncounter))>= 18

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

/**
 * Creates a list of 24 hour long intervals in an interval paired with the index (1 indexed) to which 24 hour interval it is.*/

define function "Days In Period"(Period Interval<DateTime>):
  ( "Interval To Day Numbers"(Period)) DayIndex
    let startPeriod: start of Period + ( 24 hours * ( DayIndex - 1 ) ),
    endPeriod: if ( hours between startPeriod and 
      end of Period < 24
    ) then startPeriod 
      else start of Period + ( 24 hours * DayIndex )
    return Tuple {
      dayIndex: DayIndex,
      dayPeriod: Interval[startPeriod, endPeriod )
    }

/**
 * Crops an interval to a maximum length of 10 days.*/

define function "Hospital Days Max 10"(Period Interval<DateTime>):
  Interval[start of Period, Min({ 
    end of Period, start of Period + 10 days }
  )]

/**
 * Counts the number of eligible days with a hyperglycemic event in an encounter. This simply filters and counts the data built in
 * "Days With Hyperglycemic Events".*/

define function "Numerator Observations"(QualifyingEncounter "Encounter, Performed"):
  singleton from ( "Days With Hyperglycemic Events" EncounterWithEventDays
      where EncounterWithEventDays.encounter = QualifyingEncounter
      return Count(EncounterWithEventDays.eligibleEventDays EligibleEventDay
          where EligibleEventDay.hasHyperglycemicEvent
      )
  )

/** Creates a list of integers from 1 to how many days are in the interval. Note, this wont create an index for
 * the final day if it is less than 24 hours. This also includes the first 24 hour period.*/

define function "Interval To Day Numbers"(Period Interval<DateTime>):
  ( expand { Interval[1, duration in days between start of Period and 
  end of Period]} ) DayNumber
    return 
    end of DayNumber

/**
 * Counts the number of eligible days in an encounter. This simply filters and counts the data built in
 * "Days With Glucose Results".*/

define function "Denominator Observations"(QualifyingEncounter "Encounter, Performed"):
  singleton from ( "Days With Hyperglycemic Events" EncounterWithEventDays
      where EncounterWithEventDays.encounter = QualifyingEncounter
      return Count(EncounterWithEventDays.eligibleEventDays)
  )