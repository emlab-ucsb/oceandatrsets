# Code for saving original seamounts data as RDS file

# Seamounts data is from the paper
# Yesson, Chris, Tom B. Letessier, Alex Nimmo-Smith, et al.
# “Improved Bathymetry Leads to >4000 New Seamount Predictions in the Global Ocean – but Beware of Phantom Seamounts!”
# UCL Open Environment, ahead of print, December 22, 2021.
# https://doi.org/10.14324/111.444/ucloe.000030.

# Data from PANAGEA: https://doi.pangaea.de/10.1594/PANGAEA.921688

seamounts_path <- "YessonEtAl2019-Seamounts-V2.shp"

seamounts <- sf::st_read(seamounts_path)

saveRDS(seamounts, "inst/extdata/seamounts.rds")
