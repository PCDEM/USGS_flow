flow_percentiles <- function(data, years, outpath){
  
  # DESCRIPTION:
  # ---------
  # The purpose of this functions is to calculate the 5th and 95th percentiles
  # of flow data for the wet and dry seasons for each site and for each source.
  # The user can compile data from three different data sources (HDI, USGS, PCDEM)
  # and pass them to the 'data' argument, then define the years of interest to
  # calculate the percentiles for. The output data can be used to determine 
  # representativeness of flow values for each site where a value exceeding the
  # percentiles can be considered non-representative of 'normal' flow conditions.

  # USAGE:    

  #         flow_percentiles(data = combined_data_sources,
  #                          years = c(2014,2024)),
  #                          outpath = 'path/to/save/percentiles.xlsx')
  
  # INPUTS:
  # -------
  # data    = Flow data that can be combined from different data sources. Columns
  #           MUST be labelled 'Source','Site','Date', and 'Q' to work properly
  # years   = A vector of years to calculate the percentiles for.
  # outpath = The path to save the output excel file containing the percentiles.
  
  # OUTPUTS:
  # -------
  # 1) An excel file containing the 5th and 95th percentiles of flow data for the
  #   wet and dry seasons for each site and for each source.
  
  # -----AUTHORS:-----
  # Alex Manos (9/10/2024)

  #-----------------------------------------------------------------------------
  
  # Load required libraries:
  library(readxl)
  library(tidyverse)
  library(openxlsx)
  
  # Define the wet and dry seasons:
  dat <- dat |>
    mutate(
      Season = ifelse(month(Date) %in% 6:10, 'Wet','Dry')
      ) |>
    filter(
      year(Date) %in% years
    )
  
  # Custome function to calculate percentiles for flow data sources:
  flowP <- function(source){
    dat |>
      filter(
        Source == source
      ) |>
      group_by(
        Site, Season
      ) |>
      summarise(
        p5 = quantile(Q, 0.05, na.rm = TRUE),
        p95 = quantile(Q, 0.95, na.rm = TRUE)
      ) |>
      arrange(
        Season
      ) |>
      mutate(across(c('p5', 'p95'), round, 3))
  }
  
  # Run the function for each data source (may need to be adjusted in the future
  # based on changes in data sources):
  hdiP <- flowP('HDI')
  usgsP <- flowP('USGS')
  pcP <- flowP('PCDEM')
  
  # Make list of percentile data to make different sheets in excel file:
  sheets <- list(
    'HDI' = hdiP,
    'USGS' = usgsP,
    'PCDEM' = pcP
  )
  
  # Write the data to an excel file:
  write.xlsx(sheets, paste0(outpath,'Flow_Percentiles.xlsx'))

}