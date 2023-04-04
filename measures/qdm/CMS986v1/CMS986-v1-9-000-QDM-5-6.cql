library GlobalMalnutritionComposite version '1.9.000'

using QDM version '5.6'

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Malnutrition Assessment": 'urn:oid:2.16.840.1.113762.1.4.1095.29'
valueset "Malnutrition Diagnosis": 'urn:oid:2.16.840.1.113762.1.4.1095.55'
valueset "Malnutrition Risk Screening": 'urn:oid:2.16.840.1.113762.1.4.1095.40'
valueset "Malnutrition Screening At Risk Result": 'urn:oid:2.16.840.1.113762.1.4.1095.38'
valueset "Nutrition Care Plan": 'urn:oid:2.16.840.1.113762.1.4.1095.88'
valueset "Nutritional Status Moderately Malnourished": 'urn:oid:2.16.840.1.113762.1.4.1095.47'
valueset "Nutritional Status Severely Malnourished": 'urn:oid:2.16.840.1.113762.1.4.1095.43'
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

define "Global Malnutrition Encounter":
  ["Encounter, Performed": "Encounter Inpatient"] InpatientEncounter
    where InpatientEncounter.relevantPeriod during day of "Measurement Period"
      and duration in hours of InpatientEncounter.relevantPeriod >= 24
      and AgeInYearsAt(date from start of "Measurement Period")>= 65

define "Initial Population":
  "Global Malnutrition Encounter"

define "Measure Population":
  "Initial Population"

define "Encounter with Malnutrition Risk Screening":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Malnutrition Risk Screening"] MalnutritionRiskScreening
      such that MalnutritionRiskScreening.authorDatetime during GlobalMalnutritionEncounter.relevantPeriod

define "Encounter with Malnutrition Screening At Risk Result":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Malnutrition Screening At Risk Result"] MalnutritionScreeningResult
      such that MalnutritionScreeningResult.authorDatetime during GlobalMalnutritionEncounter.relevantPeriod

define "Encounter with Malnutrition Assessment":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Malnutrition Assessment"] MalnutritionAssessment
      such that MalnutritionAssessment.authorDatetime during GlobalMalnutritionEncounter.relevantPeriod

define "Encounter with Nutrition Assessment Malnourishment Result":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with "Nutrition Assessment Result of Moderate or Severe Malnourishment" AssessmentResultMalnourishment
      such that AssessmentResultMalnourishment.relevantDatetime during GlobalMalnutritionEncounter.relevantPeriod

define "Nutrition Assessment Result of Moderate or Severe Malnourishment":
  ["Assessment, Performed": "Malnutrition Assessment"] AssessmentResultMalnourishment
    where ( AssessmentResultMalnourishment.result in "Nutritional Status Moderately Malnourished"
        or AssessmentResultMalnourishment.result in "Nutritional Status Severely Malnourished"
    )

define "Encounter with Malnutrition Diagnosis":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Diagnosis": "Malnutrition Diagnosis"] MalnutritionDiagnosis
      such that MalnutritionDiagnosis.prevalencePeriod starts during GlobalMalnutritionEncounter.relevantPeriod

define "Encounter with Nutrition Care Plan":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Intervention, Performed": "Nutrition Care Plan"] NutritionCarePlan
      such that NutritionCarePlan.authorDatetime during GlobalMalnutritionEncounter.relevantPeriod

define function "Measure Observation 1"(Encounter "Encounter, Performed"):
  if ( "Encounter with Malnutrition Risk Screening" contains Encounter ) then 1 
    else 0

define function "Measure Observation 2"(Encounter "Encounter, Performed"):
  if ( ( "Encounter with Malnutrition Screening At Risk Result" contains Encounter )
      and ( "Encounter with Malnutrition Assessment" contains Encounter )
  ) then 1 
    else 0

define function "Measure Observation 3"(Encounter "Encounter, Performed"):
  if ( ( "Encounter with Nutrition Assessment Malnourishment Result" contains Encounter )
      and ( "Encounter with Malnutrition Diagnosis" contains Encounter )
  ) then 1 
    else 0

define function "Measure Observation 4"(Encounter "Encounter, Performed"):
  if ( ( "Encounter with Nutrition Care Plan" contains Encounter )
      and ( "Encounter with Nutrition Assessment Malnourishment Result" contains Encounter )
  ) then 1 
    else 0

define function "Measure Observation TotalMalnutritionComponentsScore"(Encounter "Encounter, Performed"):
  Sum({ "Measure Observation 1"(Encounter), "Measure Observation 2"(Encounter), "Measure Observation 3"(Encounter), "Measure Observation 4"(Encounter)})

define function "Measure Observation TotalMalnutritionComponentsScore as Percentage"(Encounter "Encounter, Performed"):
  100 * ( "Measure Observation TotalMalnutritionComponentsScore"(Encounter)/ "TotalMalnutritionComponentsScore Eligible Denominators"(Encounter))

define function "TotalMalnutritionComponentsScore Eligible Denominators"(Encounter "Encounter, Performed"):
  if ( ( "Encounter with Malnutrition Risk Screening" contains Encounter )
      and not ( ( "Encounter with Nutrition Assessment Malnourishment Result" contains Encounter )
          or ( "Encounter with Malnutrition Diagnosis" contains Encounter )
          or ( "Encounter with Nutrition Care Plan" contains Encounter )
      )
  ) then if not ( ( "Encounter with Malnutrition Screening At Risk Result" contains Encounter )
      and ( "Encounter with Malnutrition Assessment" contains Encounter )
  ) then 1 
    else if ( "Encounter with Malnutrition Assessment" contains Encounter ) then 2 
    else 4 
    else 4