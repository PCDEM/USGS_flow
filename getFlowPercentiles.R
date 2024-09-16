# Source in the flow percentiles script:
source('flow_percentiles.R')

# Process the flow datasets:
hdi <- read_excel('Data/MASTER_Flow_HDI_2006-2024.xlsx')
pc <- read_excel('Data/MASTER_Flow_Transect_2003-2024.xlsx')
usgs <- read_excel('Data/USGS_PC_Flow_2003_2024.xlsx')

# Combine the datasets:
dat <- bind_rows(hdi, pc, usgs) |>
  select(
    1:4
  ) 

# Calculate the flow percentiles:
flow_percentiles(
  data = dat,
  years = c(2003:2024),
  outpath = 'Data/'
)
