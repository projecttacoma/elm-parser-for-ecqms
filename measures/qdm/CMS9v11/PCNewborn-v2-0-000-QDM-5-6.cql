library PCNewborn version '2.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1' 

valueset "Birth Weight": 'urn:oid:2.16.840.1.113762.1.4.1029.194' 
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307' 
valueset "Single Live Born Newborn Born in Hospital": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.26' 

code "Gestational age--at birth": '76516-4' from "LOINC" display 'Gestational age--at birth'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Single Live Birth Encounter":
  ["Encounter, Performed": "Encounter Inpatient"] InpatientEncounter
    where exists ( InpatientEncounter.diagnoses EncounterDiagnoses
        where EncounterDiagnoses.code in "Single Live Born Newborn Born in Hospital"
    )

define "Single Live Term Newborn Encounter Ends During Measurement Period":
  ( "Single Live Birth Encounter with Gestational Age 37 Weeks or More"
    union "Single Live Birth Encounter with Birth Weight 3000 grams or More without Gestational Age" ) SingleLiveTermEncounter
    where SingleLiveTermEncounter.relevantPeriod ends during day of "Measurement Period"

define "Single Live Birth Encounter with Birth Weight 3000 grams or More without Gestational Age":
  "Single Live Birth Encounter" SingleLiveBornEncounter
    without ["Assessment, Performed": "Gestational age--at birth"] GestationalAge
      such that Global."EarliestOf" ( GestationalAge.relevantDatetime, GestationalAge.relevantPeriod ) during SingleLiveBornEncounter.relevantPeriod
        and GestationalAge.result is not null
    with ["Assessment, Performed": "Birth Weight"] BirthWeight
      such that Global."EarliestOf" ( BirthWeight.relevantDatetime, BirthWeight.relevantPeriod ) during SingleLiveBornEncounter.relevantPeriod
        and BirthWeight.result >= 3000 'g'

define "Single Live Birth Encounter with Gestational Age 37 Weeks or More":
  "Single Live Birth Encounter" SingleLiveBornEncounter
    with ["Assessment, Performed": "Gestational age--at birth"] GestationalAge
      such that GestationalAge.result >= 37 weeks
        and Global."EarliestOf" ( GestationalAge.relevantDatetime, GestationalAge.relevantPeriod ) during SingleLiveBornEncounter.relevantPeriod

