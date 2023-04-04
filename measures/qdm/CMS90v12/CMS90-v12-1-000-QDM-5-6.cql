library FunctionalStatusAssessmentsforHeartFailure version '12.1.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '4.0.000' called Hospice

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Heart Failure": 'urn:oid:2.16.840.1.113883.3.526.3.376'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "Emotional score [MLHFQ]": '85609-6' from "LOINC" display 'Emotional score [MLHFQ]'
code "Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]": '86923-0' from "LOINC" display 'Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]'
code "Overall summary score [KCCQ-12]": '86924-8' from "LOINC" display 'Overall summary score [KCCQ-12]'
code "Overall summary score [KCCQ]": '71940-1' from "LOINC" display 'Overall summary score [KCCQ]'
code "Physical limitation score [KCCQ]": '72195-1' from "LOINC" display 'Physical limitation score [KCCQ]'
code "Physical score [MLHFQ]": '85618-7' from "LOINC" display 'Physical score [MLHFQ]'
code "PROMIS-10 Global Mental Health (GMH) score T-score": '71969-0' from "LOINC" display 'PROMIS-10 Global Mental Health (GMH) score T-score'
code "PROMIS-10 Global Physical Health (GPH) score T-score": '71971-6' from "LOINC" display 'PROMIS-10 Global Physical Health (GPH) score T-score'
code "PROMIS-29 Anxiety score T-score": '71967-4' from "LOINC" display 'PROMIS-29 Anxiety score T-score'
code "PROMIS-29 Depression score T-score": '71965-8' from "LOINC" display 'PROMIS-29 Depression score T-score'
code "PROMIS-29 Fatigue score T-score": '71963-3' from "LOINC" display 'PROMIS-29 Fatigue score T-score'
code "PROMIS-29 Pain interference score T-score": '71961-7' from "LOINC" display 'PROMIS-29 Pain interference score T-score'
code "PROMIS-29 Physical function score T-score": '71959-1' from "LOINC" display 'PROMIS-29 Physical function score T-score'
code "PROMIS-29 Satisfaction with participation in social roles score T-score": '71957-5' from "LOINC" display 'PROMIS-29 Satisfaction with participation in social roles score T-score'
code "PROMIS-29 Sleep disturbance score T-score": '71955-9' from "LOINC" display 'PROMIS-29 Sleep disturbance score T-score'
code "Quality of life score [KCCQ]": '72189-4' from "LOINC" display 'Quality of life score [KCCQ]'
code "Self-efficacy score [KCCQ]": '72190-2' from "LOINC" display 'Self-efficacy score [KCCQ]'
code "Severe dementia (disorder)": '428351000124105' from "SNOMEDCT" display 'Severe dementia (disorder)'
code "Social limitation score [KCCQ]": '72196-9' from "LOINC" display 'Social limitation score [KCCQ]'
code "Symptom stability score [KCCQ]": '72194-4' from "LOINC" display 'Symptom stability score [KCCQ]'
code "Total symptom score [KCCQ]": '72191-0' from "LOINC" display 'Total symptom score [KCCQ]'
code "VR-12 Mental component summary (MCS) score - oblique method T-score": '72026-8' from "LOINC" display 'VR-12 Mental component summary (MCS) score - oblique method T-score'
code "VR-12 Mental component summary (MCS) score - orthogonal method T-score": '72028-4' from "LOINC" display 'VR-12 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-12 Physical component summary (PCS) score - oblique method T-score": '72025-0' from "LOINC" display 'VR-12 Physical component summary (PCS) score - oblique method T-score'
code "VR-12 Physical component summary (PCS) score - orthogonal method T-score": '72027-6' from "LOINC" display 'VR-12 Physical component summary (PCS) score - orthogonal method T-score'
code "VR-36 Mental component summary (MCS) score - oblique method T-score": '71990-6' from "LOINC" display 'VR-36 Mental component summary (MCS) score - oblique method T-score'
code "VR-36 Mental component summary (MCS) score - orthogonal method T-score": '72008-6' from "LOINC" display 'VR-36 Mental component summary (MCS) score - orthogonal method T-score'
code "VR-36 Physical component summary (PCS) score - oblique method T-score": '71989-8' from "LOINC" display 'VR-36 Physical component summary (PCS) score - oblique method T-score'
code "VR-36 Physical component summary (PCS) score - orthogonal method T-score": '72007-8' from "LOINC" display 'VR-36 Physical component summary (PCS) score - orthogonal method T-score'

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

define "Numerator":
  ( "Has Encounter with Initial and Follow Up PROMIS10 Assessments" )
    or ( "Has Encounter with Initial and Follow Up PROMIS29 Assessments" )
    or ( "Has Encounter with Initial and Follow Up VR12 Oblique Assessments" )
    or ( "Has Encounter with Initial and Follow Up VR12 Orthogonal Assessments" )
    or ( "Has Encounter with Initial and Follow Up VR36 Oblique Assessments" )
    or ( "Has Encounter with Initial and Follow Up VR36 Orthogonal Assessments" )
    or ( "Has Encounter with Initial and Follow Up MLHFQ Assessments" )
    or ( "Has Encounter with Initial and Follow Up KCCQ12 Assessments" )
    or ( "Has Encounter with Initial and Follow Up KCCQ Domain Score Assessments" )
    or ( "Has Encounter with Initial and Follow Up KCCQ Total Score Assessments" )

define "Time KCCQ Domain Assessment Completed":
  from
    ["Assessment, Performed": "Quality of life score [KCCQ]"] KCCQLifeQuality,
    ["Assessment, Performed": "Symptom stability score [KCCQ]"] KCCQSymptomStability,
    ["Assessment, Performed": "Self-efficacy score [KCCQ]"] KCCQSelfEfficacy,
    ["Assessment, Performed": "Total symptom score [KCCQ]"] KCCQSymptoms,
    ["Assessment, Performed": "Physical limitation score [KCCQ]"] KCCQPhysicalLimits,
    ["Assessment, Performed": "Social limitation score [KCCQ]"] KCCQSocialLimits
    let KCCQLifeQualityTime: start of Global."NormalizeInterval" ( KCCQLifeQuality.relevantDatetime, KCCQLifeQuality.relevantPeriod ),
    KCCQSymptomStabilityTime: start of Global."NormalizeInterval" ( KCCQSymptomStability.relevantDatetime, KCCQSymptomStability.relevantPeriod ),
    KCCQSelfEfficacyTime: start of Global."NormalizeInterval" ( KCCQSelfEfficacy.relevantDatetime, KCCQSelfEfficacy.relevantPeriod ),
    KCCQSymptomsTime: start of Global."NormalizeInterval" ( KCCQSymptoms.relevantDatetime, KCCQSymptoms.relevantPeriod ),
    KCCQPhysicalLimitsTime: start of Global."NormalizeInterval" ( KCCQPhysicalLimits.relevantDatetime, KCCQPhysicalLimits.relevantPeriod ),
    KCCQSocialLimitsTime: start of Global."NormalizeInterval" ( KCCQSocialLimits.relevantDatetime, KCCQSocialLimits.relevantPeriod )
    where KCCQLifeQualityTime same day as KCCQSymptomStabilityTime
      and KCCQSymptomStability.result is not null
      and KCCQLifeQualityTime same day as KCCQSelfEfficacyTime
      and KCCQSelfEfficacy.result is not null
      and KCCQLifeQualityTime same day as KCCQSymptomsTime
      and KCCQSymptoms.result is not null
      and KCCQLifeQualityTime same day as KCCQPhysicalLimitsTime
      and KCCQPhysicalLimits.result is not null
      and KCCQLifeQualityTime same day as KCCQSocialLimitsTime
      and KCCQSocialLimits.result is not null
      and KCCQLifeQuality.result is not null
    return Max({ KCCQLifeQualityTime, KCCQSymptomStabilityTime, KCCQSelfEfficacyTime, KCCQSymptomsTime, KCCQPhysicalLimitsTime, KCCQSocialLimitsTime })

define "Time KCCQ Total Assessment Completed":
  ["Assessment, Performed": "Overall summary score [KCCQ]"] KCCQSummaryScore
    let KCCQSummaryScoreTime: start of Global."NormalizeInterval" ( KCCQSummaryScore.relevantDatetime, KCCQSummaryScore.relevantPeriod )
    where KCCQSummaryScore.result is not null
    return Max({ KCCQSummaryScoreTime })

define "Time KCCQ12 Total Assessment Completed":
  from
    ["Assessment, Performed": "Kansas City Cardiomyopathy Questionnaire - 12 item [KCCQ-12]"] KCCQ12Item,
    ["Assessment, Performed": "Overall summary score [KCCQ-12]"] KCCQ12Summary
    let KCCQ12ItemTime: date from start of Global."NormalizeInterval" ( KCCQ12Item.relevantDatetime, KCCQ12Item.relevantPeriod ),
    KCCQ12SummaryTime: date from start of Global."NormalizeInterval" ( KCCQ12Summary.relevantDatetime, KCCQ12Summary.relevantPeriod )
    where KCCQ12ItemTime same day as KCCQ12SummaryTime
      and KCCQ12Summary.result is not null
      and KCCQ12Item.result is not null
    return Max({ KCCQ12ItemTime, KCCQ12SummaryTime })

define "Time MLHFQ Total Assessment Completed":
  from
    ["Assessment, Performed": "Physical score [MLHFQ]"] MLHFQPhysical,
    ["Assessment, Performed": "Emotional score [MLHFQ]"] MLHFQEmotional
    let MLHFQPhysicalTime: date from start of Global."NormalizeInterval" ( MLHFQPhysical.relevantDatetime, MLHFQPhysical.relevantPeriod ),
    MLHFQEmotionalTime: date from start of Global."NormalizeInterval" ( MLHFQEmotional.relevantDatetime, MLHFQEmotional.relevantPeriod )
    where MLHFQPhysicalTime same day as MLHFQEmotionalTime
      and MLHFQEmotional.result is not null
      and MLHFQPhysical.result is not null
    return Max({ MLHFQPhysicalTime, MLHFQEmotionalTime })

define "Time PROMIS10 Total Assessment Completed":
  from
    ["Assessment, Performed": "PROMIS-10 Global Mental Health (GMH) score T-score"] PROMIS10MentalScore,
    ["Assessment, Performed": "PROMIS-10 Global Physical Health (GPH) score T-score"] PROMIS10PhysicalScore
    let PROMIS10MentalScoreTime: date from start of Global."NormalizeInterval" ( PROMIS10MentalScore.relevantDatetime, PROMIS10MentalScore.relevantPeriod ),
    PROMIS10PhysicalScoreTime: date from start of Global."NormalizeInterval" ( PROMIS10PhysicalScore.relevantDatetime, PROMIS10PhysicalScore.relevantPeriod )
    where PROMIS10MentalScoreTime same day as PROMIS10PhysicalScoreTime
      and PROMIS10PhysicalScore.result is not null
      and PROMIS10MentalScore.result is not null
    return Max({ PROMIS10MentalScoreTime, PROMIS10PhysicalScoreTime })

define "Time PROMIS29 Total Assessment Completed":
  from
    ["Assessment, Performed": "PROMIS-29 Sleep disturbance score T-score"] Promis29Sleep,
    ["Assessment, Performed": "PROMIS-29 Satisfaction with participation in social roles score T-score"] Promis29SocialRoles,
    ["Assessment, Performed": "PROMIS-29 Physical function score T-score"] Promis29Physical,
    ["Assessment, Performed": "PROMIS-29 Pain interference score T-score"] Promis29Pain,
    ["Assessment, Performed": "PROMIS-29 Fatigue score T-score"] Promis29Fatigue,
    ["Assessment, Performed": "PROMIS-29 Depression score T-score"] Promis29Depression,
    ["Assessment, Performed": "PROMIS-29 Anxiety score T-score"] Promis29Anxiety
    let Promis29SleepTime: date from start of Global."NormalizeInterval" ( Promis29Sleep.relevantDatetime, Promis29Sleep.relevantPeriod ),
    Promis29SocialRolesTime: date from start of Global."NormalizeInterval" ( Promis29SocialRoles.relevantDatetime, Promis29SocialRoles.relevantPeriod ),
    Promis29PhysicalTime: date from start of Global."NormalizeInterval" ( Promis29Physical.relevantDatetime, Promis29Physical.relevantPeriod ),
    Promis29PainTime: date from start of Global."NormalizeInterval" ( Promis29Pain.relevantDatetime, Promis29Pain.relevantPeriod ),
    Promis29FatigueTime: date from start of Global."NormalizeInterval" ( Promis29Fatigue.relevantDatetime, Promis29Fatigue.relevantPeriod ),
    Promis29DepressionTime: date from start of Global."NormalizeInterval" ( Promis29Depression.relevantDatetime, Promis29Depression.relevantPeriod ),
    Promis29AnxietyTime: date from start of Global."NormalizeInterval" ( Promis29Anxiety.relevantDatetime, Promis29Anxiety.relevantPeriod )
    where Promis29SleepTime same day as Promis29SocialRolesTime
      and Promis29SocialRoles.result is not null
      and Promis29SleepTime same day as Promis29PhysicalTime
      and Promis29Physical.result is not null
      and Promis29SleepTime same day as Promis29PainTime
      and Promis29Pain.result is not null
      and Promis29SleepTime same day as Promis29FatigueTime
      and Promis29Fatigue.result is not null
      and Promis29SleepTime same day as Promis29DepressionTime
      and Promis29Depression.result is not null
      and Promis29SleepTime same day as Promis29AnxietyTime
      and Promis29Anxiety.result is not null
      and Promis29Sleep.result is not null
    return Max({ Promis29SleepTime, Promis29SocialRolesTime, Promis29PhysicalTime, Promis29PainTime, Promis29FatigueTime, Promis29DepressionTime, Promis29AnxietyTime })

define "Time VR12 Oblique Total Assessment Completed":
  from
    ["Assessment, Performed": "VR-12 Mental component summary (MCS) score - oblique method T-score"] VR12MentalAssessment,
    ["Assessment, Performed": "VR-12 Physical component summary (PCS) score - oblique method T-score"] VR12PhysicalAssessment
    let VR12MentalAssessmentTime: date from start of Global."NormalizeInterval" ( VR12MentalAssessment.relevantDatetime, VR12MentalAssessment.relevantPeriod ),
    VR12PhysicalAssessmentTime: date from start of Global."NormalizeInterval" ( VR12PhysicalAssessment.relevantDatetime, VR12PhysicalAssessment.relevantPeriod )
    where VR12MentalAssessmentTime same day as VR12PhysicalAssessmentTime
      and VR12MentalAssessment.result is not null
      and VR12PhysicalAssessment.result is not null
    return Max({ VR12MentalAssessmentTime, VR12PhysicalAssessmentTime })

define "Time VR12 Orthogonal Total Assessment Completed":
  from
    ["Assessment, Performed": "VR-12 Mental component summary (MCS) score - orthogonal method T-score"] VR12MentalAssessment,
    ["Assessment, Performed": "VR-12 Physical component summary (PCS) score - orthogonal method T-score"] VR12PhysicalAssessment
    let VR12MentalAssessmentTime: date from start of Global."NormalizeInterval" ( VR12MentalAssessment.relevantDatetime, VR12MentalAssessment.relevantPeriod ),
    VR12PhysicalAssessmentTime: date from start of Global."NormalizeInterval" ( VR12PhysicalAssessment.relevantDatetime, VR12PhysicalAssessment.relevantPeriod )
    where VR12MentalAssessmentTime same day as VR12PhysicalAssessmentTime
      and VR12MentalAssessment.result is not null
      and VR12PhysicalAssessment.result is not null
    return Max({ VR12MentalAssessmentTime, VR12PhysicalAssessmentTime })

define "Time VR36 Oblique Total Assessment Completed":
  from
    ["Assessment, Performed": "VR-36 Mental component summary (MCS) score - oblique method T-score"] VR36MentalAssessment,
    ["Assessment, Performed": "VR-36 Physical component summary (PCS) score - oblique method T-score"] VR36PhysicalAssessment
    let VR36MentalAssessmentTime: date from start of Global."NormalizeInterval" ( VR36MentalAssessment.relevantDatetime, VR36MentalAssessment.relevantPeriod ),
    VR36PhysicalAssessmentTime: date from start of Global."NormalizeInterval" ( VR36PhysicalAssessment.relevantDatetime, VR36PhysicalAssessment.relevantPeriod )
    where VR36MentalAssessmentTime same day as VR36PhysicalAssessmentTime
      and VR36MentalAssessment.result is not null
      and VR36PhysicalAssessment.result is not null
    return Max({ VR36MentalAssessmentTime, VR36PhysicalAssessmentTime })

define "Time VR36 Orthogonal Total Assessment Completed":
  from
    ["Assessment, Performed": "VR-36 Mental component summary (MCS) score - orthogonal method T-score"] VR36MentalAssessment,
    ["Assessment, Performed": "VR-36 Physical component summary (PCS) score - orthogonal method T-score"] VR36PhysicalAssessment
    let VR36MentalAssessmentTime: date from start of Global."NormalizeInterval" ( VR36MentalAssessment.relevantDatetime, VR36MentalAssessment.relevantPeriod ),
    VR36PhysicalAssessmentTime: date from start of Global."NormalizeInterval" ( VR36PhysicalAssessment.relevantDatetime, VR36PhysicalAssessment.relevantPeriod )
    where VR36MentalAssessmentTime same day as VR36PhysicalAssessmentTime
      and VR36MentalAssessment.result is not null
      and VR36PhysicalAssessment.result is not null
    return Max({ VR36MentalAssessmentTime, VR36PhysicalAssessmentTime })

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or exists ( ["Diagnosis": "Severe dementia (disorder)"] Dementia
        where Dementia.prevalencePeriod overlaps "Measurement Period"
    )

define "Two Outpatient Encounters during Measurement Period":
  from
    "Qualifying Encounters" OfficeVisit1,
    "Qualifying Encounters" OfficeVisit2
    where OfficeVisit2.relevantPeriod starts 1 day or more after day of 
    end of OfficeVisit1.relevantPeriod
    return OfficeVisit1

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")>= 18
    and exists ( ["Diagnosis": "Heart Failure"] HeartFailure
        where HeartFailure.prevalencePeriod overlaps before "Measurement Period"
    )
    and exists ( "Two Outpatient Encounters during Measurement Period" )

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Telephone Visits"]
    union ["Encounter, Performed": "Online Assessments"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "Has Encounter with Initial and Follow Up KCCQ Domain Score Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time KCCQ Domain Assessment Completed" InitialKCCQAssessmentTime,
      "Time KCCQ Domain Assessment Completed" FollowUpKCCQAssessmentTime
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialKCCQAssessmentTime 14 days or less on or before 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpKCCQAssessmentTime during day of Interval[date from InitialKCCQAssessmentTime + 30 days, date from InitialKCCQAssessmentTime + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up KCCQ Total Score Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time KCCQ Total Assessment Completed" InitialKCCQTotalScore,
      "Time KCCQ Total Assessment Completed" FollowUpKCCQTotalScore
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialKCCQTotalScore 14 days or less on or before 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpKCCQTotalScore during day of Interval[date from InitialKCCQTotalScore + 30 days, date from InitialKCCQTotalScore + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up KCCQ12 Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time KCCQ12 Total Assessment Completed" InitialKCCQ12Time,
      "Time KCCQ12 Total Assessment Completed" FollowUpKCCQ12Time
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialKCCQ12Time 14 days or less on or before day of 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpKCCQ12Time during day of Interval[date from InitialKCCQ12Time + 30 days, date from InitialKCCQ12Time + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up MLHFQ Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time MLHFQ Total Assessment Completed" InitialMLHFQTime,
      "Time MLHFQ Total Assessment Completed" FollowUpMLHFQTime
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialMLHFQTime 14 days or less on or before day of 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpMLHFQTime during day of Interval[date from InitialMLHFQTime + 30 days, date from InitialMLHFQTime + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up PROMIS10 Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time PROMIS10 Total Assessment Completed" InitialPROMIS10Time,
      "Time PROMIS10 Total Assessment Completed" FollowUpPROMIS10Time
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialPROMIS10Time 14 days or less on or before day of 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpPROMIS10Time during day of Interval[date from InitialPROMIS10Time + 30 days, date from InitialPROMIS10Time + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up PROMIS29 Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time PROMIS29 Total Assessment Completed" InitialPROMIS29Time,
      "Time PROMIS29 Total Assessment Completed" FollowUpPROMIS29Time
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialPROMIS29Time 14 days or less on or before day of 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpPROMIS29Time during day of Interval[date from InitialPROMIS29Time + 30 days, date from InitialPROMIS29Time + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up VR12 Oblique Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time VR12 Oblique Total Assessment Completed" InitialVR12ObliqueTime,
      "Time VR12 Oblique Total Assessment Completed" FollowUpVR12ObliqueTime
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialVR12ObliqueTime 14 days or less on or before day of 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpVR12ObliqueTime during day of Interval[date from InitialVR12ObliqueTime + 30 days, date from InitialVR12ObliqueTime + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up VR12 Orthogonal Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time VR12 Orthogonal Total Assessment Completed" InitialVR12OrthogonalTime,
      "Time VR12 Orthogonal Total Assessment Completed" FollowUpVR12OrthogonalTime
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialVR12OrthogonalTime 14 days or less on or before day of 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpVR12OrthogonalTime during day of Interval[date from InitialVR12OrthogonalTime + 30 days, date from InitialVR12OrthogonalTime + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up VR36 Orthogonal Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time VR36 Orthogonal Total Assessment Completed" InitialVR36OrthogonalTime,
      "Time VR36 Orthogonal Total Assessment Completed" FollowUpVR36OrthogonalTime
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialVR36OrthogonalTime 14 days or less on or before day of 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpVR36OrthogonalTime during day of Interval[date from InitialVR36OrthogonalTime + 30 days, date from InitialVR36OrthogonalTime + 180 days]
      return ValidEncounters
  )

define "Has Encounter with Initial and Follow Up VR36 Oblique Assessments":
  exists ( from
      "Qualifying Encounters" ValidEncounters,
      "Time VR36 Oblique Total Assessment Completed" InitialVR36ObliqueTime,
      "Time VR36 Oblique Total Assessment Completed" FollowUpVR36ObliqueTime
      where ValidEncounters.relevantPeriod ends 180 days or more before 
      end of "Measurement Period"
        and InitialVR36ObliqueTime 14 days or less on or before day of 
        end of ValidEncounters.relevantPeriod
        and date from FollowUpVR36ObliqueTime during day of Interval[date from InitialVR36ObliqueTime + 30 days, date from InitialVR36ObliqueTime + 180 days]
      return ValidEncounters
  )