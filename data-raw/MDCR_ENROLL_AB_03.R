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

MDCR_ENROLL_AB_03 <-
  lapply(
         c(paste0(tmpdir, "/2013/CPS_MDCR_ENROLL_AB_3.xlsx"),
           paste0(tmpdir, "/2014/CPS_MDCR_ENROLL_AB_3.xlsx"),
           paste0(tmpdir, "/2015/CPS_MDCR_ENROLL_AB_3.xlsx"),
           paste0(tmpdir, "/2016/CPS_MDCR_ENROLL_AB_3.xlsx"),
           paste0(tmpdir, "/2017/CPS_MDCR_ENROLL_AB_3.xlsx"))
         ,
         readxl::read_excel,
         skip = 2)

MDCR_ENROLL_AB_03 %<>%
  dplyr::bind_rows(.) %>%
  dplyr::distinct(.) %>%
  dplyr::filter(Year %in% as.character(2008:2017)) %>%
  dplyr::mutate(Year = as.integer(Year))

cat("# Auto Generated. Do not edit by hand",
    "#' Total Medicare Enrollment:  Part A and/or Part B Total, Aged, and Disabled Enrollees",
    "#'",
    "#' Total Medicare Enrollment:  Part A and/or Part B Total, Aged, and Disabled Enrollees",
    "#'",
    "#' NOTES:  The enrollment counts are determined  using a person-year methodology.  Numbers and percentages may not add to totals because of",
    "#' rounding.  For definitions of \"Metropolitan\", \"Micropolitan\", and \"Non-Core-Based Statistical Area\", refer to CPS Glossary.",
    "#'",
    "#' @source Centers for Medicare & Medicaid Services, Office of Enterprise Data and Analytics, Chronic Conditions Data Warehouse; United States Census Bureau.",
    "#'",
    "\"MDCR_ENROLL_AB_03\"",
    sep = "\n",
    file = "../R/MDCR_ENROLL_AB_03.R")

MDCR_ENROLL_AB_03 %<>% as.data.frame
save(MDCR_ENROLL_AB_03, file = "../data/MDCR_ENROLL_AB_03.rda")

