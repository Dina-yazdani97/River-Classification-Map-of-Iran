🌍 River Classification Map of Iran in R
This repository demonstrates how to visualize river classifications across Iran using the Global River Classification (GloRiC) dataset and the R programming language.
The goal is to create a clean, clear, and reproducible workflow for mapping geographic data—ideal for projects in climatology, hydrology, meteorology, environmental science, and geospatial visualization.

This project extracts relevant river reaches from the GloRiC global dataset and maps only those located within Iran.
The map uses the Reduced Physio-Climatic Class (1st digit) of the classification system, providing a broad environmental categorization of each river reach.

The final output is an aesthetically pleasing, publication-ready map produced with ggplot2 and spatial data tools in R.
For this project:
✅ Only river reaches within Iran are used
✅ Only the Reduced Physio-Climatic Class (first digit) is visualized

🧰 Tools & Libraries

The project uses the following R packages:

library(ggplot2)       # data visualization
library(sf)            # spatial data handling
library(rnaturalearth) # basemap data for countries
library(rnaturalearthdata)
library(ggspatial)     # scale bars, north arrows
library(extrafont)     # custom fonts
library(dplyr)         # data wrangling
library(tidyr)         # data tidying
