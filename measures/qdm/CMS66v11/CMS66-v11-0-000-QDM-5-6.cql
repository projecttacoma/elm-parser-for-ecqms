library FunctionalStatusAssessmentforTotalKneeReplacement version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Lower Body Fracture": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1037'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Primary TKA Procedure": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1007'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Activities of daily living score [KOOS]": '72100-1' from "LOINC" display 'Activities of daily living score [KOOS]'
code "Knee injury and osteoarthritis outcome score for joint replacement [KOOSJR]": '82324-5' from "LOINC" display 'Knee injury and osteoarthritis outcome score for joint replacement [KOOSJR]'
code "Pain score [KOOS]": '72102-7' from "LOINC" display 'Pain score [KOOS]'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "Quality of life score [KOOS]": '72098-7' from "LOINC" display 'Quality of life score [KOOS]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Sport-recreation score [KOOS]": '72099-5' from "LOINC" display 'Sport-recreation score [KOOS]'
code "Symptoms score [KOOS]": '72101-9' from "LOINC" display 'Symptoms score [KOOS]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'

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

define "Has Dementia Diagnosis":
  exists ( ["Diagnosis": "Severe dementia (disorder)"] Dementia
      where Dementia.prevalencePeriod overlaps "Measurement Period"
  )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or "Has Total Knee Arthroplasty with 2 or More Lower Body Fractures"
    or "Has Dementia Diagnosis"

define "Initial Population":
  "Has Qualifying Encounters"
    and exists ( "Total Knee Arthroplasty Procedure" )
    and AgeInYearsAt(date from start of "Measurement Period")>= 19

define "Numerator":
  "Has TKA with Initial and Follow Up KOOS Assessments"
    or "Has TKA with Initial and Follow Up KOOSJr Assessments"
    or "Has TKA with Initial and Follow Up PROMIS10 Assessments"
    or "Has TKA with Initial and Follow Up VR12 Oblique Assessments"
    or "Has TKA with Initial and Follow Up VR12 Orthogonal Assessments"

define "Time KOOS Total Assessment Completed":
  from
    ["Assessment, Performed": "Quality of life score [KOOS]"] KOOSLifeQuality,
    ["Assessment, Performed": "Sport-recreation score [KOOS]"] KOOSSport,
    ["Assessment, Performed": "Activities of daily living score [KOOS]"] KOOSActivityScore,
    ["Assessment, Performed": "Symptoms score [KOOS]"] KOOSSymptoms,
    ["Assessment, Performed": "Pain score [KOOS]"] KOOSPain
    let KOOSLifeQualityTime: start of Global."NormalizeInterval" ( KOOSLifeQuality.relevantDatetime, KOOSLifeQuality.relevantPeriod ),
    KOOSSportTime: start of Global."NormalizeInterval" ( KOOSSport.relevantDatetime, KOOSSport.relevantPeriod ),
    KOOSActivityScoreTime: start of Global."NormalizeInterval" ( KOOSActivityScore.relevantDatetime, KOOSActivityScore.relevantPeriod ),
    KOOSSymptomsTime: start of Global."NormalizeInterval" ( KOOSSymptoms.relevantDatetime, KOOSSymptoms.relevantPeriod ),
    KOOSPainTime: start of Global."NormalizeInterval" ( KOOSPain.relevantDatetime, KOOSPain.relevantPeriod )
    where KOOSLifeQualityTime same day as KOOSSportTime
      and KOOSSport.result is not null
      and KOOSLifeQualityTime same day as KOOSActivityScoreTime
      and KOOSActivityScore.result is not null
      and KOOSLifeQualityTime same day as KOOSSymptomsTime
      and KOOSSymptoms.result is not null
      and KOOSLifeQualityTime same day as KOOSPainTime
      and KOOSPain.result is not null
      and KOOSLifeQuality.result is not null
    return Max({ KOOSLifeQualityTime, KOOSSportTime, KOOSActivityScoreTime, KOOSSymptomsTime, KOOSPainTime })

define "Time PROMIS10 Total Assessment Completed":
  from
    ["Assessment, Performed": "PROMIS-10 Global Mental Health (GMH) score T-score"] PROMIS10MentalScore,
    ["Assessment, Performed": "PROMIS-10 Global Physical Health (GPH) score T-score"] PROMIS10PhysicalScore
    let PROMIS10MentalScoreTime: start of Global."NormalizeInterval" ( PROMIS10MentalScore.relevantDatetime, PROMIS10MentalScore.relevantPeriod ),
    PROMIS10PhysicalScoreTime: start of Global."NormalizeInterval" ( PROMIS10PhysicalScore.relevantDatetime, PROMIS10PhysicalScore.relevantPeriod )
    where PROMIS10MentalScoreTime same day as PROMIS10PhysicalScoreTime
      and PROMIS10PhysicalScore.result is not null
      and PROMIS10MentalScore.result is not null
    return Max({ PROMIS10MentalScoreTime, PROMIS10PhysicalScoreTime })

define "Time VR12 Oblique Total Assessment Completed":
  from
    ["Assessment, Performed": "VR-12 Mental component summary (MCS) score - oblique method T-score"] VR12MentalAssessment,
    ["Assessment, Performed": "VR-12 Physical component summary (PCS) score - oblique method T-score"] VR12PhysicalAssessment
    let VR12MentalAssessmentTime: start of Global."NormalizeInterval" ( VR12MentalAssessment.relevantDatetime, VR12MentalAssessment.relevantPeriod ),
    VR12PhysicalAssessmentTime: start of Global."NormalizeInterval" ( VR12PhysicalAssessment.relevantDatetime, VR12PhysicalAssessment.relevantPeriod )
    where VR12MentalAssessmentTime same day as VR12PhysicalAssessmentTime
      and VR12MentalAssessment.result is not null
      and VR12PhysicalAssessment.result is not null
    return Max({ VR12MentalAssessmentTime, VR12PhysicalAssessmentTime })

define "Time VR12 Orthogonal Total Assessment Completed":
  from
    ["Assessment, Performed": "VR-12 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalAssessment,
    ["Assessment, Performed": "VR-12 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalAssessment
    let VR12MentalAssessmentTime: start of Global."NormalizeInterval" ( VR12MentalAssessment.relevantDatetime, VR12MentalAssessment.relevantPeriod ),
    VR12PhysicalAssessmentTime: start of Global."NormalizeInterval" ( VR12PhysicalAssessment.relevantDatetime, VR12PhysicalAssessment.relevantPeriod )
    where VR12MentalAssessmentTime same day as VR12PhysicalAssessmentTime
      and VR12MentalAssessment.result is not null
      and VR12PhysicalAssessment.result is not null
    return Max({ VR12MentalAssessmentTime, VR12PhysicalAssessmentTime })

define "Has Qualifying Encounters":
  exists ( ( ["Encounter, Performed": "Outpatient Consultation"]
      union ["Encounter, Performed": "Office Visit"]
      union ["Encounter, Performed": "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"]
      union ["Encounter, Performed": "Telephone Visits"]
      union ["Encounter, Performed": "Online Assessments"] ) ValidEncounters
      where ValidEncounters.relevantPeriod during day of "Measurement Period"
  )

define "Time KOOSJr Total Assessment Completed":
  ( ["Assessment, Performed": "Knee injury and osteoarthritis outcome score for joint replacement [KOOSJR]"] KOOSJr
    where KOOSJr.result is not null ) DocumentedKOOSJr
    return start of Global."NormalizeInterval" ( DocumentedKOOSJr.relevantDatetime, DocumentedKOOSJr.relevantPeriod )

define "Has Total Knee Arthroplasty with 2 or More Lower Body Fractures":
  exists ( "Total Knee Arthroplasty Procedure" TKAProcedure
      where Count(["Diagnosis": "Lower Body Fracture"] LowerBodyFracture
          where LowerBodyFracture.prevalencePeriod starts 24 hours or less on or before start of Global."NormalizeInterval"(TKAProcedure.relevantDatetime, TKAProcedure.relevantPeriod)
      )>= 2
  )

define "Has TKA with Initial and Follow Up KOOS Assessments":
  exists ( ( "Total Knee Arthroplasty Procedure" TKAProcedure
      return Global."NormalizeInterval" ( TKAProcedure.relevantDatetime, TKAProcedure.relevantPeriod ) ) TotalKnee
      with "Time KOOS Total Assessment Completed" InitialKOOSAssessmentTime
        such that TotalKnee starts 90 days or less on or after InitialKOOSAssessmentTime
      with "Time KOOS Total Assessment Completed" FollowUpKOOSAssessmentTime
        such that FollowUpKOOSAssessmentTime during day of Interval[
        end of TotalKnee + 270 days, 
        end of TotalKnee + 365 days]
  )

define "Has TKA with Initial and Follow Up KOOSJr Assessments":
  exists ( ( "Total Knee Arthroplasty Procedure" TKAProcedure
      return Global."NormalizeInterval" ( TKAProcedure.relevantDatetime, TKAProcedure.relevantPeriod ) ) TotalKnee
      with "Time KOOSJr Total Assessment Completed" InitialKOOSJrAssessment
        such that TotalKnee starts 90 days or less on or after InitialKOOSJrAssessment
      with "Time KOOSJr Total Assessment Completed" FollowUpKOOSJrAssessment
        such that FollowUpKOOSJrAssessment during day of Interval[
        end of TotalKnee + 270 days, 
        end of TotalKnee + 365 days]
  )

define "Has TKA with Initial and Follow Up PROMIS10 Assessments":
  exists ( ( "Total Knee Arthroplasty Procedure" TKAProcedure
      return Global."NormalizeInterval" ( TKAProcedure.relevantDatetime, TKAProcedure.relevantPeriod ) ) TotalKnee
      with "Time PROMIS10 Total Assessment Completed" InitialPROMIS10AssessmentTime
        such that TotalKnee starts 90 days or less on or after InitialPROMIS10AssessmentTime
      with "Time PROMIS10 Total Assessment Completed" FollowUpPROMIS10AssessmentTime
        such that FollowUpPROMIS10AssessmentTime during day of Interval[
        end of TotalKnee + 270 days, 
        end of TotalKnee + 365 days]
  )

define "Has TKA with Initial and Follow Up VR12 Oblique Assessments":
  exists ( ( "Total Knee Arthroplasty Procedure" TKAProcedure
      return Global."NormalizeInterval" ( TKAProcedure.relevantDatetime, TKAProcedure.relevantPeriod ) ) TotalKnee
      with "Time VR12 Oblique Total Assessment Completed" InitialKneeAssessmentObliqueTime
        such that TotalKnee starts 90 days or less on or after InitialKneeAssessmentObliqueTime
      with "Time VR12 Oblique Total Assessment Completed" FollowUpObliqueAssessmentTime
        such that FollowUpObliqueAssessmentTime during day of Interval[
        end of TotalKnee + 270 days, 
        end of TotalKnee + 365 days]
  )

define "Has TKA with Initial and Follow Up VR12 Orthogonal Assessments":
  exists ( ( "Total Knee Arthroplasty Procedure" TKAProcedure
      return Global."NormalizeInterval" ( TKAProcedure.relevantDatetime, TKAProcedure.relevantPeriod ) ) TotalKnee
      with "Time VR12 Orthogonal Total Assessment Completed" InitialOrthogonalAssessmentTime
        such that TotalKnee starts 90 days or less on or after InitialOrthogonalAssessmentTime
      with "Time VR12 Orthogonal Total Assessment Completed" FollowUpOrthogonalAssessmentTime
        such that FollowUpOrthogonalAssessmentTime during day of Interval[
        end of TotalKnee + 270 days, 
        end of TotalKnee + 365 days]
  )

define "Total Knee Arthroplasty Procedure":
  ["Procedure, Performed": "Primary TKA Procedure"] TKAProcedure
    where Global."NormalizeInterval" ( TKAProcedure.relevantDatetime, TKAProcedure.relevantPeriod ) starts 12 months or less before start of "Measurement Period"