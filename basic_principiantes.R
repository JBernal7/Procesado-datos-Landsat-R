# Instalación del paquete sf (simple features) que permite el acceso a datos geograficos
#install.packages("sf")
# Activación del paquete una vez descargado
library(sf)

# Instalación del paquete devtools que permite la descarga del paquete en desarrollo siguiente
#install.packages("devtools")
# Activación del paquete anterior
library(devtools)

# Instalación del paquete getSpatialData que permite la descarga de imágenes espaciales
#devtools::install_github("16EAGLE/getSpatialData")
# Activación del paquete anterior

install_github("16EAGLE/getSpatialData")
library(getSpatialData)

#Leer los límites de la zona de estudio donde se produjo el incendio
Limites.AOI<-st_read("C:/Geoforest/Sensores/Limites_AOI/Limites_AOI.shp")

# Definir los límites como nuestra zona de interés o area of interest (AOI):
library(getSpatialData)
set_aoi(Limites.AOI$geometry)

# Visualizar la zona
view_aoi()

# Login en la plataforma USGS
login_USGS(username = "JBernal")

# Productos de imágenes satelitales disponibles a través de getSpatialData
get_products()

# Centrándonos en los productos de Landsat
getLandsat_products()

# Búsqueda de las imágenes
imagenes <- getLandsat_records(time_range = c("1993-03-01", "1993-04-01"), 
                               products = "landsat_tm_c2_l2")

# Visualizar resultados de la búsqueda
View(imagenes)

# Filtrado de resultados por los correspondientes al nivel "l1"
imagenes <- imagenes[imagenes$level == "l1",]

# Visualizar resultados del filtrado
View(imagenes)

# Establacer el direcorio de descarga
set_archive("C:/Geoforest/Sensores/Descarga_Landsat")

# Descarga de las vistas previas georreferenciadas de las imágenes
imagenes <- get_previews(imagenes) 

# Visualizar la vista previa de la primera imagen
plot_previews(imagenes[1,])

# Visualizar la vista previa de la segunda imagen
plot_previews(imagenes[2,])

# Enlace de descarga
url_<-paste0("https://landsatlook.usgs.gov/bundle/", (imagenes$record_id[2]),".tar")

# ADVERTENCIA: ANTES DE EJECUTAR EL SIGUIENTE PASO SE DEBE HABER INICIADO SESIÓN EN LA PLATAFORMA EARTHEXPLORER DENTRO DEL NAVEGADOR DE INTERNET. 
# Descarga
browseURL(url_) 

# Búsqueda de las imágenes
imagenes <- getLandsat_records(time_range = c("1993-09-01", "1993-10-30"), 
                               products = "landsat_tm_c2_l2")

# Filtrado de resultados por los correspondientes al nivel "l1"
imagenes <- imagenes[imagenes$level == "l1",]

# Visualizar resultados del filtrado
View(imagenes)

# Establacer el direcorio de descarga
set_archive("C:/Geoforest/Sensores/Descarga_Landsat")

# Descarga de las vistas previas georreferenciadas de las imágenes
imagenes <- get_previews(imagenes) 

# Visualizar la vista previa de la primera imagen
plot_previews(imagenes[1,])

# Visualizar la vista previa de la segunda imagen
plot_previews(imagenes[2,])

# Visualizar la vista previa de la tercera imagen
plot_previews(imagenes[3,])

# Visualizar la vista previa de la cuarta imagen
plot_previews(imagenes[4,])

# Enlace de descarga
url_<-paste0("https://landsatlook.usgs.gov/bundle/",
             (imagenes$record_id[4]),".tar")

# Descarga
browseURL(url_) 

library(raster) 
# Leer cada una de las bandas de la imagen 
# Azul
b1<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B1.TIF')
# Verde
b2<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B2.TIF')
# Rojo
b3<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B3.TIF')
# Infrarrojo cercano 1
b4<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B4.TIF')
# Infrarrojo cercano 2
b5<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B5.TIF')
# Infrarrojo lejano
b7<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930329_20200914_02_T1_SR_B7.TIF')

# Impresión de variables 
b1

##RECORTE DE LA ZONA DE INTERES##
## Reading layer `Limites_AOI' from data source `C:\MOOC_TD\Limites_AOI.shp' using driver `ESRI Shapefile'
## Simple feature collection with 1 feature and 0 fields
## Geometry type: POLYGON
## Dimension:     XY
## Bounding box:  xmin: -3.554455 ymin: 37.08681 xmax: -3.109509 ymax: 37.3591
## Geodetic CRS:  WGS 84

#Extensión de los límites de la zona de estudio.
#Notese que el sistema de coordenadas es geográfico
extent(Limites.AOI)

#Transformación al sistema de coordenadas proyectadas WGS84 UTM 30N de la zona de estudio
Limites.AOI<-st_transform(Limites.AOI,crs = 32630)

#Comprobación de que los límites de la zona de estudio tienen el sistema de coordenadas nuevo
extent(Limites.AOI)

#Recorte de la imagen Landsat por la extensión de la zona de estudio
b1<-crop(b1,extent(Limites.AOI))
b2<-crop(b2,extent(Limites.AOI))
b3<-crop(b3,extent(Limites.AOI))
b4<-crop(b4,extent(Limites.AOI))
b5<-crop(b5,extent(Limites.AOI))
b7<-crop(b7,extent(Limites.AOI))

#Transformacion con factor de escala
b1<-(b1*0.0000275)- 0.2
b2<-(b2*0.0000275)- 0.2
b3<-(b3*0.0000275)- 0.2
b4<-(b4*0.0000275)- 0.2
b5<-(b5*0.0000275)- 0.2
b7<-(b7*0.0000275)- 0.2

## ESTADISTICA DE LA IMAGEN ##
# Histograma de valores
par(mfrow=c(2,3))
hist(b1,main = "Banda 1",breaks=200,xlab = "Valor del pixel")
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")

## VISUALIZACION ##
par(mfrow=c(1,1))
plot(b1, main = "Azul",col = grey.colors(255, start=0, end=1))
plot(b2, main = "Verde",col = grey.colors(255, start=0, end=1))
plot(b3, main = "Rojo", col = grey.colors(255, start=0, end=1))
plot(b4, main = "Infrarrojo cercano 1",col = grey.colors(255, start=0, end=1))
plot(b5, main = "Infrarrojo cercano 2", col = grey.colors(255, start=0, end=1))
plot(b7, main = "Infrarrojo lejano",col = grey.colors(255, start=0, end=1))

#Limitar los valores digitales de los píxeles de la imagen a 1
b1[b1>1]=1
b2[b2>1]=1
b3[b3>1]=1
b4[b4>1]=1
b5[b5>1]=1
b7[b7>1]=1

# Histograma de valores, ya ajustado
par(mfrow=c(2,3))
hist(b1,main = "Banda 1",breaks=200,xlab = "Valor del pixel")
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")

#Unión de bandas rojo-verde-azul en una sola imagen
Color_real<-stack(b3,b2,b1)

#Impresión de resultado
Color_real

#Cambio de nombre a las bandas para manipularlas mejor en procesos posteriores
names(Color_real)<-c("B3","B2","B1")

#Visualización de la imagen
par(mfrow=c(1,1))
plotRGB(Color_real,scale=1)

#Visualización con ajuste del histograma lineal
plotRGB(Color_real,scale=1,stretch='lin')

#Visualización con ajuste del histograma siguiendo una ecualización
plotRGB(Color_real,scale=1,stretch='hist')

#Combinacion de bandas 4-3-1 falso color

#Unión de bandas infrarrojo-rojo-verde en una sola imagen
Falso_color<-stack(b4,b3,b2)

#Visualización de la imagen en falso color
plotRGB(Falso_color,scale=1)

#Visualización de la imagen en falso color con ajuste del histograma lineal
plotRGB(Falso_color,scale=1,stretch='lin')

#Visualización de la imagen en falso color con ajuste del histograma siguiendo una ecualización
plotRGB(Falso_color,scale=1,stretch='hist')

#UNION TODAS LAS BANDAS#

#Unión de bandas espectrales de Landsat en una sola imagen
img_preincendio<-stack(b1,b2,b3,b4,b5,b7)

#Nombres de las bandas
names(img_preincendio)

#Cambiar nombres de las bandas
names(img_preincendio)<-c("B1","B2","B3","B4","B5","B7")

#Comprobación del cambio en los nombres de las bandas
names(img_preincendio)

#Visualización de la imagen con la combinación de bandas 6-5-3
plotRGB(img_preincendio, r=6,g=5,b=3,scale=1,stretch='lin')

#Visualización de la imagen con la combinación de bandas 6-5-3 con zoom
plotRGB(img_preincendio, r=6,g=5,b=3,scale=1,stretch='lin',
        ext=extent(c(483500,490000,4125000,4130000)))

# GUARDAR RASTER NO EN CODIGO DADO EN CLASE ## 
rasterzero <- plotRGB
path <- "C:/Geoforest/Sensores/raster"
writeRaster(rasterzero, filename=path, overwrite=TRUE)


## GENERAR INDICES DE VEGETACION ## 

library(ggplot2)

#Semilla que permite la repetibilidad de la muestra seleccionada al azar
set.seed(1)

#Selección de muestra aleatoria con un tamaño de 10.000 píxeles de la imagen
sr <- sampleRandom(img_preincendio, 10000)

#Visualización de la relación entre la banda verde y la banda azul de la imagen a partir de la muestra seleccionada
plot(sr[,c(1,2)], main = "Relaciones entre bandas")
mtext("Azul vs Verde", side = 3, line = 0.5)

#Ceficiente de correlación entre las bandas verde y azul a partir de la muestra seleccionada
cor(sr[,1],sr[,2])

#Visualización de la relación entre la banda rojo y la banda infrarrojo cercano de la imagen a partir de la muestra seleccionada
plot(sr[,c(5,3)], main = "Relaciones entre bandas")
mtext("NIR vs Rojo", side = 3, line = 0.5)

#Coeficiente de correlación entre las bandas verde y azul a partir de la muestra seleccionada
cor(sr[,1],sr[,2])

#Visualización de la relación entre la banda rojo y la banda infrarrojo cercano de la imagen a partir de la muestra seleccionada
plot(sr[,c(5,3)], main = "Relaciones entre bandas")
mtext("NIR vs Rojo", side = 3, line = 0.5)

#Coeficiente de correlación entre las bandas rojo e infrarrojo a partir de la muestra seleccionada
cor(sr[,5],sr[,3])

#Cálculo del índice NDVI a partir de las bandas
NDVI_pre<-(b4-b3)/(b4+b3)

#Impresión de resultado
NDVI_pre

#Histograma de valores de la imagen del índice NDVI
hist(NDVI_pre)

#Visualización del índice NDVI
plot(NDVI_pre)

#Umbralización del índice NDVI
tipos.veg <- reclassify(NDVI_pre, 
                        c(-Inf,0.2,1, 0.2,0.4,2, 0.4,0.5,3, 0.5,Inf,4))

#Visualización de los resultados de la umbralización
plot(tipos.veg,col = rev(terrain.colors(4)),
     main = 'NDVI umbralizado')

#Gráfico de distribución de tipos de vegetación
barplot(tipos.veg,
        main = "Distribución de tipos de vegetación según NDVI",
        col = rev(terrain.colors(4)), cex.names=0.7,
        names.arg = c("Sin vegetación", 
                      "Vegetación \n escasa \n o enferma", 
                      "Vegetación \n moderada", 
                      "Vegetación \n densa \n o sana"))

## CONSTRUCCION DEL INDICE NBR ##

#Crear una función para calcular un índice de vegetación
VI <- function(img, i, j) {
  bi <- img[[i]]
  bj <- img[[j]]
  vi <- (bi - bj) / (bi + bj)
  return(vi)
}

#Crear un índice de vegetación a través de una función
NBR_pre <- VI(img_preincendio, 6, 4)

#Visualización del resultado
plot(NBR_pre,
     main = "NBR Pre-Incendio",
     axes = FALSE, box = FALSE)

## GUARDAR INDICES GENERADOS ## HACER CUANDO YA VAYA BIEN 
writeRaster(NDVI_pre,
            filename="C:/Geoforest/Sensores/Indices_vegetacion/NDVI_pre.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

writeRaster(NBR_pre,
            filename="C:/Geoforest/Sensores/Indices_vegetacion/NBR_pre.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

## DESPUES DEL INCENDIO ##
#1 EXPLORACION DE LA IMAGEN# PONER LAS MIAS

# Leer cada una de las bandas de la imagen NO SON LAS DE LA PRACTICA, HAN COLGADO IMAGENES CON NUBES
# Azul
b1<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930921_20200913_02_T1_SR_B1.TIF')
# Verde
b2<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930921_20200913_02_T1_SR_B2.TIF')
# Rojo
b3<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930921_20200913_02_T1_SR_B3.TIF')
# Infrarrojo cercano 1
b4<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930921_20200913_02_T1_SR_B4.TIF')
# Infrarrojo cercano 2
b5<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930921_20200913_02_T1_SR_B5.TIF')
# Infrarrojo lejano
b7<-raster('C:/Geoforest/Sensores/Landsat_Moodle/LT05_L2SP_200034_19930921_20200913_02_T1_SR_B7.TIF')

#Recorte de la imagen Landsat por la extensión de la zona de estudio
b1<-crop(b1,extent(Limites.AOI))
b2<-crop(b2,extent(Limites.AOI))
b3<-crop(b3,extent(Limites.AOI))
b4<-crop(b4,extent(Limites.AOI))
b5<-crop(b5,extent(Limites.AOI))
b7<-crop(b7,extent(Limites.AOI))

#Transformacion con factor de escala
b1<-(b1*0.0000275)- 0.2
b2<-(b2*0.0000275)- 0.2
b3<-(b3*0.0000275)- 0.2
b4<-(b4*0.0000275)- 0.2
b5<-(b5*0.0000275)- 0.2
b7<-(b7*0.0000275)- 0.2

# Histograma de valores
par(mfrow=c(2,3))
hist(b1,main = "Banda 1",breaks=200,xlab = "Valor del pixel")
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")

#Visualización
par(mfrow=c(1,1))
plot(b1, main = "Azul",col = grey.colors(255, start=0, end=1))
plot(b2, main = "Verde",col = grey.colors(255, start=0, end=1))
plot(b4, main = "Infrarrojo cercano 1",col = grey.colors(255, start=0, end=1))
plot(b5, main = "Infrarrojo cercano 2", col = grey.colors(255, start=0, end=1))
plot(b7, main = "Infrarrojo lejano",col = grey.colors(255, start=0, end=1))

#Limitar los valores digitales de los píxeles de la imagen a 1
b1[b1>1]=1
b2[b2>1]=1
b3[b3>1]=1
b4[b4>1]=1
b5[b5>1]=1
b7[b7>1]=1

# Histograma de valores
par(mfrow=c(2,3))
hist(b1,main = "Banda 1",breaks=200,xlab = "Valor del pixel")
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")

#Unión de bandas rojo-verde-azul en una sola imagen
Color_real<-stack(b3,b2,b1)

#Impresión de resultado
Color_real

#Cambio de nombre a las bandas para manipularlas mejor en procesos posteriores
names(Color_real)<-c("B3","B2","B1")

#Visualización de la imagen
par(mfrow=c(1,1))
plotRGB(Color_real,scale=1)

#Visualización con ajuste del histograma lineal
plotRGB(Color_real,scale=1,stretch='lin')

#Visualización con ajuste del histograma siguiendo una ecualización
plotRGB(Color_real,scale=1,stretch='hist')

#Unión de bandas infrarrojo-rojo-verde en una sola imagen
Falso_color<-stack(b4,b3,b2)

#Visualización de la imagen en falso color
plotRGB(Falso_color,scale=1)

#Visualización de la imagen en falso color con ajuste del histograma lineal
plotRGB(Falso_color,scale=1,stretch='lin')

#Visualización de la imagen en falso color con ajuste del histograma siguiendo una ecualización
plotRGB(Falso_color,scale=1,stretch='hist')

#Unión de bandas espectrales de Landsat en una sola imagen
img_postincendio<-stack(b1,b2,b3,b4,b5,b7)

#Nombres de las bandas
names(img_postincendio)

#Cambiar nombres de las bandas
names(img_postincendio)<-c("B1","B2","B3","B4","B5","B7")

#Comprobación del cambio en los nombres de las bandas
names(img_postincendio)

#Visualización de la imagen con la combinación de bandas 6-5-3
plotRGB(img_postincendio, r=6,g=5,b=3,scale=1,stretch='lin')

#Visualización de la imagen con la combinación de bandas 6-5-3 con zoom
plotRGB(img_postincendio, r=6,g=5,b=3,scale=1,stretch='lin',
        ext=extent(c(483500,490000,4125000,4130000)))

#Guardar imagen postincendio
writeRaster(img_postincendio,
            filename="C:/Geoforest/Sensores/Indices_vegetacion/img_postincendio.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

#Crear un índice de vegetación a través de una función
NBR_post <- VI(img_postincendio, 6, 4)

#Guardar índice NBR postincendio
writeRaster(NBR_post,
            filename="C:/Geoforest/Sensores/Indices_vegetacion/NBR_post.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales


### OBTENCCION DEL PERIMETRO Y LA SEVERIDAD DEL INCENDIO ###

## PREPARACION DE LAS IMAGENES ##
NBR_pre<-raster('C:/Geoforest/Sensores/indices_vegetacion/NBR_pre.tif')
NBR_post<-raster('C:/Geoforest/Sensores/indices_vegetacion/NBR_post.tif')

## CALCULO DEL DELTA DEL INDICE NBR ##
dNBR <- (NBR_pre) - (NBR_post)

plot(dNBR, main="dNBR")

## CLASIFICACION DEL MAPA DNBR ##
# cargamos los datos de la tabla anterior. Así se establece el rango de valores para umbralizar la información contenida en dNBR

NBR_rangos <- c(-Inf, -.50, 1, #Severidad alta
                -.50, -.25, 2, #Severidad moderada
                -.25, -.10, 3, #Severidad baja 
                -.10,  .10, 4, #No quemado
                .10,  .27, 5, #Bajo rebrote posterior al fuego 
                .27,  .66, 6, #Alto rebrote posterior al fuego
                .66, +Inf, 7) #Muy alto rebrote posterior al fuego

# Convierte los valores de rangos en matriz
class.matrix <- matrix(NBR_rangos, ncol = 3, byrow = TRUE)


# Umbralización 
dNBR_umb <- reclassify(dNBR, NBR_rangos,  right=NA)

## CREACION DEL MAPA DNBR UMBRALIZADO ##
# Crea el texto que se introducirá en la leyenda
leyenda=c("Severidad alta",
          "Severidad moderada",
          "Severidad baja",
          "No quemado",
          "Bajo rebrote posterior al fuego",
          "Alto rebrote posterior al fuego",
          "Muy alto rebrote posterior al fuego")

# Establecer los colores del mapa de severidad
mis_colores=c("purple",        #Severidad alta
              "red",           #Severidad moderada
              "orange2",       #Severidad baja 
              "yellow2",       #No quemado
              "limegreen",     #Bajo rebrote posterior al fuego 
              "green",         #Alto rebrote posterior al fuego
              "darkolivegreen")#Muy alto rebrote posterior al fuego

# Visualizar el mapa con ejes
plot(dNBR_umb, col = mis_colores,
     main = 'dNBR umbralizado')

# Visualizar el mapa sin ejes y con la leyenda creada
plot(dNBR_umb, col = mis_colores,legend=FALSE,box=FALSE,axes=FALSE,
     main = 'Severidad del incendio')
legend("topright", inset=0.05, legend =rev(leyenda), fill = rev(mis_colores), cex=0.5) 

### DETECCION DE CAMBIO ###
## PLATAFORMA DE GEE ##
## ESTUDIO MULTITEMPORAL ##

#Introducir imagenes NDVI
setwd("C:/Geoforest/Sensores/Deteccion_cambios")
NDVI.1994.2000 = stack(list.files(pattern='*.tif'))
NDVI.1994.2000 = brick(NDVI.1994.2000)

#Visualizar imagenes NDVI
plot(NDVI.1994.2000)

#Leer el perimetro del incendio
library(sf)
perimetro.def<-st_read("C:/Geoforest/Sensores/Perimetro_Severidad/perimetro.shp")

#Enmascara la imagen por la extensión del shapefile
NDVI.1994.2000 <- mask(NDVI.1994.2000,perimetro.def)

#Recorta la imagen por la extensión del shapefile
NDVI.1994.2000 <- crop(NDVI.1994.2000,perimetro.def)
plot(NDVI.1994.2000)

#Establecer la variable tiempo: número de aÃ±os del estudio
time <- 1:nlayers(NDVI.1994.2000) 

#Función para calcular la pendiente
fun=function(y) { if (is.na(y[1])){ NA } 
  else { m = lm(y ~ time); summary(m)$coefficients[2] }}

#Aplicar la función de la pendiente
NDVI.pendiente=calc(NDVI.1994.2000, fun)
NDVI.pendiente=NDVI.pendiente*7
plot(NDVI.pendiente)

#Función para calcular la significancia
fun=function(y) { if (is.na(y[1])){ NA } 
  else { m = lm(y ~ time); summary(m)$coefficients[8] }}

#Aplicar la función de la significancia
p <- calc(NDVI.1994.2000, fun=fun)
plot(p, main="p-Value")

#Enmascarar los valores de p>0.05 para obtener un nivel de confianza de 95%
m = c(0, 0.05, 1, 0.05, 1, 0)
rclmat = matrix(m, ncol=3, byrow=TRUE)
p.mask = reclassify(p, rclmat)

plot(p.mask, main="p-Value>0.05")

plot(p)

fun=function(x) { x[x<1] <- NA; return(x)}
p.mask.NA = calc(p.mask, fun)

NDVI.tendencia = mask(NDVI.pendiente, p.mask.NA)

library(viridis)
plot(NDVI.tendencia, main="Cambios significativos de NDVI",col=viridis(10))

writeRaster(NDVI.tendencia,
            filename="NDVI_tendencia_.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

library(sf)
coord1<-st_point(c(459502.9,4120681.7))
NDVI.coord1<-extract(NDVI.1994.2000,as(coord1,"Spatial"))

NDVI.coord1.tend<-extract(NDVI.tendencia,as(coord1,"Spatial"))
NDVI.coord1.tend

coord2<-st_point(c(464942.7,4123350.6))
NDVI.coord2<-extract(NDVI.1994.2000,as(coord2,"Spatial"))

NDVI.coord2.tend<-extract(NDVI.tendencia,as(coord2,"Spatial"))
NDVI.coord2.tend

plot(c(1994,1995,1996,1997,1998,1999,2000),NDVI.coord1,type = "b",pch=19,
     ylim=c(0,0.8),xlab="AÃ±o",ylab="NDVI",
     main="EvoluciÃ³n del NDVI")
lines(c(1994,1995,1996,1997,1998,1999,2000),NDVI.coord2,type = "b",pch=19,
      col="red")
legend("bottomright",legend=c(paste0("Tendencia:  ",round(NDVI.coord1.tend,2)),
                              paste0("Tendencia:  ",round(NDVI.coord2.tend,2))),
       cex=0.85,bty = "n",pch=c(19,19),col=c("black","red"))

coord1<-as(coord1,"Spatial")
crs(coord1)<-"+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs"

coord2<-as(coord2,"Spatial")
crs(coord2)<-"+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs"

library(mapview)
mapview(NDVI.tendencia)+mapview(list(coord1,coord2),
                                col.regions=list("blue","red"))
