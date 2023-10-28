library(leaflet)

cidades_eua <- data.frame(
  Cidade = c("Nova York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose", "Austin", "Seattle", "Denver", "Miami", "Boston"),
  Latitude = c(40.7128, 34.0522, 41.8781, 29.7604, 33.4484, 39.9526, 29.4241, 32.7157, 32.7767, 37.3541, 30.2672, 47.6062, 39.7392, 25.7617, 42.3601),
  Longitude = c(-74.0060, -118.2437, -87.6298, -95.3698, -112.0740, -75.1652, -98.4936, -117.1611, -96.7970, -121.9552, -97.7431, -122.3321, -104.9903, -80.1918, -71.0589),
  Populacao = c(8398748, 3986559, 2716000, 2320268, 1680992, 1584138, 1547253, 1423851, 1343573, 1030119, 978908, 744955, 715522, 467963, 694583)
)

# Criação do mapa com marcadores com o provedor Esri 
leaflet(cidades_eua) %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addCircleMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    color = "red",
    popup = ~paste(Cidade, "<br> População: ", Populacao)
  )

# Criação do mapa com marcadores com o provedor padrão OpenStreetMap 
leaflet(cidades_eua) %>% 
  addTiles() %>% 
  addCircleMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    color = "red",
    popup = ~paste(Cidade, "<br> População: ", Populacao)
  )

# Criação do mapa com marcadores com o provedor padrão OpenStreetMap 
leaflet(cidades_eua) %>% 
  addTiles() %>% 
  addCircleMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    color = "red",
    clusterOptions = markerClusterOptions(),
    popup = ~paste(Cidade, "<br> População: ", Populacao)
  )

estadios_br <- data.frame(
  Estadio = c("Maracanã", "Allianz Parque", "Mineirão", "Beira-Rio", "Arena Corinthians", "Estádio Mané Garrincha", "Morumbi", "Vila Belmiro", "Arena Fonte Nova", "São Januário", "Arena da Baixada", "Nilton Santos", "Couto Pereira", "Castelão", "Ilha do Retiro", "Arena Pantanal", "Independência", "Barradão", "Rei Pelé", "Serra Dourada", "Fonte Nova"),
  Latitude = c(-22.9122, -23.5467, -19.8697, -30.0603, -23.5460, -15.7835, -23.5990, -23.9572, -12.9711, -22.8925, -25.4478, -22.8919, -25.4194, -3.7172, -8.0731, -15.5667, -15.6506, -19.8822, -12.9744, -9.9617, -16.6770),
  Longitude = c(-43.2302, -46.6729, -43.9693, -51.2286, -46.4723, -47.8997, -46.7213, -46.3336, -38.5033, -43.2279, -49.2770, -43.2877, -49.2604, -38.4814, -34.8996, -56.0902, -56.1118, -43.9253, -38.4993, -36.6369, -49.2700),
  Capacidade = c(78838, 44000, 61204, 50080, 49206, 72722, 66728, 16965, 48098, 21137, 42680, 46072, 39997, 63903, 35303, 30000, 44123, 23959, 51408, 19817, 45302)
)

