library FunctionalStatusAssessmentforTotalHipReplacement version '11.0.000'

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
valueset "Primary THA Procedure": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1006'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Activities of daily living score [HOOS]": '72095-3' from "LOINC" display 'Activities of daily living score [HOOS]'
code "Pain score [HOOS]": '72097-9' from "LOINC" display 'Pain score [HOOS]'
code "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure": '99024' from "CPT" display 'Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "Quality of life score [HOOS]": '72093-8' from "LOINC" display 'Quality of life score [HOOS]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Sport-recreation score [HOOS]": '72094-6' from "LOINC" display 'Sport-recreation score [HOOS]'
code "Symptoms score [HOOS]": '72096-1' from "LOINC" display 'Symptoms score [HOOS]'
code "Total interval score [HOOSJR]": '82323-7' from "LOINC" display 'Total interval score [HOOSJR]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or "Has Total Hip Arthroplasty with 2 or More Lower Body Fractures"
    or "Has Dementia Diagnosis"

define "Has Dementia Diagnosis":
  exists ( ["Diagnosis": "Severe dementia (disorder)"] Dementia
      where Dementia.prevalencePeriod overlaps "Measurement Period"
  )

define "Has Qualifying Encounter":
  exists ( ( ["Encounter, Performed": "Outpatient Consultation"]
      union ["Encounter, Performed": "Office Visit"]
      union ["Encounter, Performed": "Postoperative follow-up visit, normally included in the surgical package, to indicate that an evaluation and management service was performed during a postoperative period for a reason(s) related to the original procedure"]
      union ["Encounter, Performed": "Telephone Visits"]
      union ["Encounter, Performed": "Online Assessments"] ) ValidEncounters
      where ValidEncounters.relevantPeriod during day of "Measurement Period"
  )

define "Numerator":
  ( "Has THA with Initial and Follow Up HOOS Assessments" )
    or ( "Has THA with Initial and Follow Up HOOSJr Assessments" )
    or ( "Has THA with Initial and Follow Up PROMIS10 Assessments" )
    or ( "Has THA with Initial and Follow Up VR12 Oblique Assessments" )
    or ( "Has THA with Initial and Follow Up VR12 Orthogonal Assessments" )

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Time HOOS Total Assessment Completed":
  from
    ["Assessment, Performed": "Quality of life score [HOOS]"] HOOSLifeQuality,
    ["Assessment, Performed": "Sport-recreation score [HOOS]"] HOOSSport,
    ["Assessment, Performed": "Activities of daily living score [HOOS]"] HOOSActivityScore,
    ["Assessment, Performed": "Symptoms score [HOOS]"] HOOSSymptoms,
    ["Assessment, Performed": "Pain score [HOOS]"] HOOSPain
    let HOOSLifeQualityTime: start of Global."NormalizeInterval" ( HOOSLifeQuality.relevantDatetime, HOOSLifeQuality.relevantPeriod ),
    HOOSSportTime: start of Global."NormalizeInterval" ( HOOSSport.relevantDatetime, HOOSSport.relevantPeriod ),
    HOOSActivityScoreTime: start of Global."NormalizeInterval" ( HOOSActivityScore.relevantDatetime, HOOSActivityScore.relevantPeriod ),
    HOOSSymptomsTime: start of Global."NormalizeInterval" ( HOOSSymptoms.relevantDatetime, HOOSSymptoms.relevantPeriod ),
    HOOSPainTime: start of Global."NormalizeInterval" ( HOOSPain.relevantDatetime, HOOSPain.relevantPeriod )
    where HOOSLifeQualityTime same day as HOOSSportTime
      and HOOSSport.result is not null
      and HOOSLifeQualityTime same day as HOOSActivityScoreTime
      and HOOSActivityScore.result is not null
      and HOOSLifeQualityTime same day as HOOSSymptomsTime
      and HOOSSymptoms.result is not null
      and HOOSLifeQualityTime same day as HOOSPainTime
      and HOOSPain.result is not null
      and HOOSLifeQuality.result is not null
    return Max({ HOOSLifeQualityTime, HOOSSportTime, HOOSActivityScoreTime, HOOSSymptomsTime, HOOSPainTime })

define "Time HOOSJr Total Assessment Completed":
  ( ["Assessment, Performed": "Total interval score [HOOSJR]"] HOOSJr
    where HOOSJr.result is not null ) DocumentedHOOSJr
    return start of Global."NormalizeInterval" ( DocumentedHOOSJr.relevantDatetime, DocumentedHOOSJr.relevantPeriod )

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

define "Initial Population":
  "Has Qualifying Encounter"
    and exists ( "Total Hip Arthroplasty Procedure" )
    and AgeInYearsAt(date from start of "Measurement Period")>= 19

define "Has Total Hip Arthroplasty with 2 or More Lower Body Fractures":
  exists ( "Total Hip Arthroplasty Procedure" THAProcedure
      where Count(["Diagnosis": "Lower Body Fracture"] LowerBodyFracture
          where LowerBodyFracture.prevalencePeriod starts 24 hours or less on or before start of Global."NormalizeInterval"(THAProcedure.relevantDatetime, THAProcedure.relevantPeriod)
      )>= 2
  )

define "Has THA with Initial and Follow Up HOOS Assessments":
  exists ( ( "Total Hip Arthroplasty Procedure" THAProcedure
      return Global."NormalizeInterval" ( THAProcedure.relevantDatetime, THAProcedure.relevantPeriod ) ) TotalHip
      with "Time HOOS Total Assessment Completed" InitialHipAssessmentHOOS
        such that TotalHip starts 90 days or less on or after InitialHipAssessmentHOOS
      with "Time HOOS Total Assessment Completed" FollowUpHipAssessmentHOOS
        such that FollowUpHipAssessmentHOOS during day of Interval[
        end of TotalHip + 270 days, 
        end of TotalHip + 365 days]
  )

define "Has THA with Initial and Follow Up HOOSJr Assessments":
  exists ( ( "Total Hip Arthroplasty Procedure" THAProcedure
      return Global."NormalizeInterval" ( THAProcedure.relevantDatetime, THAProcedure.relevantPeriod ) ) TotalHip
      with "Time HOOSJr Total Assessment Completed" InitialHipAssessment
        such that TotalHip starts 90 days or less on or after InitialHipAssessment
      with "Time HOOSJr Total Assessment Completed" FollowUpHipAssessment
        such that FollowUpHipAssessment during day of Interval[
        end of TotalHip + 270 days, 
        end of TotalHip + 365 days]
  )

define "Has THA with Initial and Follow Up PROMIS10 Assessments":
  exists ( ( "Total Hip Arthroplasty Procedure" THAProcedure
      return Global."NormalizeInterval" ( THAProcedure.relevantDatetime, THAProcedure.relevantPeriod ) ) TotalHip
      with "Time PROMIS10 Total Assessment Completed" InitialHipAssessmentPROMIS10
        such that TotalHip starts 90 days or less on or after InitialHipAssessmentPROMIS10
      with "Time PROMIS10 Total Assessment Completed" FollowUpHipAssessmentPROMIS10
        such that FollowUpHipAssessmentPROMIS10 during day of Interval[
        end of TotalHip + 270 days, 
        end of TotalHip + 365 days]
  )

define "Has THA with Initial and Follow Up VR12 Oblique Assessments":
  exists ( ( "Total Hip Arthroplasty Procedure" THAProcedure
      return Global."NormalizeInterval" ( THAProcedure.relevantDatetime, THAProcedure.relevantPeriod ) ) TotalHip
      with "Time VR12 Oblique Total Assessment Completed" InitialHipAssessmentOblique
        such that TotalHip starts 90 days or less on or after InitialHipAssessmentOblique
      with "Time VR12 Oblique Total Assessment Completed" FollowUpHipAssessmentOblique
        such that FollowUpHipAssessmentOblique during day of Interval[
        end of TotalHip + 270 days, 
        end of TotalHip + 365 days]
  )

define "Has THA with Initial and Follow Up VR12 Orthogonal Assessments":
  exists ( ( "Total Hip Arthroplasty Procedure" THAProcedure
      return Global."NormalizeInterval" ( THAProcedure.relevantDatetime, THAProcedure.relevantPeriod ) ) TotalHip
      with "Time VR12 Orthogonal Total Assessment Completed" InitialHipAssessmentOrthogonal
        such that TotalHip starts 90 days or less on or after InitialHipAssessmentOrthogonal
      with "Time VR12 Orthogonal Total Assessment Completed" FollowUpHipAssessmentOrthogonal
        such that FollowUpHipAssessmentOrthogonal during day of Interval[
        end of TotalHip + 270 days, 
        end of TotalHip + 365 days]
  )

define "Total Hip Arthroplasty Procedure":
  ["Procedure, Performed": "Primary THA Procedure"] THAProcedure
    where Global."NormalizeInterval" ( THAProcedure.relevantDatetime, THAProcedure.relevantPeriod ) starts 12 months or less on or before start of "Measurement Period"