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

MDCR_ENROLL_AB_07 <-
  lapply(
         c(paste0(tmpdir, "/2013/CPS_MDCR_ENROLL_AB_7.xlsx"),
           paste0(tmpdir, "/2014/CPS_MDCR_ENROLL_AB_7.xlsx"),
           paste0(tmpdir, "/2015/CPS_MDCR_ENROLL_AB_7.xlsx"),
           paste0(tmpdir, "/2016/CPS_MDCR_ENROLL_AB_7.xlsx"),
           paste0(tmpdir, "/2017/CPS_MDCR_ENROLL_AB_7.xlsx"))
         ,
         readxl::read_excel,
         skip = 3,
         col_type = "text"
  )

MDCR_ENROLL_AB_07[[1]]$Year <- 2013L
MDCR_ENROLL_AB_07[[2]]$Year <- 2014L
MDCR_ENROLL_AB_07[[3]]$Year <- 2015L
MDCR_ENROLL_AB_07[[4]]$Year <- 2016L
MDCR_ENROLL_AB_07[[5]]$Year <- 2017L

MDCR_ENROLL_AB_07 %<>%
  dplyr::bind_rows(.) %>%
  dplyr::distinct(.) %>%
  dplyr::filter(!is.na(`Part A and/or Part B Total`)) %>%
  dplyr::mutate_at(dplyr::vars(-`Area of Residence`, -Year),
                   as.numeric)


cat("# Auto Generated. Do not edit by hand",
    "#' Total Medicare Enrollment:  Part A and/or Part B Total, Aged, and Disabled Enrollees, by Area of Residence",
    "#'",
    "#' Total Medicare Enrollment:  Part A and/or Part B Total, Aged, and Disabled Enrollees, by Area of Residence",
    "#'",
    "#' NOTES:  The enrollment counts are determined using a person-year methodology.  Numbers and percentages may not add to totals because of rounding.",
    "#'",
    "#' @source Centers for Medicare & Medicaid Services, Office of Enterprise Data and Analytics, CMS Chronic Conditions Data Warehouse.",
    "#'",
    "\"MDCR_ENROLL_AB_07\"",
    sep = "\n",
    file = "../R/MDCR_ENROLL_AB_07.R")

MDCR_ENROLL_AB_07 %<>% as.data.frame
save(MDCR_ENROLL_AB_07, file = "../data/MDCR_ENROLL_AB_07.rda")

