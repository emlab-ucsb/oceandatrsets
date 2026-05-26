## code to prepare `Geomorphology` dataset goes here

library(sf)
library(dplyr)

#write the geomorphological data from Harris et al. 2014 to rds objects so they can be easily packaged with code releases.
# Write each file separately as combined they will exceed the 100Mb Github limit.
# Excluding depth classifications which can be done directly by `oceandatr` using the latest bathymetry data (see get_bathymetry() function)
# Seamounts also excluded as most recent seamount data is available via `get_seamounts()` function

#working paths
data_file_path <- "data-raw/global-seafloor-geomorphology"

geomorph_files_all <- list.files(path = data_file_path, full.names = TRUE, pattern = '\\.shp$')
  #Remove features that are just classification of depths - will do this using latest GEBCO data. Want to include Shelf_valleys, hence removal of specific shelf strings. Removal classification of abyssal depths ("Abyss") but want to keep "Abyssal_Classification", hence the specific string.

geomorph_files <- geomorph_files_all[-grep("Abyss\\.|Hadal|Seamounts|Shelf_Classification|Shelf\\.|Slope", geomorph_files_all)]

sf_use_s2(FALSE)

for (file_name in geomorph_files) {
  feature_name <- gsub(pattern =  ".shp",replacement =  "", basename(file_name)) |>
    tolower()

  geomorph_sf_object <- st_read(file_name) |>
    st_make_valid()

  #change all columns names to lower case - there are both "Type" and "type" fields
  names(geomorph_sf_object) <- tolower(names(geomorph_sf_object))

  if(any(grepl("type", names(geomorph_sf_object)))) {
    for (geomorph_type in unique(geomorph_sf_object$type)) {

      naming <- paste0(ifelse(feature_name == "canyons", paste0("canyons_", gsub(pattern = " ", replacement = "_", geomorph_type)), gsub(pattern = " ", replacement = "_", tolower(geomorph_type))))
      geomorph_sf_object |>
        filter(type == geomorph_type) |>
        st_union() |>
        st_as_sf() |>
        dplyr::mutate(geomorph_type = naming, .before = 1) |>
        sf::st_set_geometry("geometry") |>
        saveRDS(file = file.path("inst/extdata/geomorphology", paste0(naming, ".rds")))
    }
  } else if(feature_name == "abyssal_classification"){
    for(abyssal_class in c("Hills", "Plains")){ #only want Hill and Plains, not seamounts since these will come from more recent data
      geomorph_sf_object |>
        filter(class == abyssal_class) |>
        st_union() |>
        st_as_sf() |>
        dplyr::mutate(geomorph_type = paste0("abyssal_", tolower(abyssal_class)), .before = 1) |>
        sf::st_set_geometry("geometry") |>
        saveRDS(file = file.path("inst/extdata/geomorphology", paste0("abssyal_", tolower(abyssal_class), ".rds")))
    }
  } else{
    geomorph_sf_object |>
      st_union() |>
      st_as_sf() |>
      dplyr::mutate(geomorph_type = feature_name, .before = 1) |>
      sf::st_set_geometry("geometry") |>
      saveRDS(file = file.path("inst/extdata/geomorphology", paste0(feature_name, ".rds")))
  }
}
