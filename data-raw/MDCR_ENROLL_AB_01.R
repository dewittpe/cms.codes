# Total Medicare Enrollment:  Total, Original Medicare, and Medicare Advantage and Other Health Plan Enrollment
library(magrittr)

# Get a temporary directory to extract zip files to.
tmpdir <- tempdir()

# unzip the files
unzip("program_statistics/2013_enrollment/Total_Med_Enroll_XLSX.zip",      junkpaths = TRUE, exdir = paste0(tmpdir, "/2013"))
unzip("program_statistics/2014_enrollment/2014_Total_Med_Enroll_XLSX.zip", junkpaths = TRUE, exdir = paste0(tmpdir, "/2014"))
unzip("program_statistics/2015_enrollment/2015_Total_Med_Enroll_XLSX.zip", junkpaths = TRUE, exdir = paste0(tmpdir, "/2015"))
unzip("program_statistics/2016_enrollment/2016_Total_Med_Enroll_XLSX.zip", junkpaths = TRUE, exdir = paste0(tmpdir, "/2016"))
unzip("program_statistics/2017_enrollment/2017_Total_Med_Enroll_XLSX.zip", junkpaths = TRUE, exdir = paste0(tmpdir, "/2017"))

MDCR_ENROLL_AB_01 <-
  lapply(
         c(paste0(tmpdir, "/2013/CPS_MDCR_ENROLL_AB_1.xlsx"),
           paste0(tmpdir, "/2014/CPS_MDCR_ENROLL_AB_1.xlsx"),
           paste0(tmpdir, "/2015/CPS_MDCR_ENROLL_AB_1.xlsx"),
           paste0(tmpdir, "/2016/CPS_MDCR_ENROLL_AB_1.xlsx"),
           paste0(tmpdir, "/2017/CPS_MDCR_ENROLL_AB_1.xlsx"))
         ,
         readxl::read_excel,
         skip = 3)

MDCR_ENROLL_AB_01 <- dplyr::distinct(dplyr::bind_rows(MDCR_ENROLL_AB_01))

Filter(function(x) !all(is.na(x)), dplyr::filter(MDCR_ENROLL_AB_01, !grepl("20\\d\\d", Year)))

MDCR_ENROLL_AB_01 <- dplyr::filter(MDCR_ENROLL_AB_01,  grepl("20\\d\\d", Year))
MDCR_ENROLL_AB_01 <- dplyr::mutate(MDCR_ENROLL_AB_01,  Year = as.integer(Year))

lapply(MDCR_ENROLL_AB_01, tools::showNonASCII)

cat("# Auto Generated. Do not edit by hand",
    "#' Total Medicare Enrollment:  Total, Original Medicare, and Medicare Advantage and Other Health Plan Enrollment",
    "#'",
    "#' Total Medicare Enrollment:  Total, Original Medicare, and Medicare Advantage and Other Health Plan Enrollment",
    "#'",
    "#' NOTES:  The enrollment counts are determined using a person-year methodology.  Numbers and percentages may not add to totals because of rounding.",
    "#'",
    "#' @source  Centers for Medicare & Medicaid Services, Office of Enterprise Data and Analytics, CMS Chronic Conditions Data Warehouse.",
    "#'",
    "#'",
    "\"MDCR_ENROLL_AB_01\"",
    sep = "\n",
    file = "../R/MDCR_ENROLL_AB_01.R")
MDCR_ENROLL_AB_01 %<>% as.data.frame
save(MDCR_ENROLL_AB_01, file = "../data/MDCR_ENROLL_AB_01.rda")

