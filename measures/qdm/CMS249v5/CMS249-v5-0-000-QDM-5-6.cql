library AppropriateDXAScansForWomenUnder65 version '5.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "AdministrativeGender": 'urn:oid:2.16.840.1.113883.5.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Amenorrhea": 'urn:oid:2.16.840.1.113883.3.464.1003.1022'
valueset "Ankylosing Spondylitis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1045'
valueset "Aromatase Inhibitors": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1265'
valueset "Bilateral Oophorectomy": 'urn:oid:2.16.840.1.113883.3.526.3.471'
valueset "Bone Marrow Transplant": 'urn:oid:2.16.840.1.113883.3.666.5.336'
valueset "Chemotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.485'
valueset "Chronic Liver Disease": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1035'
valueset "Chronic Malnutrition": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1036'
valueset "Cushings Syndrome": 'urn:oid:2.16.840.1.113883.3.464.1003.117.12.1009'
valueset "DXA (Dual energy Xray Absorptiometry) Scan": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1051'
valueset "Eating Disorders": 'urn:oid:2.16.840.1.113883.3.464.1003.1039'
valueset "Ehlers Danlos Syndrome": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1047'
valueset "End Stage Renal Disease": 'urn:oid:2.16.840.1.113883.3.526.3.353'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Evidence of Bilateral Oophorectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.1048'
valueset "Gastric Bypass Surgery": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1050'
valueset "Glucocorticoids (oral only)": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1266'
valueset "History of hip fracture in parent": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1040'
valueset "Hyperparathyroidism": 'urn:oid:2.16.840.1.113883.3.464.1003.117.12.1016'
valueset "Hyperthyroidism": 'urn:oid:2.16.840.1.113883.3.464.1003.117.12.1015'
valueset "Kidney Transplant": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1012'
valueset "Lupus": 'urn:oid:2.16.840.1.113883.3.464.1003.117.12.1010'
valueset "Major Transplant": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1075'
valueset "Malabsorption Syndromes": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1050'
valueset "Marfan's Syndrome": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1048'
valueset "Multiple Myeloma": 'urn:oid:2.16.840.1.113883.3.464.1003.1011'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Osteogenesis Imperfecta": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1044'
valueset "Osteopenia": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1049'
valueset "Osteoporosis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1038'
valueset "Osteoporotic Fractures": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1050'
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Premature Menopause": 'urn:oid:2.16.840.1.113883.3.464.1003.1013'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Psoriatic Arthritis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1046'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Rheumatoid Arthritis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1005'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Type 1 Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1020'
valueset "Unilateral Oophorectomy Left": 'urn:oid:2.16.840.1.113883.3.464.1003.1028'
valueset "Unilateral Oophorectomy Right": 'urn:oid:2.16.840.1.113883.3.464.1003.1032'
valueset "Unilateral Oophorectomy, Unspecified Laterality": 'urn:oid:2.16.840.1.113883.3.464.1003.1035'

code "Alcoholic drinks per drinking day - Reported": '11287-0' from "LOINC" display 'Alcoholic drinks per drinking day - Reported'
code "Body mass index (BMI) [Ratio]": '39156-5' from "LOINC" display 'Body mass index (BMI) [Ratio]'
code "Female": 'F' from "AdministrativeGender" display 'Female'
code "Left (qualifier value)": '7771000' from "SNOMEDCT" display 'Left (qualifier value)'
code "Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment": '90265-0' from "LOINC" display 'Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment'
code "Osteoporosis Index of Risk panel": '98133-2' from "LOINC" display 'Osteoporosis Index of Risk panel'
code "Osteoporosis Risk Assessment Instrument": '98139-9' from "LOINC" display 'Osteoporosis Risk Assessment Instrument'
code "Osteoporosis Self-Assessment Tool": '98146-4' from "LOINC" display 'Osteoporosis Self-Assessment Tool'
code "Right (qualifier value)": '24028007' from "SNOMEDCT" display 'Right (qualifier value)'
code "Unlisted preventive medicine service": '99429' from "CPT" display 'Unlisted preventive medicine service'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Initial Population":
  AgeInYearsAt(date from start of "Measurement Period")in Interval[50, 63]
    and exists ( ["Patient Characteristic Sex": "Female"] )
    and exists "Qualifying Encounter"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  "Has Risk Factor Active During the Measurement Period"
    or "Has Risk Factor Any Time in History Prior to Measurement Period"
    or "Has Risk Factor Any Time in History Prior to Measurement Period and Do Not Need to be Active During Measurement Period"
    or "Has Risk Factor Any Time in History or During Measurement Period"

define "Has Risk Factor Any Time in History Prior to Measurement Period":
  "Has Osteoporosis Before Measurement Period"
    or "Has Osteopenia Before Measurement Period"

define "Has Risk Factor Active During the Measurement Period":
  "First BMI in Measurement Period Less Than or Equal to 20 kg m2" is not null
    or "First Average Number of Drinks Assessment Indicating More Than Two Per Day" is not null

define "First BMI in Measurement Period Less Than or Equal to 20 kg m2":
  "First BMI in Measurement Period" FirstBMI
    where FirstBMI.result <= 20 'kg/m2'

define "First BMI in Measurement Period":
  First(["Physical Exam, Performed": "Body mass index (BMI) [Ratio]"] BMI
      where start of Global."NormalizeInterval"(BMI.relevantDatetime, BMI.relevantPeriod)during "Measurement Period"
        and BMI.result is not null
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )

define "Has Risk Factor Any Time in History or During Measurement Period":
  "Has 90 or More Active Glucocorticoid Medication Days"
    or exists ( "DiagnosisInPatientHistory"(["Diagnosis": "Osteoporotic Fractures"]
          union ["Diagnosis": "Malabsorption Syndromes"]
          union ["Diagnosis": "Chronic Malnutrition"]
          union ["Diagnosis": "Chronic Liver Disease"]
          union ["Diagnosis": "Rheumatoid Arthritis"]
          union ["Diagnosis": "Hyperthyroidism"]
          union ["Diagnosis": "Type 1 Diabetes"]
          union ["Diagnosis": "End Stage Renal Disease"]
          union ["Diagnosis": "Osteogenesis Imperfecta"]
          union ["Diagnosis": "Ankylosing Spondylitis"]
          union ["Diagnosis": "Psoriatic Arthritis"]
          union ["Diagnosis": "Ehlers Danlos Syndrome"]
          union ["Diagnosis": "Cushings Syndrome"]
          union ["Diagnosis": "Hyperparathyroidism"]
          union ["Diagnosis": "Marfan's Syndrome"]
          union ["Diagnosis": "Lupus"]
          union ["Diagnosis": "Multiple Myeloma"]
          union ["Diagnosis": "Premature Menopause"]
          union ["Diagnosis": "Eating Disorders"]
          union ["Diagnosis": "Amenorrhea"]
      )
    )
    or exists "ProcedureInPatientHistory"(["Procedure, Performed": "Chemotherapy"])
    or "Has Double or Bilateral Oophorectomy"
    or "Has Organ Transplants"

define "Has Organ Transplants":
  exists "ProcedureInPatientHistory"(["Procedure, Performed": "Major Transplant"]
      union ["Procedure, Performed": "Kidney Transplant"]
      union ["Procedure, Performed": "Bone Marrow Transplant"]
  )

define "Has Double or Bilateral Oophorectomy":
  exists ( "ProcedureInPatientHistory"(["Procedure, Performed": "Bilateral Oophorectomy"]))
    or exists ( "ProcedureInPatientHistory"(["Procedure, Performed": "Evidence of Bilateral Oophorectomy"]))
    or ( exists ( "ProcedureInPatientHistory"((["Procedure, Performed": "Unilateral Oophorectomy, Unspecified Laterality"] UnilateralOophorectomy
              where UnilateralOophorectomy.anatomicalLocationSite ~ "Right (qualifier value)"
          )
            union ["Procedure, Performed": "Unilateral Oophorectomy Right"]
        )
      )
        and exists ( "ProcedureInPatientHistory"((["Procedure, Performed": "Unilateral Oophorectomy, Unspecified Laterality"] UnilateralOophorectomy
                where UnilateralOophorectomy.anatomicalLocationSite ~ "Left (qualifier value)"
            )
              union ["Procedure, Performed": "Unilateral Oophorectomy Left"]
          )
        )
    )

define "Has Osteoporosis Before Measurement Period":
  exists ["Diagnosis": "Osteoporosis"] OsteoporosisDiagnosis
    where OsteoporosisDiagnosis.prevalencePeriod starts before start of "Measurement Period"

define "Has Osteopenia Before Measurement Period":
  exists ["Diagnosis": "Osteopenia"] OsteopeniaDiagnosis
    where OsteopeniaDiagnosis.prevalencePeriod starts before start of "Measurement Period"

define "First Average Number of Drinks Assessment Indicating More Than Two Per Day":
  First(["Assessment, Performed": "Alcoholic drinks per drinking day - Reported"] AverageDrinks
      where start of Global."NormalizeInterval"(AverageDrinks.relevantDatetime, AverageDrinks.relevantPeriod)during "Measurement Period"
        and AverageDrinks.result > 2 '{drinks}/d'
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )

define "Parent History of Hip Fracture Assessment":
  ["Assessment, Performed": "History of hip fracture in parent"] ParentFractureHistory
    where start of Global."NormalizeInterval" ( ParentFractureHistory.relevantDatetime, ParentFractureHistory.relevantPeriod ) before start of "Measurement Period"

define "Glucocorticoid Active Medication Days":
  Sum("Glucocorticoid Active Medication Duration in Days")

define "Has 90 or More Active Glucocorticoid Medication Days":
  "Glucocorticoid Active Medication Days" >= 90

define "Numerator":
  exists "DXA Scan Order During Measurement Period"

define "Numerator Exclusion":
  exists "Osteoporosis Fracture Risk Assessment Prior to First DXA Scan"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Glucocorticoid Active Medication Duration in Days":
  ( collapse ( ["Medication, Active": "Glucocorticoids (oral only)"] Glucocorticoid
      where Glucocorticoid.relevantPeriod starts before 
      end of "Measurement Period"
  ).relevantPeriod per day ) GlucocorticoidIntervals
    return difference in days of ( GlucocorticoidIntervals
        intersect Interval[Patient.birthDatetime, 
        end of "Measurement Period"]
    ) + 1

define "Qualifying Encounter":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Unlisted preventive medicine service"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Outpatient Consultation"]
    union ["Encounter, Performed": "Online Assessments"]
    union ["Encounter, Performed": "Telephone Visits"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "DXA Scan Order During Measurement Period":
  ["Diagnostic Study, Order": "DXA (Dual energy Xray Absorptiometry) Scan"] DXA
    where DXA.authorDatetime during "Measurement Period"
    sort by authorDatetime asc

define "Has Risk Factor Any Time in History Prior to Measurement Period and Do Not Need to be Active During Measurement Period":
  exists ( ( ["Procedure, Performed": "Gastric Bypass Surgery"] GastricBypass
        where Global."NormalizeInterval" ( GastricBypass.relevantDatetime, GastricBypass.relevantPeriod ) ends before start of "Measurement Period"
    )
      union ( ["Medication, Active": "Aromatase Inhibitors"] AromataseInhibitorActive
          where Global."NormalizeInterval" ( AromataseInhibitorActive.relevantDatetime, AromataseInhibitorActive.relevantPeriod ) starts before start of "Measurement Period"
      )
      union ( ["Medication, Order": "Aromatase Inhibitors"] AromataseInhibitorOrder
          where AromataseInhibitorOrder.authorDatetime before start of "Measurement Period"
      )
      union "Parent History of Hip Fracture Assessment"
  )

define "Osteoporosis Fracture Risk Assessment Prior to First DXA Scan":
  ( ( ["Assessment, Performed": "Major osteoporotic fracture 10-year probability [Likelihood] Fracture Risk Assessment"] FRAX
      where FRAX.result >= 8.4 '%'
  )
    union ( ["Assessment, Performed": "Osteoporosis Risk Assessment Instrument"] ORAI
        where ORAI.result >= 9
    )
    union ( ["Assessment, Performed": "Osteoporosis Index of Risk panel"] OSIRIS
        where OSIRIS.result < 1.0
    )
    union ( ["Assessment, Performed": "Osteoporosis Self-Assessment Tool"] OST
        where OST.result < 2.0
    ) ) RiskAssessment
    where start of Global."NormalizeInterval" ( RiskAssessment.relevantDatetime, RiskAssessment.relevantPeriod ) before First("DXA Scan Order During Measurement Period").authorDatetime

define function "ProcedureInPatientHistory"(Procedure List<"Procedure, Performed">):
  Procedure Proc
    where Global."NormalizeInterval" ( Proc.relevantDatetime, Proc.relevantPeriod ) ends on or before day of 
    end of "Measurement Period"

define function "DiagnosisInPatientHistory"(Diagnosis List<"Diagnosis">):
  Diagnosis Dx
    where Dx.prevalencePeriod starts on or before day of 
    end of "Measurement Period"