library UrinarySymptomScoreChangeAfterBenignProstaticHyperplasia version '5.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "ICD10CM": 'urn:oid:2.16.840.1.113883.6.90'
codesystem "AdministrativeGender": 'urn:oid:2.16.840.1.113883.5.1'
codesystem "ActCode": 'urn:oid:2.16.840.1.113883.5.4'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Services for Urology": 'urn:oid:2.16.840.1.113762.1.4.1151.59'
valueset "Morbid Obesity": 'urn:oid:2.16.840.1.113762.1.4.1164.67'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Urinary retention": 'urn:oid:2.16.840.1.113762.1.4.1164.52'

code "American Urological Association Symptom Index [AUASI]": '80883-2' from "LOINC" display 'American Urological Association Symptom Index [AUASI]'
code "Benign prostatic hyperplasia with lower urinary tract symptoms": 'N40.1' from "ICD10CM" display 'Benign prostatic hyperplasia with lower urinary tract symptoms'
code "Body mass index (BMI) [Ratio]": '39156-5' from "LOINC" display 'Body mass index (BMI) [Ratio]'
code "If you were to spend the rest of your life with your urinary condition just the way it is now, how would you feel about that [IPSS]": '81090-3' from "LOINC" display 'If you were to spend the rest of your life with your urinary condition just the way it is now, how would you feel about that [IPSS]'
code "International Prostate Symptom Score [IPSS]": '80976-4' from "LOINC" display 'International Prostate Symptom Score [IPSS]'
code "Male": 'M' from "AdministrativeGender" display 'Male'
code "virtual": 'VR' from "ActCode" display 'virtual'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Has Qualifying BPH Diagnosis":
  "Initial BPH Diagnosis Starts Within 6 Months Before the Measurement Period" is not null

define "Initial Population":
  ( "Patient is Male" )
    and "Has Qualifying Encounter"
    and "Has Qualifying BPH Diagnosis"
    and "Urinary Symptom Score Within 1 Month after Initial BPH Diagnosis" is not null
    and "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis" is not null

define "Numerator":
  "Urinary Symptom Score Improvement Greater Than or Equal To 3"

define "Patient is Male":
  exists ["Patient Characteristic Sex": "Male"]

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Urinary Symptom Score Assessment":
  "Documented IPSS Assessment Result"
    union "AUA Symptom Index and Quality of Life Assessment Result"

define "Urinary Symptom Score Change":
  from
    "Urinary Symptom Score Within 1 Month after Initial BPH Diagnosis" FirstUSSAssessment,
    "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis" FollowUpUSSAssessment
    let USSChange: ( FirstUSSAssessment.result as Integer ) - ( FollowUpUSSAssessment.result as Integer )
    return USSChange

define "Urinary Symptom Score Improvement Greater Than or Equal To 3":
  ( "Urinary Symptom Score Change" USSImprovement
      where USSImprovement >= 3
  ) is not null

define "Documented IPSS Assessment Result":
  ["Assessment, Performed": "International Prostate Symptom Score [IPSS]"] IPSSAssessment
    where IPSSAssessment.result is not null
    return {
      assessmentDatetime: Global.EarliestOf ( IPSSAssessment.relevantDatetime, IPSSAssessment.relevantPeriod ),
      result: IPSSAssessment.result as Integer
    }

define "AUA Symptom Index and Quality of Life Assessment Result":
  ["Assessment, Performed": "American Urological Association Symptom Index [AUASI]"] AUASIAssessment
    let LastQOLOnDate: Last(["Assessment, Performed": "If you were to spend the rest of your life with your urinary condition just the way it is now, how would you feel about that [IPSS]"] QOLAssessment
        where Global.EarliestOf(QOLAssessment.relevantDatetime, QOLAssessment.relevantPeriod)same day as Global.EarliestOf(AUASIAssessment.relevantDatetime, AUASIAssessment.relevantPeriod)
          and QOLAssessment.result is not null
        sort by Global.EarliestOf(relevantDatetime, relevantPeriod)
    )
    where AUASIAssessment.result is not null
      and LastQOLOnDate.result is not null
    return Tuple {
      assessmentDatetime: Global.EarliestOf ( AUASIAssessment.relevantDatetime, AUASIAssessment.relevantPeriod ),
      result: ( AUASIAssessment.result as Integer ) + ( LastQOLOnDate.result as Integer )
    }

define "Morbid Obesity Diagnosis On or Before Follow Up USS Assessment":
  ["Diagnosis": "Morbid Obesity"] MorbidObesity
    with "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis" FollowUpUSSAssessment
      such that MorbidObesity.prevalencePeriod overlaps "Measurement Period"
        and MorbidObesity.prevalencePeriod starts on or before FollowUpUSSAssessment.assessmentDatetime

define "Has Qualifying Encounter":
  exists ["Encounter, Performed": "Office Visit"] ValidEncounter
    where ValidEncounter.relevantPeriod during day of "Measurement Period"
      and ValidEncounter.class !~ "virtual"

define "BMI Exam Result Greater Than or Equal To 40 During Measurement Period and On or Before Follow Up USS Assessment":
  Exists(["Physical Exam, Performed": "Body mass index (BMI) [Ratio]"] BMIExam
      with "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis" FollowUpUSSAssessment
        such that BMIExam.result >= 40 'kg/m2'
          and Global.EarliestOf(BMIExam.relevantDatetime, BMIExam.relevantPeriod)during day of "Measurement Period"
          and Global.EarliestOf(BMIExam.relevantDatetime, BMIExam.relevantPeriod)on or before FollowUpUSSAssessment.assessmentDatetime
      return Global.EarliestOf(BMIExam.relevantDatetime, BMIExam.relevantPeriod)
  )

define "Morbid Obesity Diagnosis or BMI Exam Result Greater Than or Equal to 40 Starts On or Before Follow Up USS Assessment":
  exists "Morbid Obesity Diagnosis On or Before Follow Up USS Assessment"
    or "BMI Exam Result Greater Than or Equal To 40 During Measurement Period and On or Before Follow Up USS Assessment"

define "Denominator Exclusions":
  exists ( "Urinary Retention Diagnosis Starts Within 1 Year After Initial BPH Diagnosis" )
    or ( "Has Initial BPH Diagnosis Starts During or Within 30 Days After End of Hospitalization" is not null )
    or ( "Morbid Obesity Diagnosis or BMI Exam Result Greater Than or Equal to 40 Starts On or Before Follow Up USS Assessment" )

define "Urinary Retention Diagnosis Starts Within 1 Year After Initial BPH Diagnosis":
  ["Diagnosis": "Urinary retention"] UrinaryRetention
    with "Initial BPH Diagnosis Starts Within 6 Months Before the Measurement Period" InitialBPHDiagnosis
      such that UrinaryRetention.prevalencePeriod starts 1 year or less on or after day of start of InitialBPHDiagnosis.prevalencePeriod

define "Urinary Symptom Score 6 to 12 Months After Initial BPH Diagnosis":
  Last("Urinary Symptom Score Assessment" USSAssessment
      with "Initial BPH Diagnosis Starts Within 6 Months Before the Measurement Period" InitialBPHDiagnosis
        such that months between start of InitialBPHDiagnosis.prevalencePeriod and USSAssessment.assessmentDatetime in Interval[6, 12]
      sort by assessmentDatetime
  )

define "Urinary Symptom Score Within 1 Month after Initial BPH Diagnosis":
  First("Urinary Symptom Score Assessment" USSAssessment
      with "Initial BPH Diagnosis Starts Within 6 Months Before the Measurement Period" InitialBPHDiagnosis
        such that USSAssessment.assessmentDatetime 1 month or less on or after day of start of InitialBPHDiagnosis.prevalencePeriod
      sort by assessmentDatetime
  )

define "Has Initial BPH Diagnosis Starts During or Within 30 Days After End of Hospitalization":
  "Initial BPH Diagnosis Starts Within 6 Months Before the Measurement Period" InitialBPHDiagnosis
    with ["Encounter, Performed": "Hospital Services for Urology"] InHospitalServices
      such that InitialBPHDiagnosis.prevalencePeriod starts during Interval[start of InHospitalServices.relevantPeriod, 
      end of InHospitalServices.relevantPeriod + 31 days )

define "Initial BPH Diagnosis Starts Within 6 Months Before the Measurement Period":
  First(["Diagnosis": "Benign prostatic hyperplasia with lower urinary tract symptoms"] NewBPHDiagnosis
      where NewBPHDiagnosis.prevalencePeriod starts during Interval[start of "Measurement Period" - 6 months, start of "Measurement Period"]
      sort by start of prevalencePeriod
  )