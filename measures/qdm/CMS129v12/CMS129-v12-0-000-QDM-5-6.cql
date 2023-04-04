library ProstateCaAvoidanceBoneScanOveruse version '12.0.000'

using QDM version '5.6'

include MATGlobalCommonFunctions version '7.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Bone Scan": 'urn:oid:2.16.840.1.113883.3.526.3.320'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Pain Related to Prostate Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.451'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Prostate Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.319'
valueset "Prostate Cancer Treatment": 'urn:oid:2.16.840.1.113883.3.526.3.398'
valueset "Prostate Specific Antigen Test": 'urn:oid:2.16.840.1.113883.3.526.3.401'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Salvage Therapy": 'urn:oid:2.16.840.1.113883.3.526.3.399'

code "Gleason score in Specimen Qualitative": '35266-6' from "LOINC" display 'Gleason score in Specimen Qualitative'
code "Neoplasm of prostate primary tumor staging category T1c: Tumor identified by needle biopsy (finding)": '433351000124101' from "SNOMEDCT" display 'Neoplasm of prostate primary tumor staging category T1c: Tumor identified by needle biopsy (finding)'
code "Neoplasm of prostate primary tumor staging category T2a: Involves one-half of one lobe or less (finding)": '433361000124104' from "SNOMEDCT" display 'Neoplasm of prostate primary tumor staging category T2a: Involves one-half of one lobe or less (finding)'
code "Procedure reason record (record artifact)": '433611000124109' from "SNOMEDCT" display 'Procedure reason record (record artifact)'
code "T1a: Prostate tumor incidental histologic finding in 5% or less of tissue resected (finding)": '369833007' from "SNOMEDCT" display 'T1a: Prostate tumor incidental histologic finding in 5% or less of tissue resected (finding)'
code "T1b: Prostate tumor incidental histologic finding in > 5% of tissue resected (finding)": '369834001' from "SNOMEDCT" display 'T1b: Prostate tumor incidental histologic finding in > 5% of tissue resected (finding)'
code "Tumor staging (tumor staging)": '254292007' from "SNOMEDCT" display 'Tumor staging (tumor staging)'

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

define "Prostate Cancer Diagnosis":
  ["Diagnosis": "Prostate Cancer"] ProstateCancer
    where ProstateCancer.prevalencePeriod overlaps "Measurement Period"

define "First Prostate Cancer Treatment During Measurement Period":
  First(["Procedure, Performed": "Prostate Cancer Treatment"] ProstateCancerTreatment
      where Global."NormalizeInterval"(ProstateCancerTreatment.relevantDatetime, ProstateCancerTreatment.relevantPeriod)ends during "Measurement Period"
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )

define "Denominator":
  "Initial Population"
    and "First Prostate Cancer Treatment During Measurement Period" is not null
    and "Most Recent Prostate Cancer Staging Tumor Size T1a to T2a" is not null
    and "Most Recent PSA Test Result is Low"
    and "Most Recent Gleason Score is Low"

define "Bone Scan Study Performed":
  ["Diagnostic Study, Performed": "Bone Scan"] BoneScan
    with "Prostate Cancer Diagnosis" ActiveProstateCancer
      such that Global."NormalizeInterval" ( BoneScan.relevantDatetime, BoneScan.relevantPeriod ) starts after start of ActiveProstateCancer.prevalencePeriod

define "Numerator":
  not exists "Bone Scan Study Performed"

define "Initial Population":
  exists "Prostate Cancer Diagnosis"

define "Most Recent Gleason Score is Low":
  ( Last(["Laboratory Test, Performed": "Gleason score in Specimen Qualitative"] GleasonScore
      with "First Prostate Cancer Treatment During Measurement Period" FirstProstateCancerTreatment
        such that Global."NormalizeInterval"(GleasonScore.relevantDatetime, GleasonScore.relevantPeriod)starts before start of Global."NormalizeInterval"(FirstProstateCancerTreatment.relevantDatetime, FirstProstateCancerTreatment.relevantPeriod)
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )) LastGleasonScore
    return LastGleasonScore.result <= 6

define "Most Recent PSA Test Result is Low":
  ( Last(["Laboratory Test, Performed": "Prostate Specific Antigen Test"] PSATest
      with "Most Recent Prostate Cancer Staging Tumor Size T1a to T2a" MostRecentProstateCancerStaging
        such that Global."NormalizeInterval"(PSATest.relevantDatetime, PSATest.relevantPeriod)starts before Global."NormalizeInterval"(MostRecentProstateCancerStaging.relevantDatetime, MostRecentProstateCancerStaging.relevantPeriod)
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )) LastPSATest
    return LastPSATest.result < 10 'ng/mL'

define "Has Diagnosis of Pain Related to Prostate Cancer":
  exists ["Diagnosis": "Pain Related to Prostate Cancer"] ProstateCancerPain
    with "Prostate Cancer Diagnosis" ActiveProstateCancer
      such that ProstateCancerPain.prevalencePeriod starts after start of ActiveProstateCancer.prevalencePeriod

define "Has Salvage Therapy Performed After Prostate Cancer Diagnosis":
  exists ["Procedure, Performed": "Salvage Therapy"] SalvageTherapy
    with "Prostate Cancer Diagnosis" ActiveProstateCancer
      such that Global."NormalizeInterval" ( SalvageTherapy.relevantDatetime, SalvageTherapy.relevantPeriod ) starts after start of ActiveProstateCancer.prevalencePeriod

define "Has Bone Scan Study Performed with Documented Reason":
  exists "Bone Scan Study Performed" BoneScanAfterDiagnosis
    where BoneScanAfterDiagnosis.reason ~ "Procedure reason record (record artifact)"

define "Denominator Exceptions":
  "Has Diagnosis of Pain Related to Prostate Cancer"
    or "Has Salvage Therapy Performed After Prostate Cancer Diagnosis"
    or "Has Bone Scan Study Performed with Documented Reason"

define "Most Recent Prostate Cancer Staging Tumor Size T1a to T2a":
  ( Last(["Procedure, Performed": "Tumor staging (tumor staging)"] ProstateCancerStaging
      with "First Prostate Cancer Treatment During Measurement Period" FirstProstateCancerTreatment
        such that Global."NormalizeInterval"(ProstateCancerStaging.relevantDatetime, ProstateCancerStaging.relevantPeriod)starts before start of Global."NormalizeInterval"(FirstProstateCancerTreatment.relevantDatetime, FirstProstateCancerTreatment.relevantPeriod)
      sort by start of Global."NormalizeInterval"(relevantDatetime, relevantPeriod)
  )) LastProstateCancerStaging
    where ( LastProstateCancerStaging.result ~ "T1a: Prostate tumor incidental histologic finding in 5% or less of tissue resected (finding)"
        or LastProstateCancerStaging.result ~ "T1b: Prostate tumor incidental histologic finding in > 5% of tissue resected (finding)"
        or LastProstateCancerStaging.result ~ "Neoplasm of prostate primary tumor staging category T1c: Tumor identified by needle biopsy (finding)"
        or LastProstateCancerStaging.result ~ "Neoplasm of prostate primary tumor staging category T2a: Involves one-half of one lobe or less (finding)"
    )