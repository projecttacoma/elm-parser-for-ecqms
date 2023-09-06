library GlobalMalnutritionComposite version '2.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Dietitian Referral": 'urn:oid:2.16.840.1.113762.1.4.1095.91'
valueset "Malnutrition Diagnosis": 'urn:oid:2.16.840.1.113762.1.4.1095.55'
valueset "Malnutrition Risk Screening": 'urn:oid:2.16.840.1.113762.1.4.1095.92'
valueset "Malnutrition Screening At Risk Result": 'urn:oid:2.16.840.1.113762.1.4.1095.38'
valueset "Malnutrition Screening Not At Risk Result": 'urn:oid:2.16.840.1.113762.1.4.1095.34'
valueset "Nutrition Assessment": 'urn:oid:2.16.840.1.113762.1.4.1095.21'
valueset "Nutrition Assessment Status Moderately Malnourished": 'urn:oid:2.16.840.1.113762.1.4.1095.44'
valueset "Nutrition Assessment Status Not or Mildly Malnourished": 'urn:oid:2.16.840.1.113762.1.4.1095.48'
valueset "Nutrition Assessment Status Severely Malnourished": 'urn:oid:2.16.840.1.113762.1.4.1095.42'
valueset "Nutrition Care Plan": 'urn:oid:2.16.840.1.113762.1.4.1095.93'
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
  ["Encounter, Performed": "Encounter Inpatient"] EncounterInpatient
    where AgeInYearsAt(date from start of EncounterInpatient.relevantPeriod)>= 65
      and duration in hours of EncounterInpatient.relevantPeriod >= 24
      and EncounterInpatient.relevantPeriod during day of "Measurement Period"

define "Initial Population":
  "Global Malnutrition Encounter"

define "Measure Population":
  "Initial Population"

define "Encounter with Malnutrition Risk Screening and Identified Result":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Malnutrition Risk Screening"] MalnutritionRiskScreening
      such that Coalesce(start of Global."NormalizeInterval"(MalnutritionRiskScreening.relevantDatetime, MalnutritionRiskScreening.relevantPeriod), MalnutritionRiskScreening.authorDatetime)during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )
        and ( MalnutritionRiskScreening.result in "Malnutrition Screening Not At Risk Result"
            or MalnutritionRiskScreening.result in "Malnutrition Screening At Risk Result"
        )

define "Encounter with Malnutrition Screening Not At Risk Result":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Malnutrition Risk Screening"] MalnutritionRiskScreening
      such that Coalesce(start of Global."NormalizeInterval"(MalnutritionRiskScreening.relevantDatetime, MalnutritionRiskScreening.relevantPeriod), MalnutritionRiskScreening.authorDatetime)during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )
        and MalnutritionRiskScreening.result in "Malnutrition Screening Not At Risk Result"

define "Encounter with Malnutrition Screening At Risk Result":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Malnutrition Risk Screening"] MalnutritionRiskScreening
      such that Coalesce(start of Global."NormalizeInterval"(MalnutritionRiskScreening.relevantDatetime, MalnutritionRiskScreening.relevantPeriod), MalnutritionRiskScreening.authorDatetime)during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )
        and MalnutritionRiskScreening.result in "Malnutrition Screening At Risk Result"

define "Encounter with Hospital Dietitian Referral":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Intervention, Order": "Hospital Dietitian Referral"] HospitalDietitianReferral
      such that HospitalDietitianReferral.authorDatetime during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )

define "Encounter with Nutrition Assessment and Identified Status":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Nutrition Assessment"] NutritionAssessment
      such that Coalesce(start of Global."NormalizeInterval"(NutritionAssessment.relevantDatetime, NutritionAssessment.relevantPeriod), NutritionAssessment.authorDatetime)during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )
        and ( NutritionAssessment.result in "Nutrition Assessment Status Not or Mildly Malnourished"
            or NutritionAssessment.result in "Nutrition Assessment Status Moderately Malnourished"
            or NutritionAssessment.result in "Nutrition Assessment Status Severely Malnourished"
        )

define "Encounter with Nutrition Assessment Status Not or Mildly Malnourished":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Nutrition Assessment"] NutritionAssessment
      such that Coalesce(start of Global."NormalizeInterval"(NutritionAssessment.relevantDatetime, NutritionAssessment.relevantPeriod), NutritionAssessment.authorDatetime)during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )
        and NutritionAssessment.result in "Nutrition Assessment Status Not or Mildly Malnourished"

define "Encounter with Nutrition Assessment Status Moderately Malnourished":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Nutrition Assessment"] NutritionAssessment
      such that Coalesce(start of Global."NormalizeInterval"(NutritionAssessment.relevantDatetime, NutritionAssessment.relevantPeriod), NutritionAssessment.authorDatetime)during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )
        and NutritionAssessment.result in "Nutrition Assessment Status Moderately Malnourished"

define "Encounter with Nutrition Assessment Status Severely Malnourished":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Assessment, Performed": "Nutrition Assessment"] NutritionAssessment
      such that Coalesce(start of Global."NormalizeInterval"(NutritionAssessment.relevantDatetime, NutritionAssessment.relevantPeriod), NutritionAssessment.authorDatetime)during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )
        and NutritionAssessment.result in "Nutrition Assessment Status Severely Malnourished"

define "Encounter with Malnutrition Diagnosis":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Diagnosis": "Malnutrition Diagnosis"] MalnutritionDiagnosis
      such that MalnutritionDiagnosis.prevalencePeriod starts during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )

define "Encounter with Nutrition Care Plan":
  "Global Malnutrition Encounter" GlobalMalnutritionEncounter
    with ["Intervention, Performed": "Nutrition Care Plan"] NutritionCarePlan
      such that Coalesce(start of Global."NormalizeInterval"(NutritionCarePlan.relevantDatetime, NutritionCarePlan.relevantPeriod), NutritionCarePlan.authorDatetime)during Global."HospitalizationWithObservation" ( GlobalMalnutritionEncounter )

/*"Measure Observation 1" identifies hospital encounters where a “Malnutrition Risk Screening” was performed with a current identified “Malnutrition Screening Not At Risk Result” or current identified “Malnutrition Screening At Risk Result”. "Global Malnutrition Encounters" are hospital encounters for patients aged 65 years and greater with a length of stay of 24 hours or greater. "Measure Observation 1" equals 1 for performed "Encounters with Malnutrition Risk Screening and Identified Result" and 0 for not performed*/

define function "Measure Observation 1"(Encounter "Encounter, Performed"):
  if ( "Encounter with Malnutrition Risk Screening and Identified Result" contains Encounter
      and ( "Encounter with Malnutrition Screening Not At Risk Result" contains Encounter
          or "Encounter with Malnutrition Screening At Risk Result" contains Encounter
      )
  ) then 1 
    else 0

/*"Measure Observation 2" identifies hospital encounters where a “Nutrition Assessment” was performed with a current identified status of “Nutrition Assessment Status Not or Mildly Malnourished", “Nutrition Assessment Status Moderately Malnourished", or “Nutrition Assessment Status Severely Malnourished". "Measure Observation 2" should be performed in "Global Malnutrition Encounters" with a current "Malnutrition Screening At Risk Result" or current "Hospital Dietitian Referral". "Measure Observation 2" equals 1 for performed "Encounters with Nutrition Assessment with Identified Status" and 0 for not performed*/

define function "Measure Observation 2"(Encounter "Encounter, Performed"):
  if ( "Encounter with Nutrition Assessment and Identified Status" contains Encounter
      and ( "Encounter with Nutrition Assessment Status Not or Mildly Malnourished" contains Encounter
          or "Encounter with Nutrition Assessment Status Moderately Malnourished" contains Encounter
          or "Encounter with Nutrition Assessment Status Severely Malnourished" contains Encounter
      )
  ) then 1 
    else 0

/*"Measure Observation 3" identifies hospital encounters where a current “Malnutrition Diagnosis” was documented. "Measure Observation 3" should be performed in "Global Malnutrition Encounters" with a current identified status of “Nutrition Assessment Status Moderately Malnourished" or “Nutrition Assessment Status Severely Malnourished". "Measure Observation 3" equals 1 for performed "Encounters with Malnutrition Diagnosis" and 0 for not performed*/

define function "Measure Observation 3"(Encounter "Encounter, Performed"):
  if ( "Encounter with Malnutrition Diagnosis" contains Encounter
      and "Encounter with Nutrition Assessment and Identified Status" contains Encounter
      and ( "Encounter with Nutrition Assessment Status Moderately Malnourished" contains Encounter
          or "Encounter with Nutrition Assessment Status Severely Malnourished" contains Encounter
      )
  ) then 1 
    else 0

/*"Measure Observation 4" identifies hospital encounters where a current “Nutrition Care Plan” was performed. "Measure Observation 4" should be performed "Global Malnutrition Encounters" with a current identified status of “Nutrition Assessment Status Moderately Malnourished" or “Nutrition Assessment Status Severely Malnourished". "Measure Observation 4" equals 1 for performed "Encounters with Nutrition Care Plan" and 0 for not performed*/

define function "Measure Observation 4"(Encounter "Encounter, Performed"):
  if ( "Encounter with Nutrition Care Plan" contains Encounter
      and "Encounter with Nutrition Assessment and Identified Status" contains Encounter
      and ( "Encounter with Nutrition Assessment Status Moderately Malnourished" contains Encounter
          or "Encounter with Nutrition Assessment Status Severely Malnourished" contains Encounter
      )
  ) then 1 
    else 0

/*Measure Observation ”TotalMalnutritionComponentsScore” = ("Measure Observation 1" + "Measure Observation 2" + "Measure Observation 3" + "Measure Observation 4"). 

Measure Observation “TotalMalnutritionComponentsScore” Calculations:
-For each hospitalization, Population Criteria 5 represents the subtotal of Measure Observations performed for Population Criteria 1, 2, 3, and 4. -For the reporting facility, the Population Criteria 5 Aggregate Operator “Count” counts the number of hospitalizations during the measurement period.*/

define function "Measure Observation TotalMalnutritionComponentsScore"(Encounter "Encounter, Performed"):
  Sum({ "Measure Observation 1"(Encounter), "Measure Observation 2"(Encounter), "Measure Observation 3"(Encounter), "Measure Observation 4"(Encounter)})

/*Population 6 Measure Observation “TotalMalnutritionCompositeScore as Percentage” Calculations:
-For each hospitalization, Population Criteria 6 represents the sum of performed Measure Observations 1, 2, 3, and 4 divided by the number of clinically eligible denominators. 
-For the reporting facility, the Population Criteria 6 Aggregate Operator “Average” averages the performance of each “TotalMalnutritionCompositeScore as Percentage” across all hospitalizations during the measurement period.*/

define function "Measure Observation TotalMalnutritionCompositeScore as Percentage"(Encounter "Encounter, Performed"):
  100 * ( "Measure Observation TotalMalnutritionComponentsScore"(Encounter)/ "TotalMalnutritionCompositeScore Eligible Denominators"(Encounter))

/*"TotalMalnutritionCompositeScore Eligible Denominators" defines the clinically eligible denominators for each "Global Malnutrition Encounter.
The “TotalMalnutritionCompositeScore Eligible Denominators” equals 4:
-If a “Malnutrition Risk Screening” was performed AND a "Malnutrition Screening At Risk Result" was identified AND a “Nutrition Assessment” was not performed. 
-If a “Malnutrition Risk Screening” was not performed AND a “Nutrition Assessment” was not performed. 
-If a “Hospital Dietitian Referral” was ordered AND a “Nutrition Assessment” was not performed.
-If a “Nutrition Assessment Status Moderately Malnourished” OR “Nutrition Assessment Status Severely Malnourished” was identified.

 “TotalMalnutritionCompositeScore Eligible Denominators” is always 4 except in the following two instances: 
-If a “Malnutrition Risk Screening” was performed and a “Malnutrition Screening Not At Risk Result” was identified and “Hospital Dietitian Referral” was not ordered, then the “TotalMalnutritionCompositeScore Eligible Denominators” is 1.
-If a “Nutrition Assessment” was performed and a “Nutrition Assessment Status Not or Mildly Malnourished” was identified, then the “TotalMalnutritionCompositeScore Eligible Denominators” are 2.*/

define function "TotalMalnutritionCompositeScore Eligible Denominators"(Encounter "Encounter, Performed"):
  if ( ( "Encounter with Malnutrition Risk Screening and Identified Result" contains Encounter
        and "Encounter with Malnutrition Screening Not At Risk Result" contains Encounter
    )
      and not ( "Encounter with Hospital Dietitian Referral" contains Encounter )
  ) then 1 
    else if ( "Encounter with Nutrition Assessment and Identified Status" contains Encounter
      and "Encounter with Nutrition Assessment Status Not or Mildly Malnourished" contains Encounter
  ) then 2 
    else 4