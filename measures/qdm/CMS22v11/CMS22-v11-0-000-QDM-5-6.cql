library PCS_BPScreeningFollowUp version '11.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "ActCode": 'urn:oid:2.16.840.1.113883.5.4'

valueset "Diagnosis of Hypertension": 'urn:oid:2.16.840.1.113883.3.600.263'
valueset "Dietary Recommendations": 'urn:oid:2.16.840.1.113883.3.600.1515'
valueset "Encounter to Screen for Blood Pressure": 'urn:oid:2.16.840.1.113883.3.600.1920'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Finding of Elevated Blood Pressure or Hypertension": 'urn:oid:2.16.840.1.113762.1.4.1047.514'
valueset "Follow Up Within 4 Weeks": 'urn:oid:2.16.840.1.113883.3.526.3.1578'
valueset "Laboratory Tests for Hypertension": 'urn:oid:2.16.840.1.113883.3.600.1482'
valueset "Lifestyle Recommendation": 'urn:oid:2.16.840.1.113883.3.526.3.1581'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Patient Declined": 'urn:oid:2.16.840.1.113883.3.526.3.1582'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pharmacologic Therapy for Hypertension": 'urn:oid:2.16.840.1.113883.3.526.1577'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Recommendation to Increase Physical Activity": 'urn:oid:2.16.840.1.113883.3.600.1518'
valueset "Referral or Counseling for Alcohol Consumption": 'urn:oid:2.16.840.1.113883.3.526.3.1583'
valueset "Referral to Primary Care or Alternate Provider": 'urn:oid:2.16.840.1.113883.3.526.3.1580'
valueset "Weight Reduction Recommended": 'urn:oid:2.16.840.1.113883.3.600.1510'

code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "EKG 12 channel panel": '34534-8' from "LOINC" display 'EKG 12 channel panel'
code "EKG study": '11524-6' from "LOINC" display 'EKG study'
code "Follow-up 2-3 months (finding)": '183624006' from "SNOMEDCT" display 'Follow-up 2-3 months (finding)'
code "Follow-up 4-6 months (finding)": '183625007' from "SNOMEDCT" display 'Follow-up 4-6 months (finding)'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'
code "virtual": 'VR' from "ActCode" display 'virtual'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator":
  "Initial Population"

define "Denominator Exceptions":
  "Encounter with Medical Reason for Not Obtaining or Patient Declined Blood Pressure Measurement"
    union "Encounter with Order for Hypertension Follow Up Declined by Patient"

define "Denominator Exclusions":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    with ["Diagnosis": "Diagnosis of Hypertension"] Hypertension
      such that Hypertension.prevalencePeriod overlaps before QualifyingEncounter.relevantPeriod

define "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80":
  ( "Qualifying Encounter during Measurement Period" QualifyingEncounter
      let EncounterLastSystolicBP: Last(["Physical Exam, Performed": "Systolic blood pressure"] SystolicBP
          where Global."NormalizeInterval"(SystolicBP.relevantDatetime, SystolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
          sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
      ),
      EncounterLastDiastolicBP: Last(["Physical Exam, Performed": "Diastolic blood pressure"] DiastolicBP
          where Global."NormalizeInterval"(DiastolicBP.relevantDatetime, DiastolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
          sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
      )
      where EncounterLastSystolicBP.result > 0 'mm[Hg]'
        and EncounterLastDiastolicBP.result > 0 'mm[Hg]'
        and ( EncounterLastSystolicBP.result >= 130 'mm[Hg]'
            or EncounterLastDiastolicBP.result >= 80 'mm[Hg]'
        )
  )
    except "Encounter with Hypertensive Reading Within Year Prior"

define "Encounter with Hypertensive Reading Within Year Prior":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    let EncounterLastSystolicBP: Last(["Physical Exam, Performed": "Systolic blood pressure"] SystolicBP
        where Global."NormalizeInterval"(SystolicBP.relevantDatetime, SystolicBP.relevantPeriod)ends 1 year or less before start of QualifyingEncounter.relevantPeriod
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    ),
    EncounterLastDiastolicBP: Last(["Physical Exam, Performed": "Diastolic blood pressure"] DiastolicBP
        where Global."NormalizeInterval"(DiastolicBP.relevantDatetime, DiastolicBP.relevantPeriod)ends 1 year or less before start of QualifyingEncounter.relevantPeriod
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    )
    where EncounterLastSystolicBP.result > 0 'mm[Hg]'
      and EncounterLastDiastolicBP.result > 0 'mm[Hg]'
      and ( EncounterLastSystolicBP.result >= 130 'mm[Hg]'
          or EncounterLastDiastolicBP.result >= 80 'mm[Hg]'
      )

define "Encounter with Medical Reason for Not Obtaining or Patient Declined Blood Pressure Measurement":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    with ( ["Physical Exam, Not Performed": "Systolic blood pressure"]
      union ["Physical Exam, Not Performed": "Diastolic blood pressure"] ) NoBPScreen
      such that ( NoBPScreen.negationRationale in "Medical Reason"
          or NoBPScreen.negationRationale in "Patient Declined"
      )
        and NoBPScreen.authorDatetime same day as start of QualifyingEncounter.relevantPeriod

define "Encounter with Order for Hypertension Follow Up Declined by Patient":
  ( "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80" ElevatedBPEncounter
      with ( "NonPharmacological Intervention Not Ordered"
        union ["Intervention, Not Ordered": "Referral to Primary Care or Alternate Provider"]
        union ["Intervention, Not Ordered": "Follow-up 2-3 months (finding)"]
        union ["Intervention, Not Ordered": "Follow-up 4-6 months (finding)"] ) ElevatedBPDeclinedInterventions
        such that ElevatedBPDeclinedInterventions.negationRationale in "Patient Declined"
          and ElevatedBPDeclinedInterventions.authorDatetime same day as start of ElevatedBPEncounter.relevantPeriod
  )
    union ( "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80" FirstHTNEncounter
        with ( "NonPharmacological Intervention Not Ordered"
          union ["Intervention, Not Ordered": "Follow Up Within 4 Weeks"]
          union ["Intervention, Not Ordered": "Referral to Primary Care or Alternate Provider"] ) FirstHTNDeclinedInterventions
          such that FirstHTNDeclinedInterventions.negationRationale in "Patient Declined"
            and FirstHTNDeclinedInterventions.authorDatetime same day as start of FirstHTNEncounter.relevantPeriod
    )
    union ( "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89" SecondHTNEncounter
        with "Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 Interventions Declined" SecondHTNDeclinedInterventions
          such that SecondHTNDeclinedInterventions.authorDatetime same day as start of SecondHTNEncounter.relevantPeriod
    )
    union ( "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90" SecondHTN140Over90Encounter
        with "Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 Interventions Declined" SecondHTN140Over90DeclinedInterventions
          such that SecondHTN140Over90DeclinedInterventions.authorDatetime same day as start of SecondHTN140Over90Encounter.relevantPeriod
    )

define "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90":
  ( ( "Qualifying Encounter during Measurement Period" QualifyingEncounter
        let EncounterLastSystolicBP: Last(["Physical Exam, Performed": "Systolic blood pressure"] SystolicBP
            where Global."NormalizeInterval"(SystolicBP.relevantDatetime, SystolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
            sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
        ),
        EncounterLastDiastolicBP: Last(["Physical Exam, Performed": "Diastolic blood pressure"] DiastolicBP
            where Global."NormalizeInterval"(DiastolicBP.relevantDatetime, DiastolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
            sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
        )
        where EncounterLastSystolicBP.result > 0 'mm[Hg]'
          and EncounterLastDiastolicBP.result > 0 'mm[Hg]'
          and ( EncounterLastSystolicBP.result >= 140 'mm[Hg]'
              or EncounterLastDiastolicBP.result >= 90 'mm[Hg]'
          )
    )
      intersect "Encounter with Hypertensive Reading Within Year Prior"
  )

define "Follow up with Rescreen in 2 to 6 Months":
  ( ["Intervention, Order": "Follow-up 2-3 months (finding)"]
      union ["Intervention, Order": "Follow-up 4-6 months (finding)"]
  )

define "Initial Population":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    where AgeInYearsAt(date from start of "Measurement Period")>= 18

define "Laboratory Test or ECG for Hypertension":
  ( ["Diagnostic Study, Order": "EKG 12 channel panel"]
      union ["Diagnostic Study, Order": "EKG study"]
      union ["Laboratory Test, Order": "Laboratory Tests for Hypertension"]
  )

define "Laboratory Test or ECG for Hypertension Not Ordered":
  ( ["Diagnostic Study, Not Ordered": "EKG 12 channel panel"]
      union ["Diagnostic Study, Not Ordered": "EKG study"]
      union ["Laboratory Test, Not Ordered": "Laboratory Tests for Hypertension"]
  )

define "NonPharmacological Intervention Not Ordered":
  ( ["Intervention, Not Ordered": "Lifestyle Recommendation"]
      union ["Intervention, Not Ordered": "Weight Reduction Recommended"]
      union ["Intervention, Not Ordered": "Dietary Recommendations"]
      union ["Intervention, Not Ordered": "Recommendation to Increase Physical Activity"]
      union ["Intervention, Not Ordered": "Referral or Counseling for Alcohol Consumption"]
  )

define "NonPharmacological Interventions":
  ( ["Intervention, Order": "Lifestyle Recommendation"]
      union ["Intervention, Order": "Weight Reduction Recommended"]
      union ["Intervention, Order": "Dietary Recommendations"]
      union ["Intervention, Order": "Recommendation to Increase Physical Activity"]
      union ["Intervention, Order": "Referral or Counseling for Alcohol Consumption"]
  )

define "Numerator":
  "Encounter with Normal Blood Pressure Reading"
    union ( "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80 and Interventions" )
    union ( "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80 and Interventions" )
    union ( "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 and Interventions" )
    union ( "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 and Interventions" )

define "Qualifying Encounter during Measurement Period":
  ["Encounter, Performed": "Encounter to Screen for Blood Pressure"] ValidEncounter
    where ValidEncounter.relevantPeriod during "Measurement Period"
      and ValidEncounter.class !~ "virtual"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 Interventions Declined":
  ( ["Intervention, Not Ordered": "Referral to Primary Care or Alternate Provider"]
    union "Laboratory Test or ECG for Hypertension Not Ordered"
    union ["Intervention, Not Ordered": "Follow-up 2-3 months (finding)"]
    union ["Intervention, Not Ordered": "Follow-up 4-6 months (finding)"]
    union "NonPharmacological Intervention Not Ordered" ) SecondHTNDeclinedInterventions
    where SecondHTNDeclinedInterventions.negationRationale in "Patient Declined"

define "Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 Interventions Declined":
  ( ["Intervention, Not Ordered": "Referral to Primary Care or Alternate Provider"]
    union ["Medication, Not Ordered": "Pharmacologic Therapy for Hypertension"]
    union "Laboratory Test or ECG for Hypertension Not Ordered"
    union ["Intervention, Not Ordered": "Follow Up Within 4 Weeks"]
    union "NonPharmacological Intervention Not Ordered" ) SecondHTN140Over90InterventionsNotOrdered
    where SecondHTN140Over90InterventionsNotOrdered.negationRationale in "Patient Declined"

define "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80 and Interventions":
  ( "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80" ElevatedEncounter
      with "Follow up with Rescreen in 2 to 6 Months" Twoto6MonthRescreen
        such that Twoto6MonthRescreen.authorDatetime same day as start of ElevatedEncounter.relevantPeriod
      with "NonPharmacological Interventions" NonPharmInterventions
        such that NonPharmInterventions.authorDatetime same day as start of ElevatedEncounter.relevantPeriod
  )
    union ( "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80" ElevatedEncounter
        with "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading" Referral
          such that Referral.authorDatetime same day as start of ElevatedEncounter.relevantPeriod
    )

define "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80 and Interventions":
  "Encounter with First Hypertensive Reading SBP Greater than or Equal to 130 OR DBP Greater than or Equal to 80" FirstHTNEncounter
    with "First Hypertensive Reading Interventions or Referral to Alternate Professional" FirstHTNIntervention
      such that FirstHTNIntervention.authorDatetime same day as start of FirstHTNEncounter.relevantPeriod

define "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 and Interventions":
  ( "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89" SecondHTNEncounterReading
      with "Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 and Interventions" EncounterInterventions
        such that EncounterInterventions.authorDatetime same day as start of SecondHTNEncounterReading.relevantPeriod
  )
    union ( "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89" SecondHTNEncounterReading
        with "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading" ReferralForHTN
          such that ReferralForHTN.authorDatetime same day as start of SecondHTNEncounterReading.relevantPeriod
    )

define "Encounter with Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89":
  ( "Qualifying Encounter during Measurement Period" QualifyingEncounter
      let EncounterLastSystolicBP: Last(["Physical Exam, Performed": "Systolic blood pressure"] SystolicBP
          where Global."NormalizeInterval"(SystolicBP.relevantDatetime, SystolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
          sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
      ),
      EncounterLastDiastolicBP: Last(["Physical Exam, Performed": "Diastolic blood pressure"] DiastolicBP
          where Global."NormalizeInterval"(DiastolicBP.relevantDatetime, DiastolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
          sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
      )
      where ( EncounterLastSystolicBP.result in Interval[130 'mm[Hg]', 139 'mm[Hg]']
          or EncounterLastDiastolicBP.result in Interval[80 'mm[Hg]', 89 'mm[Hg]']
      )
        and not ( EncounterLastSystolicBP.result >= 140 'mm[Hg]'
            or EncounterLastDiastolicBP.result >= 90 'mm[Hg]'
        )
  )
    intersect "Encounter with Hypertensive Reading Within Year Prior"

define "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 and Interventions":
  ( "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90" SecondHTNEncounterReading140Over90
      with "Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 Interventions" SecondHTN140Over90Interventions
        such that SecondHTN140Over90Interventions.authorDatetime same day as start of SecondHTNEncounterReading140Over90.relevantPeriod
  )
    union "Encounter with Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90" SecondHTNEncounterReading140Over90
      with "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading" ReferralToProfessional
        such that ReferralToProfessional.authorDatetime same day as start of SecondHTNEncounterReading140Over90.relevantPeriod

define "First Hypertensive Reading Interventions or Referral to Alternate Professional":
  ( ["Intervention, Order": "Follow Up Within 4 Weeks"] FourWeekRescreen
      with "NonPharmacological Interventions" NonPharmInterventionsHTN
        such that FourWeekRescreen.authorDatetime same day as NonPharmInterventionsHTN.authorDatetime
  )
    union ( "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading" )

define "Referral to Alternate or Primary Healthcare Professional for Hypertensive Reading":
  ["Intervention, Order": "Referral to Primary Care or Alternate Provider"] Referral
    where Referral.reason in "Finding of Elevated Blood Pressure or Hypertension"

define "Second Hypertensive Reading SBP Greater than or Equal to 140 OR DBP Greater than or Equal to 90 Interventions":
  ( ( ( ["Intervention, Order": "Follow Up Within 4 Weeks"] WeeksRescreen
      with "Laboratory Test or ECG for Hypertension" ECGLabTest
        such that WeeksRescreen.authorDatetime same day as ECGLabTest.authorDatetime ) RescreenECGLab
      with "NonPharmacological Interventions" HTNInterventions
        such that HTNInterventions.authorDatetime same day as RescreenECGLab.authorDatetime ) RescreenECGLabInterventions
      with ["Medication, Order": "Pharmacologic Therapy for Hypertension"] Medications
        such that Medications.authorDatetime same day as RescreenECGLabInterventions.authorDatetime
  )

define "Second Hypertensive Reading SBP 130 to 139 OR DBP 80 to 89 and Interventions":
  ( "Follow up with Rescreen in 2 to 6 Months" Rescreen2to6
    with "Laboratory Test or ECG for Hypertension" LabECGIntervention
      such that Rescreen2to6.authorDatetime same day as LabECGIntervention.authorDatetime ) RescreenLabECG
    with "NonPharmacological Interventions" NonPharmSecondIntervention
      such that RescreenLabECG.authorDatetime same day as NonPharmSecondIntervention.authorDatetime

define "Encounter with Elevated Blood Pressure Reading SBP 120 to 129 AND DBP less than 80":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    let EncounterLastSystolicBP: Last(["Physical Exam, Performed": "Systolic blood pressure"] SystolicBP
        where Global."NormalizeInterval"(SystolicBP.relevantDatetime, SystolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    ),
    EncounterLastDiastolicBP: Last(["Physical Exam, Performed": "Diastolic blood pressure"] DiastolicBP
        where Global."NormalizeInterval"(DiastolicBP.relevantDatetime, DiastolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    )
    where ( EncounterLastSystolicBP.result included in Interval[120 'mm[Hg]', 129 'mm[Hg]']
        and EncounterLastDiastolicBP.result included in Interval[1 'mm[Hg]', 80 'mm[Hg]' )
    )

define "Encounter with Normal Blood Pressure Reading":
  "Qualifying Encounter during Measurement Period" QualifyingEncounter
    let EncounterLastSystolicBP: Last(["Physical Exam, Performed": "Systolic blood pressure"] SystolicBP
        where Global."NormalizeInterval"(SystolicBP.relevantDatetime, SystolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    ),
    EncounterLastDiastolicBP: Last(["Physical Exam, Performed": "Diastolic blood pressure"] DiastolicBP
        where Global."NormalizeInterval"(DiastolicBP.relevantDatetime, DiastolicBP.relevantPeriod)ends during QualifyingEncounter.relevantPeriod
        sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
    )
    where EncounterLastSystolicBP.result included in Interval[1 'mm[Hg]', 120 'mm[Hg]' )
      and EncounterLastDiastolicBP.result included in Interval[1 'mm[Hg]', 80 'mm[Hg]' )