install.packages("terra")
install.packages("ggplot2")
install.packages("ggmap")
install.packages("sf")
install.packages("basemaps")
install.packages("mapedit")
install.packages("tidyterra")

library(ggplot2)
library(ggmap)
library(sf)
library(basemaps)
library(terra)
library(mapedit)
library(tidyterra)

data_path <- "Z:/Data/PoPS Runs/Spotted Lanternfly/spotted_latternfly/whole_usa/5km"
map_data <- rast(file.path(data_path, "probability_30_year.tif"))
map_data2 <- project(map_data, "epsg:3857")
n <- seq(1, 31, 1)
map_names <- paste0("probability", n)
names(map_data2) <- map_names

ggplot() +
  geom_spatraster(data = map_data2, aes(fill = probability1), alpha = 0.7) +
  coord_sf(crs = 3857)
  # scale_fill_grass_c(palette = "celsius")





# plot(map_data2[[1]])
# s <- draw_ext()
# ext <- terra::ext(map_data2[[1]])
#
# data(ext)
# # or use draw_ext() to interactively draw an extent yourself
#
# # view all available maps
# get_maptypes()
#
# # set defaults for the basemap
# # set_defaults(map_service = "osm", map_type = "topographic")
#
# # load and return basemap map as class of choice, e.g. as image using magick:
# basemap(s, map_service = "esri", map_type = "world_light_gray_base")








# For GGmap
# Load spatial data
nc <- st_read(system.file("shape/nc.shp", package = "sf"))
# Get basemap from Google Maps
nc_map <- get_map(location = "North Carolina, NC", zoom = 7)
# Plot basemap with spatial data
ggmap(nc_map) +
  geom_sf(data = st_centroid(nc),
          aes(color = SID79, size = BIR74),
          inherit.aes = FALSE, show.legend = "point") +
  coord_sf(datum = NA) +
  theme_minimal()
