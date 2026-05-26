#trial different compressions for the antipatharia data
#need to get the file under 100Mb to be able to push to Github, but ideally want to keep it as Geotiff so I can crop from disk.
#Using .rds results in the entire raster being loaded into memory (~4GB once in R)

#This page has lots of info on Geotiff compression options: https://kokoalberti.com/articles/geotiff-compression-optimization-guide/
#Generally zstd compression performs best (smallest file sizes)

# Antipathria data is from:
# Yesson, C., Bedford, F., Rogers, A.D. & Taylor, M.L. (2017). The global distribution of deep-water Antipatharia habitat.
# Deep Sea Research Part II: Topical Studies in Oceanography, 145, 79–86. https://doi.org/10.1016/j.dsr2.2015.12.004

# Data downloaded direct from PANAGEA: https://doi.pangaea.de/10.1594/PANGAEA.856033


#read in original antipatharia data
antipatharia_path <- "data-raw/antipatharia-testing/YessonEtAl_DSR2_2016_AntipathariaHSM.tif"

antipatharia <- terra::rast(antipatharia_path)

terra::writeRaster(antipatharia, "data-raw/antipatharia-testing/lzw_pred2_int1u.tif", gdal =  c("COMPRESS=LZW", "PREDICTOR=2", "NUM_THREADS=10"), datatype = "INT1U")

terra::writeRaster(antipatharia, "data-raw/antipatharia-testing/deflate_int1u.tif", gdal =  c("COMPRESS=DEFLATE", "NUM_THREADS=10"), datatype = "INT1U")

#zstd compression takes >30mins and uses a lot of memory
terra::writeRaster(antipatharia, "data-raw/antipatharia-testing/zstd_pred2_int1u_compress22.tif", gdal =  c("COMPRESS=ZSTD", "PREDICTOR=2", "ZSTD_LEVEL=22", "NUM_THREADS=10"), datatype = "INT1U")

terra::writeRaster(antipatharia, "data-raw/antipatharia-testing/zstd_pred2_int1u_compress15.tif", gdal =  c("COMPRESS=ZSTD", "PREDICTOR=2", "ZSTD_LEVEL=15", "NUM_THREADS=10"), datatype = "INT1U")

list.files("data-raw/antipatharia-testing", pattern = ".tif", fixed = TRUE, full.names = TRUE) |>
  sapply(FUN = function(x) file.size(x)/1e6) |>
  data.frame()

#results from above zstd with compressions factor of 22 is smallest fil size - 85 Mb
# deflate_int1u.tif                                                                                     115.99022
# lzw_pred2_int1u.tif                                                                                    99.66142
# YessonEtAl_DSR2_2016_AntipathariaHSM.tif                                                              115.61265
# zstd_pred2_int1u_compress15.tif                                                                        97.28706
# zstd_pred2_int1u_compress22.tif                                                                        85.04090

#write out the most compressed zstd compression = 22 file for use in the package
file.copy("data-raw/antipatharia-testing/zstd_pred2_int1u_compress22.tif", "inst/extdata/antipatharia.tif")

#delete test files
list.files("data-raw/antipatharia-testing", pattern = ".tif", fixed = TRUE, full.names = TRUE) |>
  sapply(FUN = file.remove)

file.remove("data-raw/antipatharia-testing/")


#####################################################
# Write compressed versions of other geotiffs

#cold water corals:
# Davies, A.J. & Guinotte, J.M. (2011). Global Habitat Suitability for Framework-Forming Cold-Water Corals.
# PLoS ONE, 6, e18483.  https://doi.org/10.1371/journal.pone.0018483

#data is "binary_grid_figure7.tif" which is data shown in Figure 7 of paper. Not available directly through the above link.
# This was received as part of a data package from IUCN via the Waitt Institute

cold_coral_path <- "data-raw/cold_coral/binary_grid_figure7.tif"

cold_coral <- terra::rast(cold_coral_path)

terra::writeRaster(cold_coral, "inst/extdata/cold_coral.tif", gdal =  c("COMPRESS=ZSTD", "PREDICTOR=2", "ZSTD_LEVEL=22", "NUM_THREADS=10"), datatype = "INT1U")

# Octocorals
# Yesson C, Taylor ML, Tittensor DP, Davies AJ, Guinotte J, Baco A, Black J, Hall-Spencer JM, Rogers AD (2012).
# Global habitat suitability of cold-water Octocorals. Journal of Biogeography 39: 1278-1292.
# https://doi.org/10.1111/j.1365-2699.2011.02681.x

# Data from paper is available via PANAGEA: https://doi.pangaea.de/10.1594/PANGAEA.775081
# However, these data are species distribution results for each of the 7 octocoral suborders.
# Figure 3 in the paper shows a consensus map, displaying a count (0 - 7, integers) of the number of suborders predicted present at each location
# The data behind this figure were obtained directly from the paper's lead author Dr Chris Yesson and are what is used here

octocoral_path <- "data-raw/YessonEtAl_Consensus.tif"

octocoral <- terra::rast(octocoral_path)

terra::writeRaster(octocoral, "inst/extdata/octocoral.tif", gdal = c("COMPRESS=ZSTD", "PREDICTOR=2", "ZSTD_LEVEL=22", "NUM_THREADS=10"), datatype = "INT1U")
