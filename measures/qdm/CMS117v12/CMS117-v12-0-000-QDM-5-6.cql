library ChildhoodImmunizationStatus version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global
include Hospice version '5.0.000' called Hospice

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "ICD10PCS": 'urn:oid:2.16.840.1.113883.6.4'
codesystem "CPT": 'urn:oid:2.16.840.1.113883.6.12'
codesystem "CVX": 'urn:oid:2.16.840.1.113883.12.292'

valueset "Anaphylactic Reaction to DTaP Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1031'
valueset "Child Influenza Immunization Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1218'
valueset "Child Influenza Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1044'
valueset "Disorders of the Immune System": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1001'
valueset "DTaP Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1214'
valueset "DTaP Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1022'
valueset "Encephalitis Due to Diphtheria, Tetanus or Pertussis Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.1164'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hepatitis A": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1024'
valueset "Hepatitis A Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1215'
valueset "Hepatitis A Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1041'
valueset "Hepatitis B": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.269'
valueset "Hepatitis B Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1216'
valueset "Hepatitis B Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1042'
valueset "Hib Vaccine (3 dose schedule)": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1083'
valueset "Hib Vaccine (3 dose schedule) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1084'
valueset "Hib Vaccine (4 dose schedule)": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1085'
valueset "Hib Vaccine (4 dose schedule) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1086'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Home Healthcare Services": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Inactivated Polio Vaccine (IPV)": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1219'
valueset "Inactivated Polio Vaccine (IPV) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1045'
valueset "Influenza Virus LAIV Immunization": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1087'
valueset "Influenza Virus LAIV Procedure": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1088'
valueset "Intussusception": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1056'
valueset "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1009'
valueset "Measles": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1053'
valueset "Measles, Mumps and Rubella (MMR) Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1224'
valueset "Measles, Mumps and Rubella (MMR) Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1031'
valueset "Mumps": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1032'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Online Assessments": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pneumococcal Conjugate Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1221'
valueset "Pneumococcal Conjugate Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1046'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Rotavirus Vaccine (2 dose schedule) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1048'
valueset "Rotavirus Vaccine (3 dose schedule)": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1223'
valueset "Rotavirus Vaccine (3 dose schedule) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1047'
valueset "Rubella": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1037'
valueset "Severe Combined Immunodeficiency": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1007'
valueset "Telephone Visits": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "Varicella Zoster": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1039'
valueset "Varicella Zoster Vaccine (VZV)": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1170'
valueset "Varicella Zoster Vaccine (VZV) Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1040'

code "Anaphylaxis caused by rotavirus vaccine (disorder)": '428331000124103' from "SNOMEDCT" display 'Anaphylaxis caused by rotavirus vaccine (disorder)'
code "Anaphylaxis caused by vaccine containing Human alphaherpesvirus 3 antigen (disorder)": '471341000124104' from "SNOMEDCT" display 'Anaphylaxis caused by vaccine containing Human alphaherpesvirus 3 antigen (disorder)'
code "Anaphylaxis caused by vaccine product containing Hepatitis A virus antigen (disorder)": '471311000124103' from "SNOMEDCT" display 'Anaphylaxis caused by vaccine product containing Hepatitis A virus antigen (disorder)'
code "Anaphylaxis caused by vaccine product containing human poliovirus antigen (disorder)": '471321000124106' from "SNOMEDCT" display 'Anaphylaxis caused by vaccine product containing human poliovirus antigen (disorder)'
code "Anaphylaxis caused by vaccine product containing Influenza virus antigen (disorder)": '471361000124100' from "SNOMEDCT" display 'Anaphylaxis caused by vaccine product containing Influenza virus antigen (disorder)'
code "Anaphylaxis caused by vaccine product containing Measles morbillivirus and Mumps orthorubulavirus and Rubella virus antigens (disorder)": '471331000124109' from "SNOMEDCT" display 'Anaphylaxis caused by vaccine product containing Measles morbillivirus and Mumps orthorubulavirus and Rubella virus antigens (disorder)'
code "Anaphylaxis caused by vaccine product containing Streptococcus pneumoniae antigen (disorder)": '471141000124102' from "SNOMEDCT" display 'Anaphylaxis caused by vaccine product containing Streptococcus pneumoniae antigen (disorder)'
code "Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)": '433621000124101' from "SNOMEDCT" display 'Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)'
code "Anaphylaxis due to Hepatitis B vaccine (disorder)": '428321000124101' from "SNOMEDCT" display 'Anaphylaxis due to Hepatitis B vaccine (disorder)'
code "Introduction of Serum, Toxoid and Vaccine into Muscle, Percutaneous Approach": '3E0234Z' from "ICD10PCS" display 'Introduction of Serum, Toxoid and Vaccine into Muscle, Percutaneous Approach'
code "Office or other outpatient visit for the evaluation and management of an established patient that may not require the presence of a physician or other qualified health care professional": '99211' from "CPT" display 'Office or other outpatient visit for the evaluation and management of an established patient that may not require the presence of a physician or other qualified health care professional'
code "rotavirus, live, monovalent vaccine": '119' from "CVX" display 'rotavirus, live, monovalent vaccine'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "All Rotavirus Vaccinations":
  "Rotavirus 2 or 3 Dose Immunizations" AllRotavirusDoses1
    without "Rotavirus 2 or 3 Dose Immunizations" AllRotavirusDoses2
      such that Global."NormalizeInterval" ( AllRotavirusDoses1.relevantDatetime, AllRotavirusDoses1.relevantPeriod ) less than 1 day before Global."NormalizeInterval" ( AllRotavirusDoses2.relevantDatetime, AllRotavirusDoses2.relevantPeriod )

define "Date of Second Birthday":
  date from Patient.birthDatetime + 2 years

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or "Has Severe Combined Immunodeficiency"
    or "Has Immunodeficiency"
    or "Has HIV"
    or "Has Lymphoreticular Cancer, Multiple Myeloma or Leukemia"
    or "Has Intussusception"

define "Four DTaP Vaccinations":
  from
    "DTaP Immunizations or Procedures" DTaPVaccination1,
    "DTaP Immunizations or Procedures" DTaPVaccination2,
    "DTaP Immunizations or Procedures" DTaPVaccination3,
    "DTaP Immunizations or Procedures" DTaPVaccination4
    where Global."NormalizeInterval" ( DTaPVaccination2.relevantDatetime, DTaPVaccination2.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( DTaPVaccination1.relevantDatetime, DTaPVaccination1.relevantPeriod )
      and Global."NormalizeInterval" ( DTaPVaccination3.relevantDatetime, DTaPVaccination3.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( DTaPVaccination2.relevantDatetime, DTaPVaccination2.relevantPeriod )
      and Global."NormalizeInterval" ( DTaPVaccination4.relevantDatetime, DTaPVaccination4.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( DTaPVaccination3.relevantDatetime, DTaPVaccination3.relevantPeriod )
    return DTaPVaccination1

define "Four Pneumococcal Conjugate Vaccinations":
  from
    "Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination1,
    "Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination2,
    "Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination3,
    "Pneumococcal Conjugate Immunizations or Procedures" PneumococcalVaccination4
    where Global."NormalizeInterval" ( PneumococcalVaccination2.relevantDatetime, PneumococcalVaccination2.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( PneumococcalVaccination1.relevantDatetime, PneumococcalVaccination1.relevantPeriod )
      and Global."NormalizeInterval" ( PneumococcalVaccination3.relevantDatetime, PneumococcalVaccination3.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( PneumococcalVaccination2.relevantDatetime, PneumococcalVaccination2.relevantPeriod )
      and Global."NormalizeInterval" ( PneumococcalVaccination4.relevantDatetime, PneumococcalVaccination4.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( PneumococcalVaccination3.relevantDatetime, PneumococcalVaccination3.relevantPeriod )
    return PneumococcalVaccination1

define "Has Appropriate Number of Hib Immunizations":
  exists ( "All Hib Vaccinations" HibImmunization //union of 3 and 4 dose immunizations
  //4 dose test
      let HasFourDose: Count("Hib 4 Dose Immunizations or Procedures")> 0
      where ( HasFourDose //if pt had at least one 4 dose code
          and Count(distinct("All Hib Vaccinations" HibVaccinations
                return Global."NormalizeInterval"(HibVaccinations.relevantDatetime, HibVaccinations.relevantPeriod)
            )
          )>= 4 //pt must have 4 regimens (e.g., 3,3,4,4 or 4,3,4,4)
      )
        or ( HasFourDose is false //if pt did not have at least one 4 dose code
            and Count(distinct("All Hib Vaccinations" HibVaccinations
                  return Global."NormalizeInterval"(HibVaccinations.relevantDatetime, HibVaccinations.relevantPeriod)
              )
            )>= 3 //pt must have 3 regimens of 3 dose codes
        )
  )

define "Has Appropriate Number of Rotavirus Immunizations":
  exists ( "All Rotavirus Vaccinations" RotavirusImmunization
      let HasThreeDose: Count("Rotavirus 3 Dose Immunizations or Procedures")> 0
      where ( HasThreeDose
          and Count(distinct("All Rotavirus Vaccinations" RotavirusVaccinations
                return Global."NormalizeInterval"(RotavirusVaccinations.relevantDatetime, RotavirusVaccinations.relevantPeriod)
            )
          )>= 3
      )
        or ( HasThreeDose is false
            and Count(distinct("All Rotavirus Vaccinations" RotavirusVaccinations
                  return Global."NormalizeInterval"(RotavirusVaccinations.relevantDatetime, RotavirusVaccinations.relevantPeriod)
              )
            )>= 2
        )
  )

define "Hepatitis B Numerator Inclusion Conditions":
  ( ["Diagnosis": "Anaphylaxis due to Hepatitis B vaccine (disorder)"]
    union ["Diagnosis": "Hepatitis B"] ) HepBConditions
    where date from start of HepBConditions.prevalencePeriod during day of "First Two Years"

define "Hib 3 Dose Immunizations or Procedures":
  ( ( ["Immunization, Administered": "Hib Vaccine (3 dose schedule)"]
      union ["Procedure, Performed": "Hib Vaccine (3 dose schedule) Administered"] ) ThreeDoseHib
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( ThreeDoseHib.relevantDatetime, ThreeDoseHib.relevantPeriod ) ) during day of "Vaccine Administration Interval - 42 Days up to 2 Years Old"
  )

define "Hib 3 or 4 Dose Immunizations":
  "Hib 3 Dose Immunizations or Procedures"
    union "Hib 4 Dose Immunizations or Procedures"

define "Hib 4 Dose Immunizations or Procedures":
  ( ( ["Immunization, Administered": "Hib Vaccine (4 dose schedule)"]
      union ["Procedure, Performed": "Hib Vaccine (4 dose schedule) Administered"] ) FourDoseHib
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( FourDoseHib.relevantDatetime, FourDoseHib.relevantPeriod ) ) during day of "Vaccine Administration Interval - 42 Days up to 2 Years Old"
  )

define "Hib Numerator Inclusion Conditions":
  ["Diagnosis": "Anaphylaxis due to Haemophilus influenzae type b vaccine (disorder)"] HibReaction
    where date from start of HibReaction.prevalencePeriod during day of "First Two Years"

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  )= 2
    and exists ( "Qualifying Encounters" )

define "Measles Indicators":
  ["Diagnosis": "Measles"] MeaslesDiagnosis
    where date from start of MeaslesDiagnosis.prevalencePeriod during day of "First Two Years"

define "Mumps Indicators":
  ["Diagnosis": "Mumps"] MumpsDiagnosis
    where date from start of MumpsDiagnosis.prevalencePeriod during day of "First Two Years"

define "Polio Immunizations or Procedures":
  ( ( ["Immunization, Administered": "Inactivated Polio Vaccine (IPV)"]
      union ["Procedure, Performed": "Inactivated Polio Vaccine (IPV) Administered"] ) PolioVaccination
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( PolioVaccination.relevantDatetime, PolioVaccination.relevantPeriod ) ) during day of "Vaccine Administration Interval - 42 Days up to 2 Years Old"
  )

define "Rotavirus 2 or 3 Dose Immunizations":
  "Rotavirus 2 Dose Immunizations or Procedures"
    union "Rotavirus 3 Dose Immunizations or Procedures"

define "SDE Ethnicity":
  ["Patient Characteristic Ethnicity": "Ethnicity"]

define "SDE Payer":
  ["Patient Characteristic Payer": "Payer"]

define "SDE Race":
  ["Patient Characteristic Race": "Race"]

define "SDE Sex":
  ["Patient Characteristic Sex": "ONC Administrative Sex"]

define "Three Polio Vaccinations":
  from
    "Polio Immunizations or Procedures" PolioVaccination1,
    "Polio Immunizations or Procedures" PolioVaccination2,
    "Polio Immunizations or Procedures" PolioVaccination3
    where Global."NormalizeInterval" ( PolioVaccination2.relevantDatetime, PolioVaccination2.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( PolioVaccination1.relevantDatetime, PolioVaccination1.relevantPeriod )
      and Global."NormalizeInterval" ( PolioVaccination3.relevantDatetime, PolioVaccination3.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( PolioVaccination2.relevantDatetime, PolioVaccination2.relevantPeriod )
    return PolioVaccination1

define "Two Influenza Vaccinations":
  from
    "Influenza Immunizations or Procedures" FluVaccination1,
    "Influenza Immunizations or Procedures" FluVaccination2
    where Global."NormalizeInterval" ( FluVaccination2.relevantDatetime, FluVaccination2.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( FluVaccination1.relevantDatetime, FluVaccination1.relevantPeriod )
    return FluVaccination1

define "Two Influenza Vaccinations Including One LAIV Vaccination":
  exists "LAIV Vaccinations"
    and exists "Influenza Immunizations or Procedures"

define "Date of First Birthday":
  date from Patient.birthDatetime + 1 year

define "One MMR Vaccination":
  ( ( ["Immunization, Administered": "Measles, Mumps and Rubella (MMR) Vaccine"]
      union ["Procedure, Performed": "Measles, Mumps and Rubella (MMR) Vaccine Administered"] ) MMRVaccination
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( MMRVaccination.relevantDatetime, MMRVaccination.relevantPeriod ) ) during "Date of First Birthday to Date of Second Birthday"
  )

define "One Chicken Pox Vaccination":
  ( ( ["Immunization, Administered": "Varicella Zoster Vaccine (VZV)"]
      union ["Procedure, Performed": "Varicella Zoster Vaccine (VZV) Administered"] ) ChickenPoxVaccination
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( ChickenPoxVaccination.relevantDatetime, ChickenPoxVaccination.relevantPeriod ) ) during "Date of First Birthday to Date of Second Birthday"
  )

define "One Hepatitis A Vaccinations":
  ( ( ["Immunization, Administered": "Hepatitis A Vaccine"]
      union ["Procedure, Performed": "Hepatitis A Vaccine Administered"] ) HepatitisAVaccination
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( HepatitisAVaccination.relevantDatetime, HepatitisAVaccination.relevantPeriod ) ) during "Date of First Birthday to Date of Second Birthday"
  )

define "Has HIV":
  exists ( ["Diagnosis": "HIV"] HIV
      where date from start of HIV.prevalencePeriod during day of "First Two Years"
  )

define "Has Intussusception":
  exists ( ["Diagnosis": "Intussusception"] IntussusceptionDisorder
      where date from start of IntussusceptionDisorder.prevalencePeriod during day of "First Two Years"
  )

define "Has Immunodeficiency":
  exists ( ["Diagnosis": "Disorders of the Immune System"] ImmuneDisorder
      where date from start of ImmuneDisorder.prevalencePeriod during day of "First Two Years"
  )

define "Has Lymphoreticular Cancer, Multiple Myeloma or Leukemia":
  exists ( ["Diagnosis": "Malignant Neoplasm of Lymphatic and Hematopoietic Tissue"] LymphaticMalignantNeoplasm
      where date from start of LymphaticMalignantNeoplasm.prevalencePeriod during day of "First Two Years"
  )

define "Has Severe Combined Immunodeficiency":
  exists ( ["Diagnosis": "Severe Combined Immunodeficiency"] SevereImmuneDisorder
      where date from start of SevereImmuneDisorder.prevalencePeriod during day of "First Two Years"
  )

define "Date of First Birthday to Date of Second Birthday":
  Interval["Date of First Birthday", "Date of Second Birthday"]

define "LAIV Vaccinations":
  ( ( ["Immunization, Administered": "Influenza Virus LAIV Immunization"]
      union ["Procedure, Performed": "Influenza Virus LAIV Procedure"] ) InfluenzaAdministration
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( InfluenzaAdministration.relevantDatetime, InfluenzaAdministration.relevantPeriod ) ) during day of Interval["Date of Second Birthday", "Date of Second Birthday"]
  )

define "Rubella Indicators":
  ["Diagnosis": "Rubella"] RubellaDiagnosis
    where date from start of RubellaDiagnosis.prevalencePeriod during day of "First Two Years"

define "Rotavirus Numerator Inclusion Conditions":
  ( ["Diagnosis": "Anaphylaxis caused by rotavirus vaccine (disorder)"] RotavirusConditions
      where date from start of RotavirusConditions.prevalencePeriod during day of "First Two Years"
  )

define "Vaccine Administration Interval - 42 Days up to 2 Years Old":
  Interval[date from Patient.birthDatetime + 42 days, "Date of Second Birthday"]

define "Vaccine Administration Interval - 180 Days up to 2 Years Old":
  Interval[date from Patient.birthDatetime + 180 days, "Date of Second Birthday"]

define "Rotavirus 3 Dose Immunizations or Procedures":
  ( ( ["Immunization, Administered": "Rotavirus Vaccine (3 dose schedule)"]
      union ["Procedure, Performed": "Rotavirus Vaccine (3 dose schedule) Administered"] ) ThreeDoseRotavirus
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( ThreeDoseRotavirus.relevantDatetime, ThreeDoseRotavirus.relevantPeriod ) ) during day of "Vaccine Administration Interval - 42 Days up to 2 Years Old"
  )

define "First Two Years":
  Interval[date from Patient.birthDatetime, "Date of Second Birthday"]

define "DTaP Numerator Inclusion Conditions":
  ( ["Diagnosis": "Anaphylactic Reaction to DTaP Vaccine"]
    union ["Diagnosis": "Encephalitis Due to Diphtheria, Tetanus or Pertussis Vaccine"] ) DTaPConditions
    where date from start of DTaPConditions.prevalencePeriod during day of "First Two Years"

define "DTaP Immunizations or Procedures":
  ( ( ["Immunization, Administered": "DTaP Vaccine"]
      union ["Procedure, Performed": "DTaP Vaccine Administered"] ) DTaPVaccination
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( DTaPVaccination.relevantDatetime, DTaPVaccination.relevantPeriod ) ) during day of "Vaccine Administration Interval - 42 Days up to 2 Years Old"
  )

define "All Hib Vaccinations":
  "Hib 3 or 4 Dose Immunizations" AllHibDoses1
    without "Hib 3 or 4 Dose Immunizations" AllHibDoses2
      such that Global."NormalizeInterval" ( AllHibDoses1.relevantDatetime, AllHibDoses1.relevantPeriod ) less than 1 day before Global."NormalizeInterval" ( AllHibDoses2.relevantDatetime, AllHibDoses2.relevantPeriod )

define "Hepatitis B Immunizations or Procedures":
  ( ( ["Immunization, Administered": "Hepatitis B Vaccine"]
      union ["Procedure, Performed": "Hepatitis B Vaccine Administered"] ) HepatitisBVaccination
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( HepatitisBVaccination.relevantDatetime, HepatitisBVaccination.relevantPeriod ) ) during day of "First Two Years"
  )

define "Polio Numerator Inclusion Conditions":
  ["Diagnosis": "Anaphylaxis caused by vaccine product containing human poliovirus antigen (disorder)"] PolioConditions
    where date from start of PolioConditions.prevalencePeriod during day of "First Two Years"

define "Varicella Zoster Numerator Inclusion Conditions":
  ( ["Diagnosis": "Varicella Zoster"]
    union ["Diagnosis": "Anaphylaxis caused by vaccine containing Human alphaherpesvirus 3 antigen (disorder)"] ) VaricellaZoster
    where date from start of VaricellaZoster.prevalencePeriod during day of "First Two Years"

define "Pneumococcal Conjugate Immunizations or Procedures":
  ( ( ["Immunization, Administered": "Pneumococcal Conjugate Vaccine"]
      union ["Procedure, Performed": "Pneumococcal Conjugate Vaccine Administered"] ) PneumococcalVaccination
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( PneumococcalVaccination.relevantDatetime, PneumococcalVaccination.relevantPeriod ) ) during day of "Vaccine Administration Interval - 42 Days up to 2 Years Old"
  )

define "Pneumococcal Conjugate Numerator Inclusion Conditions":
  ["Diagnosis": "Anaphylaxis caused by vaccine product containing Streptococcus pneumoniae antigen (disorder)"] PneumococcalReaction
    where date from start of PneumococcalReaction.prevalencePeriod during day of "First Two Years"

define "MMR Numerator Inclusion Conditions":
  ["Diagnosis": "Anaphylaxis caused by vaccine product containing Measles morbillivirus and Mumps orthorubulavirus and Rubella virus antigens (disorder)"] MMRConditions
    where date from start of MMRConditions.prevalencePeriod during day of "First Two Years"

define "Hepatitis A Numerator Inclusion Conditions":
  ( ["Diagnosis": "Hepatitis A"]
    union ["Diagnosis": "Anaphylaxis caused by vaccine product containing Hepatitis A virus antigen (disorder)"] ) HepatitisADiagnosis
    where date from start of HepatitisADiagnosis.prevalencePeriod during day of "First Two Years"

define "Numerator":
  ( exists ( "Four DTaP Vaccinations" )
      or exists ( "DTaP Numerator Inclusion Conditions" )
  )
    and ( exists ( "Three Polio Vaccinations" )
        or exists ( "Polio Numerator Inclusion Conditions" )
    )
    and ( exists ( "One MMR Vaccination" )
        or exists ( "MMR Numerator Inclusion Conditions" )
        or ( exists ( "Measles Indicators" )
            and exists ( "Mumps Indicators" )
            and exists ( "Rubella Indicators" )
        )
    )
    and ( "Has Appropriate Number of Hib Immunizations"
        or exists ( "Hib Numerator Inclusion Conditions" )
    )
    and ( exists ( "Three Hepatitis B Vaccinations" )
        or ( exists ( "Meets HepB Vaccination Requirement" )
            or exists ( "Hepatitis B Numerator Inclusion Conditions" )
        )
    )
    and ( exists ( "One Chicken Pox Vaccination" )
        or exists ( "Varicella Zoster Numerator Inclusion Conditions" )
    )
    and ( exists ( "Four Pneumococcal Conjugate Vaccinations" )
        or exists ( "Pneumococcal Conjugate Numerator Inclusion Conditions" )
    )
    and ( exists ( "One Hepatitis A Vaccinations" )
        or exists ( "Hepatitis A Numerator Inclusion Conditions" )
    )
    and ( "Has Appropriate Number of Rotavirus Immunizations"
        or exists ( "Rotavirus Numerator Inclusion Conditions" )
    )
    and ( exists ( "Two Influenza Vaccinations" )
        or ( "Two Influenza Vaccinations Including One LAIV Vaccination" )
        or exists ( "Influenza Numerator Inclusion Conditions" )
    )

define "Influenza Numerator Inclusion Conditions":
  ["Diagnosis": "Anaphylaxis caused by vaccine product containing Influenza virus antigen (disorder)"] InfluenzaConditions
    where date from start of InfluenzaConditions.prevalencePeriod during day of "First Two Years"

define "Qualifying Encounters":
  ( ["Encounter, Performed": "Office Visit"]
    union ["Encounter, Performed": "Home Healthcare Services"]
    union ["Encounter, Performed": "Preventive Care, Established Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Preventive Care Services, Initial Office Visit, 0 to 17"]
    union ["Encounter, Performed": "Office or other outpatient visit for the evaluation and management of an established patient that may not require the presence of a physician or other qualified health care professional"]
    union ["Encounter, Performed": "Online Assessments"]
    union ["Encounter, Performed": "Telephone Visits"] ) ValidEncounters
    where ValidEncounters.relevantPeriod during day of "Measurement Period"

define "Meets HepB Vaccination Requirement":
  from
    "Hepatitis B Immunizations or Procedures" HepatitisBVaccination1,
    "Hepatitis B Immunizations or Procedures" HepatitisBVaccination2,
    "NewBorn Vaccine Requirement" NewBornVaccine3
    where Global."NormalizeInterval" ( HepatitisBVaccination2.relevantDatetime, HepatitisBVaccination2.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( HepatitisBVaccination1.relevantDatetime, HepatitisBVaccination1.relevantPeriod )
      and Global."NormalizeInterval" ( HepatitisBVaccination1.relevantDatetime, HepatitisBVaccination1.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( NewBornVaccine3.relevantDatetime, NewBornVaccine3.relevantPeriod )
      and Global."NormalizeInterval" ( HepatitisBVaccination2.relevantDatetime, HepatitisBVaccination2.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( NewBornVaccine3.relevantDatetime, NewBornVaccine3.relevantPeriod )
    return HepatitisBVaccination1

define "Three Hepatitis B Vaccinations":
  from
    "Hepatitis B Immunizations or Procedures" HepatitisBVaccination1,
    "Hepatitis B Immunizations or Procedures" HepatitisBVaccination2,
    "Hepatitis B Immunizations or Procedures" HepatitisBVaccination3
    where Global."NormalizeInterval" ( HepatitisBVaccination2.relevantDatetime, HepatitisBVaccination2.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( HepatitisBVaccination1.relevantDatetime, HepatitisBVaccination1.relevantPeriod )
      and Global."NormalizeInterval" ( HepatitisBVaccination3.relevantDatetime, HepatitisBVaccination3.relevantPeriod ) 1 day or more after day of Global."NormalizeInterval" ( HepatitisBVaccination2.relevantDatetime, HepatitisBVaccination2.relevantPeriod )
    return HepatitisBVaccination1

define "NewBorn Vaccine Requirement":
  ["Procedure, Performed": "Introduction of Serum, Toxoid and Vaccine into Muscle, Percutaneous Approach"] NewBornVaccine
    where Global."ToDateInterval" ( Global."NormalizeInterval" ( NewBornVaccine.relevantDatetime, NewBornVaccine.relevantPeriod ) ) during day of Interval[date from Patient.birthDatetime, date from Patient.birthDatetime + 7 days]

define "Influenza Immunizations or Procedures":
  ( ( ["Immunization, Administered": "Child Influenza Immunization Administered"]
      union ["Procedure, Performed": "Child Influenza Vaccine Administered"] ) InfluenzaAdministration
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( InfluenzaAdministration.relevantDatetime, InfluenzaAdministration.relevantPeriod ) ) during day of "Vaccine Administration Interval - 180 Days up to 2 Years Old"
  )

define "Rotavirus 2 Dose Immunizations or Procedures":
  ( ( ["Immunization, Administered": "rotavirus, live, monovalent vaccine"]
      union ["Procedure, Performed": "Rotavirus Vaccine (2 dose schedule) Administered"] ) TwoDoseRotavirus
      where Global."ToDateInterval" ( Global."NormalizeInterval" ( TwoDoseRotavirus.relevantDatetime, TwoDoseRotavirus.relevantPeriod ) ) during day of "Vaccine Administration Interval - 42 Days up to 2 Years Old"
  )