# install.packages("terra")
# install.packages("ggplot2")
# # install.packages("ggmap")
# install.packages("sf")
# install.packages("basemaps")
# # install.packages("mapedit")
# install.packages("tidyterra")

library(ggplot2)
# library(ggmap)
library(sf)
library(basemaps)
library(terra)
# library(mapedit)
library(tidyterra)

map_data <- rast("Z:/Data/PoPS Runs/Spotted Lanternfly/spotted_latternfly/whole_usa/5km/probability_30_year.tif")
n <- seq(1, 31, 1)
map_names <- paste0("probability", n)
names(map_data) <- map_names
map_data2 <- project(map_data, "epsg:3857")

## Read and project state and county data
counties <-  st_read("Z:/Data/Vector/USA/us_lower_48_counties.gpkg")
counties <- st_transform(counties, crs(map_data2))
states <-  st_read("Z:/Data/Vector/USA/us_lower_48_states.gpkg")
states <- st_transform(states, crs(map_data2))

#subset to NC
nc <- states[states$STATE_NAME == "North Carolina", ]
nc_counties <- counties[counties$STATE_NAME == "North Carolina", ]
nc_map_data <- crop(map_data, nc)

#subset to Orange, Durham, and Wake counties in NC
triangle_counties <- nc_counties[nc_counties$NAME %in% c("Wake", "Durham", "Orange"), ]
triangle_map_data <- crop(map_data, triangle_counties)

# Get list of possible basemaps
get_maptypes()


## For Whole USA
set_defaults(map_data2, map_service = "esri", map_type = "world_light_gray_reference")
x <- basemap_raster(map_data2, map_service = "esri", map_type = "world_light_gray_reference")
x_terr <- rast(x)

ggplot() +
  geom_spatraster_rgb(data = x_terr) +
  geom_spatraster(data = map_data2, aes(fill = probability5), alpha = 0.7, na.rm = TRUE) +
  geom_sf(data = counties, fill = NA, color = "black", size = 0.5) +
  geom_sf(data = states, fill = NA, color = "black", size = 1.5) +
  coord_sf(crs = 3857) +
  theme_void()
  # scale_fill_grass_c(palette = "celsius")


## For NC
set_defaults(nc_map_data, map_service = "esri", map_type = "world_light_gray_reference")
x <- basemap_raster(nc_map_data, map_service = "esri", map_type = "world_light_gray_reference")
x_terr <- rast(x)

ggplot() +
  geom_spatraster_rgb(data = x_terr) +
  geom_spatraster(data = nc_map_data, aes(fill = probability5), alpha = 0.7, na.rm = TRUE) +
  geom_sf(data = nc_counties, fill = NA, color = "black", size = 0.5) +
  geom_sf(data = nc, fill = NA, color = "black", size = 1.5) +
  coord_sf(crs = 3857) +
  theme_void()
# scale_fill_grass_c(palette = "celsius")


## For Triangle
set_defaults(triangle_map_data, map_service = "esri", map_type = "world_light_gray_reference")
x <- basemap_raster(triangle_map_data, map_service = "esri", map_type = "world_light_gray_reference")
x_terr <- rast(x)

ggplot() +
  geom_spatraster_rgb(data = x_terr) +
  geom_spatraster(data = triangle_map_data, aes(fill = probability5), alpha = 0.7, na.rm = TRUE) +
  geom_sf(data = triangle_counties, fill = NA, color = "black", size = 0.5) +
  coord_sf(crs = 3857) +
  theme_void()
# scale_fill_grass_c(palette = "celsius")
