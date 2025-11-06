# Package Loading ---------------------------------------------------------
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
library(ggspatial)
library(extrafont)
library(dplyr)
library(tidyr)

# Load and prepare your shpfile data -------------------------------------------
# Read your shp data
Iran <- st_read("iran/iran.shp")
Iran <- st_transform(Iran, crs = 4326)

Rivers <- st_read("F:/Rivers.shp")
Rivers <- st_transform(Rivers, crs = 4326)

# Download country boundaries, ocean data and lake data------------------------------
lakes_sf <- ne_download(scale = 50, type = "lakes", category = "physical", returnclass = "sf")
lakes_sf <- st_transform(lakes_sf, crs = 4326)

countries_sf <- ne_countries(scale = "medium", returnclass = "sf")
countries_sf <- st_transform(countries_sf, crs = 4326)

oceans_sf <- ne_download(scale = 50, type = "ocean", category = "physical", returnclass = "sf")
oceans_sf <- st_transform(oceans_sf, crs = 4326)

# Create Reach Type classification based on first digit ------------------------
Rivers$reach_type <- substr(Rivers$Reach_type, 1, 1)

# Rivers Labels -----------------------------------------------------------
reach_type_labels <- c(
  "3" = "Warm and Hot, Low Moisture",
  "4" = "Warm, Medium Moisture", 
  "5" = "Warm, High Moisture",
  "6" = "Hot, High Moisture",
  "7" = "Very Hot, Low Moisture",
  "9" = "Cold and Warm, High Elevation",
  "10" = "Hot and Very Hot, High Elevation"
)

Rivers$reach_type_label <- reach_type_labels[Rivers$reach_type]

# Removing Missing Data ---------------------------------------------------
rivers_clean <- Rivers %>% 
  filter(!is.na(reach_type) & reach_type %in% names(reach_type_labels))

# Color Pallet ------------------------------------------------------------
reach_type_colors <- c(
  "3" = "#FF4500",  
  "4" = "#BCEE68",  
  "5" = "#3CB371",  
  "6" = "#CD661D",  
  "7" = "#FFA500",  
  "9" = "#009ACD", 
  "10" = "#CD0000" ) 


# Ocean Names -------------------------------------------------------------
oceans_text <- data.frame(
  name = c("Oman Sea", "Persian Gulf", "Caspian Sea"),
  lon = c(58, 51, 50),
  lat = c(24, 27, 39),
  angle = c(0, -45, 0),
  hjust = c(-0.5, 0.3, 0.1),
  vjust = c(0.1, 0.1, 0.5)
)

# Create Map with Classified Rivers and Lakes -----------------------------
river_map <- ggplot() +
  # Base layers
  geom_sf(data = oceans_sf, fill = "navy", color = "navy") +
  geom_sf(data = countries_sf, fill = "gray90", color = "gray50", linewidth = 0.3) +
  geom_sf(data = Iran, fill = "white", color = "black", linewidth = 1.5) +
  # Add lakes
  geom_sf(data = lakes_sf, fill = "navy", color = "navy", linewidth = 0.3, alpha = 0.6) +
  # Add rivers
  geom_sf(data = rivers_clean, aes(color = reach_type_label), linewidth = 0.7, alpha = 0.8) +
  # Ocean labels
  geom_text(data = oceans_text, 
            aes(x = lon, y = lat, label = name, angle = angle),
            family = "Times New Roman", 
            color = "white",
            size = 6,
            fontface = "bold",
            hjust = oceans_text$hjust, 
            vjust = oceans_text$vjust) +
  
  # Scale Bar and North Arrow
  annotation_scale(location = "bl", width_hint = 0.4) +
  annotation_north_arrow(
    location = "tr",
    which_north = "true",
    style = north_arrow_nautical,
    height = unit(3, "cm"),
    width = unit(3, "cm")
  ) +
  
  # Coordinate system
  coord_sf(
    xlim = c(42, 65),
    ylim = c(23, 41),
    expand = FALSE
  ) +
  
  # Color scale for rivers
  scale_color_manual(
    name = "Physio-Climatic Regions",
    values = setNames(reach_type_colors, reach_type_labels),
    na.value = "gray50"
  ) +
  
  # Theme and labels
  theme_minimal(base_family = "Times New Roman") +
  labs(
    title = "River Classification Map of Iran",
    subtitle = "Reduced physio-climatic class (1st digit)",
    caption = "Data Source: Global River Classification (GloRiC)\nhttps://www.hydrosheds.org/"
  ) +
  
  # Theme customization
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold", family = "Times New Roman"),
    plot.subtitle = element_text(hjust = 0.5, size = 12, family = "Times New Roman"),
    plot.caption = element_text(size = 12, family = "Times New Roman", hjust = 0, face = "bold"),
    legend.title = element_text(face = "bold", size = 12),
    legend.text = element_text(size = 10, face = "bold", family = "Times New Roman"),
    legend.position = "right",
    legend.key.height = unit(0.8, "cm"),
    axis.text = element_text(size = 12, color = "black", face = "bold", family = "Times New Roman"),
    axis.title = element_blank(),
    panel.background = element_rect(fill = "white", color = "black", linewidth = 1),
    panel.border = element_rect(fill = NA, color = "black", linewidth = 1),
    panel.grid = element_line(color = "gray90", linewidth = 0.2)
  )

print(river_map)

# Save Map ----------------------------------------------------------------
ggsave("Iran_River_Classification.png", plot = river_map, 
       width = 12, height = 10, dpi = 300, bg = "white")

