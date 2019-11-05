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

MDCR_ENROLL_AB_08 <-
  lapply(
         c(paste0(tmpdir, "/2013/CPS_MDCR_ENROLL_AB_8.xlsx"),
           paste0(tmpdir, "/2014/CPS_MDCR_ENROLL_AB_8.xlsx"),
           paste0(tmpdir, "/2015/CPS_MDCR_ENROLL_AB_8.xlsx"),
           paste0(tmpdir, "/2016/CPS_MDCR_ENROLL_AB_8.xlsx"),
           paste0(tmpdir, "/2017/CPS_MDCR_ENROLL_AB_8.xlsx"))
         ,
         readxl::read_excel,
         skip = 3,
         col_type = "text"
  )

MDCR_ENROLL_AB_08[[1]]$Year <- 2013L
MDCR_ENROLL_AB_08[[2]]$Year <- 2014L
MDCR_ENROLL_AB_08[[3]]$Year <- 2015L
MDCR_ENROLL_AB_08[[4]]$Year <- 2016L
MDCR_ENROLL_AB_08[[5]]$Year <- 2017L

MDCR_ENROLL_AB_08 %<>%
  dplyr::bind_rows(.) %>%
  dplyr::distinct(.) %>%
  dplyr::filter(!is.na(`Total Medicare Enrollees`)) %>%
  dplyr::mutate_at(dplyr::vars(-`Area of Residence`, -Year),
                   ~ suppressWarnings(as.numeric(.)))


cat("# Auto Generated. Do not edit by hand",
    "#' Total Medicare Enrollment:  Part A and/or Part B Enrollees, by Type of Entitlement and Area of Residence.",
    "#'",
    "#' Total Medicare Enrollment:  Part A and/or Part B Enrollees, by Type of Entitlement and Area of Residence.",
    "#'",
    "#' NOTES:  The enrollment counts are determined using a person-year methodology.  Numbers and percentages may not add to totals because of rounding.",
    "#'",
    "#' There are some NA values in this data set.  These NA values are associated with counts between 1 and 10 have been suppressed because of CMS rules to protect the privacy of beneficiaries, or have been cross-suppressed to prevent the recalculation of suppressed counts between 1 and 10.",
    "#'",
    "#' @source Centers for Medicare & Medicaid Services, Office of Enterprise Data and Analytics, CMS Chronic Conditions Data Warehouse.",
    "#'",
    "\"MDCR_ENROLL_AB_08\"",
    sep = "\n",
    file = "../R/MDCR_ENROLL_AB_08.R")

MDCR_ENROLL_AB_08 %<>% as.data.frame
save(MDCR_ENROLL_AB_08, file = "../data/MDCR_ENROLL_AB_08.rda")

