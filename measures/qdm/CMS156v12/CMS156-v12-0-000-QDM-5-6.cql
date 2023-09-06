library UseofHighRiskMedicationsintheElderly version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '5.0.000' called Hospice
include PalliativeCareExclusionECQM version '3.0.000' called PalliativeCare
include CumulativeMedicationDuration version '2.0.000' called CMD

codesystem "RXNORM": 'urn:oid:2.16.840.1.113883.6.88'
codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'

valueset "Alcohol Withdrawal": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1209'
valueset "Annual Wellness Visit": 'urn:oid:2.16.840.1.113883.3.526.3.1240'
valueset "Anti Infectives, other": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1481'
valueset "Anticholinergics, anti Parkinson agents": 'urn:oid:2.16.840.1.113883.3.464.1003.1049'
valueset "Anticholinergics, first generation antihistamines": 'urn:oid:2.16.840.1.113883.3.464.1003.1043'
valueset "Antipsychotic": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1523'
valueset "Antispasmodics": 'urn:oid:2.16.840.1.113883.3.464.1003.1050'
valueset "Antithrombotic": 'urn:oid:2.16.840.1.113883.3.464.1003.1051'
valueset "Benzodiazepine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1522'
valueset "Benzodiazepine Withdrawal": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1208'
valueset "Bipolar Disorder": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.128'
valueset "Cardiovascular, alpha agonists, central": 'urn:oid:2.16.840.1.113883.3.464.1003.1052'
valueset "Cardiovascular, other": 'urn:oid:2.16.840.1.113883.3.464.1003.1053'
valueset "Care Services in Long Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Central nervous system, antidepressants": 'urn:oid:2.16.840.1.113883.3.464.1003.1054'
valueset "Central nervous system, barbiturates": 'urn:oid:2.16.840.1.113883.3.464.1003.1055'
valueset "Central nervous system, other": 'urn:oid:2.16.840.1.113883.3.464.1003.1057'
valueset "Central nervous system, vasodilators": 'urn:oid:2.16.840.1.113883.3.464.1003.1056'
valueset "Digoxin": 'urn:oid:2.16.840.1.113883.3.464.1003.1065'
valueset "Discharge Services Nursing Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1013'
valueset "Doxepin": 'urn:oid:2.16.840.1.113883.3.464.1003.1067'
valueset "Endocrine system, estrogens with or without progestins": 'urn:oid:2.16.840.1.113883.3.464.1003.1058'
valueset "Endocrine system, other": 'urn:oid:2.16.840.1.113883.3.464.1003.1060'
valueset "Endocrine system, sulfonylureas, long duration": 'urn:oid:2.16.840.1.113883.3.464.1003.1059'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Generalized Anxiety Disorder": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1210'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Nonbenzodiazepine hypnotics": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1480'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Ophthalmological Services": 'urn:oid:2.16.840.1.113883.3.526.3.1285'
valueset "Pain medications, other": 'urn:oid:2.16.840.1.113883.3.464.1003.1063'
valueset "Pain medications, skeletal muscle relaxants": 'urn:oid:2.16.840.1.113883.3.464.1003.1062'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "REM Sleep Behavior Disorder": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1207'
valueset "Reserpine": 'urn:oid:2.16.840.1.113883.3.464.1003.1044'
valueset "Schizophrenia": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1205'
valueset "Seizure Disorder": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1206'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'

code "1 ML digoxin 0.1 MG/ML Injection": '204504' from "RXNORM" display '1 ML digoxin 0.1 MG/ML Injection'
code "2 ML digoxin 0.25 MG/ML Injection": '104208' from "RXNORM" display '2 ML digoxin 0.25 MG/ML Injection'
code "digoxin 0.05 MG/ML Oral Solution": '393245' from "RXNORM" display 'digoxin 0.05 MG/ML Oral Solution'
code "digoxin 0.0625 MG Oral Tablet": '245273' from "RXNORM" display 'digoxin 0.0625 MG Oral Tablet'
code "digoxin 0.125 MG Oral Tablet": '197604' from "RXNORM" display 'digoxin 0.125 MG Oral Tablet'
code "digoxin 0.1875 MG Oral Tablet": '1441565' from "RXNORM" display 'digoxin 0.1875 MG Oral Tablet'
code "digoxin 0.25 MG Oral Tablet": '197606' from "RXNORM" display 'digoxin 0.25 MG Oral Tablet'
code "doxepin 10 MG Oral Capsule": '1000048' from "RXNORM" display 'doxepin 10 MG Oral Capsule'
code "doxepin 10 MG/ML Oral Solution": '1000054' from "RXNORM" display 'doxepin 10 MG/ML Oral Solution'
code "doxepin 100 MG Oral Capsule": '1000058' from "RXNORM" display 'doxepin 100 MG Oral Capsule'
code "doxepin 150 MG Oral Capsule": '1000064' from "RXNORM" display 'doxepin 150 MG Oral Capsule'
code "doxepin 25 MG Oral Capsule": '1000070' from "RXNORM" display 'doxepin 25 MG Oral Capsule'
code "doxepin 3 MG Oral Tablet": '966787' from "RXNORM" display 'doxepin 3 MG Oral Tablet'
code "doxepin 50 MG Oral Capsule": '1000076' from "RXNORM" display 'doxepin 50 MG Oral Capsule'
code "doxepin 6 MG Oral Tablet": '966793' from "RXNORM" display 'doxepin 6 MG Oral Tablet'
code "doxepin 75 MG Oral Capsule": '1000097' from "RXNORM" display 'doxepin 75 MG Oral Capsule'
code "Office or other outpatient visit for the evaluation and management of an established patient that may not require the presence of a physician or other qualified health care professional": '99211' from "CPT" display 'Office or other outpatient visit for the evaluation and management of an established patient that may not require the presence of a physician or other qualified health care professional'
code "reserpine 0.1 MG Oral Tablet": '198196' from "RXNORM" display 'reserpine 0.1 MG Oral Tablet'
code "reserpine 0.25 MG Oral Tablet": '198197' from "RXNORM" display 'reserpine 0.25 MG Oral Tablet'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Antipsychotic Index Prescription Start Date":
  First(["Medication, Order": "Antipsychotic"] AntipsychoticMedication
      where AntipsychoticMedication.authorDatetime during "Measurement Period"
      return AntipsychoticMedication.authorDatetime
      sort asc
  )

define "Benzodiazepine Index Prescription Start Date":
  First(["Medication, Order": "Benzodiazepine"] BenzodiazepineMedication
      where BenzodiazepineMedication.authorDatetime during "Measurement Period"
      return BenzodiazepineMedication.authorDatetime
      sort asc
  )

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or PalliativeCare."Has Palliative Care in the Measurement Period"

define "High Risk Medications with Average Daily Dose Criteria":
  exists ( "More Than One Order"(["Medication, Order": "Reserpine"] ReserpineOrdered
        where "Average Daily Dose"(ReserpineOrdered)> 0.1 'mg/d'
    )
  )
    or exists ( "More Than One Order"(["Medication, Order": "Digoxin"] DigoxinOrdered
          where "Average Daily Dose"(DigoxinOrdered)> 0.125 'mg/d'
      )
    )
    or exists ( "More Than One Order"(["Medication, Order": "Doxepin"] DoxepinOrdered
          where "Average Daily Dose"(DoxepinOrdered)> 6 'mg/d'
      )
    )

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )>= 65
    and exists ( "Qualifying Encounters" )

define "More than One Antipsychotic Order":
  exists ( "More Than One Order"(["Medication, Order": "Antipsychotic"]))

define "More than One Benzodiazepine Order":
  exists ( "More Than One Order"(["Medication, Order": "Benzodiazepine"]))

define "Numerator 1":
  exists ( "Same High Risk Medications Ordered on Different Days" )
    or ( "Two High Risk Medications with Prolonged Duration" )
    or ( "High Risk Medications with Average Daily Dose Criteria" )

define "Numerator 2":
  ( "More than One Antipsychotic Order"
      and ( not exists ( ( ["Diagnosis": "Schizophrenia"]
            union ["Diagnosis": "Bipolar Disorder"] ) AntipsychoticTreatedDiagnoses
            where AntipsychoticTreatedDiagnoses.prevalencePeriod overlaps Interval[start of "Measurement Period" - 1 year, "Antipsychotic Index Prescription Start Date"]
        )
      )
  )
    or ( "More than One Benzodiazepine Order"
        and ( not exists ( ( ["Diagnosis": "Seizure Disorder"]
              union ["Diagnosis": "REM Sleep Behavior Disorder"]
              union ["Diagnosis": "Benzodiazepine Withdrawal"]
              union ["Diagnosis": "Alcohol Withdrawal"]
              union ["Diagnosis": "Generalized Anxiety Disorder"] ) BenzodiazepineTreatedDiagnoses
              where BenzodiazepineTreatedDiagnoses.prevalencePeriod overlaps Interval[start of "Measurement Period" - 1 year, "Benzodiazepine Index Prescription Start Date"]
          )
        )
    )

define "Numerator 3":
  "Numerator 2"
    or ( "Numerator 1"
        and not "Numerator 2"
    )

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Ophthalmological Services"]
    union ["Encounter, Performed": "Preventive Care Services Established Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Discharge Services Nursing Facility"]
    union ["Encounter, Performed": "Nursing Facility Visit"]
    union ["Encounter, Performed": "Care Services in Long Term Residential Facility"]
    union ["Encounter, Performed": "Preventive Care Services Initial Office Visit, 18 and Up"]
    union ["Encounter, Performed": "Annual Wellness Visit"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Telephone Visits"]
    union ["Encounter, Performed": "Online Assessments"]
    union ["Encounter, Performed": "Office or other outpatient visit for the evaluation and management of an established patient that may not require the presence of a physician or other qualified health care professional"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during "Measurement Period"

define "Same High Risk Medications Ordered on Different Days":
  "More Than One Order"(["Medication, Order": "Anticholinergics, first generation antihistamines"])
    union "More Than One Order"(["Medication, Order": "Anticholinergics, anti Parkinson agents"])
    union "More Than One Order"(["Medication, Order": "Antispasmodics"])
    union "More Than One Order"(["Medication, Order": "Antithrombotic"])
    union "More Than One Order"(["Medication, Order": "Cardiovascular, alpha agonists, central"])
    union "More Than One Order"(["Medication, Order": "Cardiovascular, other"])
    union "More Than One Order"(["Medication, Order": "Central nervous system, antidepressants"])
    union "More Than One Order"(["Medication, Order": "Central nervous system, barbiturates"])
    union "More Than One Order"(["Medication, Order": "Central nervous system, vasodilators"])
    union "More Than One Order"(["Medication, Order": "Central nervous system, other"])
    union "More Than One Order"(["Medication, Order": "Endocrine system, estrogens with or without progestins"])
    union "More Than One Order"(["Medication, Order": "Endocrine system, sulfonylureas, long duration"])
    union "More Than One Order"(["Medication, Order": "Endocrine system, other"])
    union "More Than One Order"(["Medication, Order": "Nonbenzodiazepine hypnotics"])
    union "More Than One Order"(["Medication, Order": "Pain medications, skeletal muscle relaxants"])
    union "More Than One Order"(["Medication, Order": "Pain medications, other"])

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Two High Risk Medications with Prolonged Duration":
  Sum(("More Than One Order"(["Medication, Order": "Anti Infectives, other"]))AntiInfectives
      let DaysSupply: Coalesce(AntiInfectives.daysSupplied, AntiInfectives.supply.value /(AntiInfectives.dosage.value * CMD.ToDaily(AntiInfectives.frequency)))*(1 + Coalesce(AntiInfectives.refills, 0))
      return all DaysSupply
  )> 90

define function "More Than One Order"(Medication List<"Medication, Order">):
  "Medication" OrderMedication1
    with "Medication" OrderMedication2
      such that ( OrderMedication1.authorDatetime during "Measurement Period"
          and OrderMedication1.refills >= 1
      )
        or ( date from OrderMedication1.authorDatetime !~ date from OrderMedication2.authorDatetime
            and OrderMedication1.authorDatetime during "Measurement Period"
            and OrderMedication2.authorDatetime during "Measurement Period"
        )
        or ( date from OrderMedication1.authorDatetime ~ date from OrderMedication2.authorDatetime
            and OrderMedication1.authorDatetime during "Measurement Period"
            and date from start of OrderMedication1.relevantPeriod !~ date from start of OrderMedication2.relevantPeriod
            and start of OrderMedication1.relevantPeriod during "Measurement Period"
            and start of OrderMedication2.relevantPeriod during "Measurement Period"
        )
    return OrderMedication1

define function "MedicationStrengthPerUnit"(Strength Code):
  case
    when Strength ~ "reserpine 0.1 MG Oral Tablet" then 0.1 'mg'
    when Strength ~ "reserpine 0.25 MG Oral Tablet" then 0.25 'mg'
    when Strength ~ "digoxin 0.05 MG/ML Oral Solution" then 0.05 'mg/mL'
    when Strength ~ "digoxin 0.0625 MG Oral Tablet" then 0.0625 'mg'
    when Strength ~ "1 ML digoxin 0.1 MG/ML Injection" then 0.1 'mg/mL'
    when Strength ~ "digoxin 0.125 MG Oral Tablet" then 0.125 'mg'
    when Strength ~ "digoxin 0.1875 MG Oral Tablet" then 0.1875 'mg'
    when Strength ~ "digoxin 0.25 MG Oral Tablet" then 0.25 'mg'
    when Strength ~ "2 ML digoxin 0.25 MG/ML Injection" then 0.25 'mg/mL'
    when Strength ~ "doxepin 3 MG Oral Tablet" then 3 'mg'
    when Strength ~ "doxepin 6 MG Oral Tablet" then 6 'mg'
    when Strength ~ "doxepin 10 MG Oral Capsule" then 10 'mg'
    when Strength ~ "doxepin 10 MG/ML Oral Solution" then 10 'mg/mL'
    when Strength ~ "doxepin 25 MG Oral Capsule" then 25 'mg'
    when Strength ~ "doxepin 50 MG Oral Capsule" then 50 'mg'
    when Strength ~ "doxepin 75 MG Oral Capsule" then 75 'mg'
    when Strength ~ "doxepin 100 MG Oral Capsule" then 100 'mg'
    when Strength ~ "doxepin 150 MG Oral Capsule" then 150 'mg' 
    else null 
  end

define function "Average Daily Dose"(MedicationOrder "Medication, Order"):
  MedicationOrder Order
    let MedicationStrength: "MedicationStrengthPerUnit"(Order.code),
    DaysSupplied: Coalesce(Order.daysSupplied, Order.supply.value /(Order.dosage.value * CMD.ToDaily(Order.frequency)))
    return if DaysSupplied is not null
      and ( MedicationStrength.unit = 'mg'
          or ( MedicationStrength.unit = 'mg/mL'
              and Order.supply.unit = 'mL'
          )
      ) then ( ( Order.supply * MedicationStrength ) / Quantity { value: DaysSupplied, unit: 'd' } ) 
      else null