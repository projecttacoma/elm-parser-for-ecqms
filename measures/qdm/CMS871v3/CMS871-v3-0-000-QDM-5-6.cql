library HospitalHarmHyperglycemiainHospitalizedPatients version '3.0.000'

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
  "Measurement Population" EligibleInpatientHospitalization
    let period: Global."HospitalizationWithObservation" ( EligibleInpatientHospitalization ),
    relevantPeriod: "Hospital Days Max 10"(period)
    return Tuple {
      encounter: EligibleInpatientHospitalization,
      hospitalizationPeriod: period,
      relevantPeriod: relevantPeriod,
      relevantDays: "Days In Period"(relevantPeriod)
    }

define "Days with Glucose Results":
  "Days in Hospitalization" InpatientHospitalDays
    return Tuple {
      encounter: InpatientHospitalDays.encounter,
      relevantPeriod: InpatientHospitalDays.relevantPeriod,
      relevantDays: ( InpatientHospitalDays.relevantDays EncounterDay
          return Tuple {
            dayNumber: EncounterDay.dayNumber,
            dayPeriod: EncounterDay.dayPeriod,
            hasSevereResult: exists ( ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] GlucoseTest
                where GlucoseTest.result > 300 'mg/dL'
                  and Global."EarliestOf" ( GlucoseTest.relevantDatetime, GlucoseTest.relevantPeriod ) during EncounterDay.dayPeriod
            ),
            hasElevatedResult: exists ( ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] GlucoseTest
                where GlucoseTest.result >= 200 'mg/dL'
                  and Global."EarliestOf" ( GlucoseTest.relevantDatetime, GlucoseTest.relevantPeriod ) during EncounterDay.dayPeriod
            ),
            hasNoGlucoseTest: not exists ( ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] GlucoseTest
                where Global."EarliestOf" ( GlucoseTest.relevantDatetime, GlucoseTest.relevantPeriod ) during EncounterDay.dayPeriod
            )
          }
      )
    }

define "Days with Hyperglycemic Events":
  "Days with Glucose Results" EncounterWithResultDays
    let eligibleEventDays: EncounterWithResultDays.relevantDays EncounterDay
      where EncounterDay.dayNumber > 1
      return Tuple {
        dayNumber: EncounterDay.dayNumber,
        dayPeriod: EncounterDay.dayPeriod,
        hasHyperglycemicEvent: ( EncounterDay.hasSevereResult
            or ( EncounterDay.hasNoGlucoseTest
                and EncounterWithResultDays.relevantDays[EncounterDay.dayNumber - 2].hasElevatedResult
                and EncounterWithResultDays.relevantDays[EncounterDay.dayNumber - 3].hasElevatedResult
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
  "Encounter with First Glucose Greater Than or Equal to 1000"

define "Encounter with Elevated Glucose Greater Than or Equal to 200":
  "Encounter with Hospitalization Period" Hospitalization
    with ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] GlucoseTest
      such that Global."EarliestOf" ( GlucoseTest.relevantDatetime, GlucoseTest.relevantPeriod ) during Hospitalization.hospitalizationPeriod
        and GlucoseTest.result >= 200 'mg/dL'
    return Hospitalization.encounter

define "Encounter with Existing Diabetes Diagnosis":
  "Encounter with Hospitalization Period" Hospitalization
    with ["Diagnosis": "Diabetes"] DiabetesCondition
      such that DiabetesCondition.prevalencePeriod starts before 
      end of Hospitalization.hospitalizationPeriod
    return Hospitalization.encounter

define "Encounter with Hospitalization Period":
  "Qualifying Encounter" QualifyingHospitalization
    return Tuple {
      encounter: QualifyingHospitalization,
      hospitalizationPeriod: Global."HospitalizationWithObservation" ( QualifyingHospitalization )
    }

define "Encounter with Hyperglycemic Events":
  "Days with Hyperglycemic Events" HyperglycemicEventDays
    where exists ( HyperglycemicEventDays.eligibleEventDays EligibleEventDay
        where EligibleEventDay.hasHyperglycemicEvent
    )
    return HyperglycemicEventDays.encounter

define "Encounter with Hypoglycemic Medication":
  "Encounter with Hospitalization Period" Hospitalization
    with ["Medication, Administered": "Hypoglycemics Treatment Medications"] HypoglycemicMedication
      such that Global."NormalizeInterval" ( HypoglycemicMedication.relevantDatetime, HypoglycemicMedication.relevantPeriod ) starts during Hospitalization.hospitalizationPeriod
    return Hospitalization.encounter

define "Initial Glucose Greater Than or Equal to 1000 within 1 Hour Prior To and 6 Hours After Encounter Start":
  "Glucose Greater Than or Equal to 1000 within 1 Hour Prior To and 6 Hours After Encounter Start" GlucoseResult1000
    where not ( GlucoseResult1000.id in "Glucose Tests Earlier Than Glucose Greater Than or Equal to 1000 within 1 Hour Prior To and 6 Hours After Encounter Start".id )

define "Initial Population":
  "Encounter with Existing Diabetes Diagnosis"
    union "Encounter with Hypoglycemic Medication"
    union "Encounter with Elevated Glucose Greater Than or Equal to 200"

define "Measurement Population":
  "Denominator"

define "Numerator":
  "Encounter with Hyperglycemic Events"

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

define "Glucose Greater Than or Equal to 1000 within 1 Hour Prior To and 6 Hours After Encounter Start":
  from
    "Initial Population" InpatientHospitalization,
    ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] GlucoseTest
    let HospitalizationInterval: Global."HospitalizationWithObservation" ( InpatientHospitalization ),
    GlucoseTestTime: Global."EarliestOf" ( GlucoseTest.relevantDatetime, GlucoseTest.relevantPeriod )
    where GlucoseTest.result >= 1000 'mg/dL'
      and GlucoseTest.result is not null
      and GlucoseTestTime during Interval[( start of HospitalizationInterval - 1 hour ), ( start of HospitalizationInterval + 6 hours )]
    return GlucoseTest

define "Encounter with First Glucose Greater Than or Equal to 1000":
  "Initial Population" InpatientHospitalization
    with "Initial Glucose Greater Than or Equal to 1000 within 1 Hour Prior To and 6 Hours After Encounter Start" FirstGlucoseResult
      such that FirstGlucoseResult.result is not null
        and FirstGlucoseResult.result >= 1000 'mg/dL'
        and Global."EarliestOf" ( FirstGlucoseResult.relevantDatetime, FirstGlucoseResult.relevantPeriod ) during Interval[( start of Global."HospitalizationWithObservation" ( InpatientHospitalization ) - 1 hour ), ( start of Global."HospitalizationWithObservation" ( InpatientHospitalization ) + 6 hours )]
    return InpatientHospitalization

define "Glucose Tests Earlier Than Glucose Greater Than or Equal to 1000 within 1 Hour Prior To and 6 Hours After Encounter Start":
  from
    "Initial Population" InpatientHospitalization,
    "Glucose Greater Than or Equal to 1000 within 1 Hour Prior To and 6 Hours After Encounter Start" GlucoseResult1000,
    ["Laboratory Test, Performed": "Glucose Lab Test Mass Per Volume"] EarlierGlucoseTest
    let HospitalizationInterval: Global."HospitalizationWithObservation" ( InpatientHospitalization ),
    GlucoseTest1000Time: Global."EarliestOf" ( GlucoseResult1000.relevantDatetime, GlucoseResult1000.relevantPeriod ),
    EarlierGlucoseTestTime: Global."EarliestOf" ( EarlierGlucoseTest.relevantDatetime, EarlierGlucoseTest.relevantPeriod )
    where GlucoseTest1000Time during Interval[( start of HospitalizationInterval - 1 hour ), ( start of HospitalizationInterval + 6 hour )]
      and EarlierGlucoseTestTime during Interval[( start of HospitalizationInterval - 1 hour ), GlucoseTest1000Time )
      and EarlierGlucoseTest is not null
      and EarlierGlucoseTest.id !~ GlucoseResult1000.id
    return GlucoseResult1000

define function "Interval To Day Numbers"(Period Interval<DateTime>):
  ( expand { Interval[1, days between start of Period and 
  end of Period]} ) DayExpand
    return 
    end of DayExpand

define function "Hospital Days Max 10"(Period Interval<DateTime>):
  Interval[start of Period, Min({ 
    end of Period, start of Period + 10 days }
  )]

define function "Days In Period"(Period Interval<DateTime>):
  ( "Interval To Day Numbers"(Period)) DayNumber
    let startPeriod: start of Period + ( 24 hours * ( DayNumber - 1 ) ),
    endPeriod: if ( hours between startPeriod and 
      end of Period < 24
    ) then startPeriod 
      else start of Period + ( 24 hours * DayNumber )
    return Tuple {
      dayNumber: DayNumber,
      dayPeriod: Interval[startPeriod, endPeriod )
    }

define function "Denominator Observations"(QualifyingEncounter "Encounter, Performed"):
  if QualifyingEncounter.id in "Denominator Exclusions".id then singleton from ( "Days with Hyperglycemic Events" EncounterWithEventDays
      where EncounterWithEventDays.encounter = QualifyingEncounter
      return 0
  ) 
    else singleton from ( "Days with Hyperglycemic Events" EncounterWithEventDays
      where EncounterWithEventDays.encounter = QualifyingEncounter
      return Count(EncounterWithEventDays.eligibleEventDays)
  )

define function "Numerator Observations"(QualifyingEncounter "Encounter, Performed"):
  if QualifyingEncounter.id in "Denominator Exclusions".id then singleton from ( "Days with Hyperglycemic Events" EncounterWithEventDays
      where EncounterWithEventDays.encounter = QualifyingEncounter
      return 0
  ) 
    else singleton from ( "Days with Hyperglycemic Events" EncounterWithEventDays
      where EncounterWithEventDays.encounter = QualifyingEncounter
      return Count(EncounterWithEventDays.eligibleEventDays EligibleEventDay
          where EligibleEventDay.hasHyperglycemicEvent
      )
  )