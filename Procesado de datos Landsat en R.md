

# Procesado de datos Landsat en R
Jessica Bernal Borrego
23/02/2022

  
##### Málaga se sitúa en una de las regiones mediterráneas más amenazadas por los riesgos asociados al agua y a los efectos del cambio climático, como lo demuestran de manera evidente los cada vez más frecuentes e intensos episodios torrenciales, de inundaciones, sequías e incendios que afectan de forma directa al ámbito ecológico, social y económico malagueño. En 2021, entre los días 8 y 14 de septiembre la Sierra Bermeja sufrió el peor incendio registrado hasta la fecha en Andalucía, con cerca de 10.000 ha calcinadas. 

##### Se propone para esta tarea una aproximación a la identificación y caracterización de la zona incendiada en la Sierra Bermeja. Con este fin se ejecutará un script a través de RStudio para la descarga de las ortofotos generadas con imágenes captadas por teledetección antes y después del episodio, para a continuación realizar la combinación de bandas que nos permita discriminar diferentes características del terreno. Asimismo, se aplicará el índice de vegetación de diferencia normalizada (NDVI) y el índice normalizado de área quemada (NBR) a las imágenes obtenidas, para por último obtener la severidad del incendio a través del delta del indice NBR (dNBR). 



# 1. OBTENCION DE IMAGENES LANDSAT 8

##### Antes de comenzar, cargamos la capa con los límites de la zona de estudio si estamos utilizando RStudio Cloud, o indicamos el directorio de trabajo si trabajamos desde el software de escritorio. ###
##### En nuestro caso, la capa se denomina *Limites_AOI* , siendo el directorio:

``` setwd("C:/Geodirectorio/Geodatos/Sierra_Bermeja")```

##### Seguidamente, indicaremos las librerias que se van a emplear. En caso de no tenerlas previamente instaladas, utilizar: 

``` install.packages("nombre de la libreria")```

##### Activamos las librerías:
~~~
library(sf)
library(devtools)
library(getSpatialData) 
~~~

##### A continuación, se introduce la zona de estudio:
```Limites.AOI <- st_read('./Limites_AOI.shp')```

##### Y marcamos esta zona como nuestro area de interes (AOI):
```set_aoi(Limites.AOI$geometry)```

##### Visualizamos la zona:
```view_aoi()```

##### El siguiente paso necesario es logarnos en la plataforma USGS de la cual vamos a descargar las imagenes Landsat (la cuenta debemos tenerla previamente creada):

```login_USGS(username = 'xxxxxx')```

##### Vemos los productos de imágenes satelitales disponibles a través de getSpatialData:
```get_products()```

##### Centrándonos en los productos Landsat:
```getLandsat_products()```


### **1.1. Imágenes Preincendio** 
##### Puesto que el siniestro ocurrió en el mes de septiembre, parece razonable pensar que una imagen de primavera del mismo año podría generar el contraste necesario para el análisis del suceso. Es por ello que se va a emplear el mes de marzo como rango de búsqueda temporal.

##### Para la búsqueda de imágenes, se emplea el producto de los datos procedentes de Landsat 8, satélite operativo en el periodo en el que ocurrió el incendio, con nivel de procesamiento 2.

##### Las imágenes Landsat 8 están formadas por once bandas distribuidas de la siguiente forma:

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c58.png)


##### Las 9 primeras son adquiridas por el sensor óptico OLI (*Operational Land Imager*) con 30 metros de tamaño de píxel y las dos últimas son adquiridas por el sensor TIRS (Thermal INfrared) con un tamaño de píxel de 100 metros, aunque se remuestrean a 30 metros para distribuirlas con el mismo tamaño de píxel que las demás bandas: https://zonegis.es/combinar-bandas-landsat-8-con-qgis-2-16-nodebo/ 

##### Procedemos a la búsqueda de las imágenes preincendio:
~~~
imagenes <- getLandsat_records(time_range = c("2021-03-01", "2021-04-01"),  
            products = "landsat_ot_c2_l2")
~~~
##### Visualizamos los resultados de la búsqueda:
```View(imagenes)```

##### Filtramos los resultados correspondientes al nivel "l1":
```imagenes <- imagenes[imagenes$level == "l1",]```

##### Visualizamos los resultados del filtrado:
```View(imagenes)```

##### Establacemos el directorio de descarga:
```set_archive("./Landsat")```

##### Descargamos las vistas previas georreferenciadas de las imágenes:
```imagenes <- get_previews(imagenes)``` 

##### Visualizamos la vista previa de la primera imagen:
```plot_previews(imagenes[1,])```

##### Visualizamos la vista previa de la segunda imagen:
```plot_previews(imagenes[2,])```

##### Tras comparar las previsualizaciones, comprobamos que la imagen más clara para nuestro análisis corresponde con la captada a fecha de 2021-03-17:

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c59.png)



##### Procedemos a la descarga de la imagene seleccionada:
~~~
url_ <- paste0('https://landsatlook.usgs.gov/gen-bundle?landsat_product_id=', 
        (imagenes$record_id[2]))

browseURL(url_)
~~~

### **1.2. Imágenes Postincendio**

##### Realizamos la misma secuencia de operaciones que en el caso preincendio. No obstante, para el evento postincendio se utilizó una extensión temporal mayor en la búsqueda, puesto que la estación otoñal podría causar un aumento en la nubosidad de la zona de estudio:
~~~
imagenes <- getLandsat_records(time_range = c("2021-09-15", "2021-10-30"), 
            products = "landsat_ot_c2_l2")
~~~
##### El resultado nos arroja 30 imágenes, filtramos a nivel L1:
```imagenes <- imagenes[imagenes$level == "l1",]```


##### Visualizamos los resultados del filtrado:
```View(imagenes)```

##### Establacemos el directorio de descarga:
```set_archive("./Landsat")```

##### Descargamos las vistas previas georreferenciadas de las imágenes:
```imagenes <- get_previews(imagenes)```

##### Visualizamos la vista previa de la primera imagen:
```plot_previews(imagenes[1,])```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c5a.png)

##### Visualizamos la vista previa de la segunda imagen:
```plot_previews(imagenes[2,])```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c5b.png)

##### Visualizamos la vista previa de la tercera imagen:
```plot_previews(imagenes[3,])```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c5c.png)


##### La imagen más clara para nuestro área de estudio es, en este caso, la imagen 1, correspondiente a la fecha 2021-09-25. Procedemos a su descarga: 

~~~
url_<-paste0('https://landsatlook.usgs.gov/gen-bundle?landsat_product_id=',
(imagenes$record_id[1]))
            
browseURL(url_)
~~~


# 2. COMBINACIÓN DE BANDAS Y GENERACIÓN DE ÍNDICES


##### Si empezamos de cero el script, tendremos que indicar de nuevo el directorio de trabajo si trabajamos desde nuestro software de escritorio:
```setwd("C:/Geodirectorio/Geodatos/Sierra_Bermeja")```

##### Seguidamente, activamos las librerias que se van a emplear:
~~~
library(raster)
library(sf)
~~~

### **2.1. Situación Preincendio**


##### Preparamos las imágenes satelitales previamente descargadas, indicando en primer lugar las bandas de la imagen que vamos a utilizar: 

~~~
# Azul
b2<-raster('./Landsat/Prefire/LC08_L2SP_201035_20210317_20210328_02_T1_SR_B2.TIF')
# Verde
b3<-raster('./Landsat/Prefire/LC08_L2SP_201035_20210317_20210328_02_T1_SR_B3.TIF')
# Rojo
b4<-raster('./Landsat/Prefire/LC08_L2SP_201035_20210317_20210328_02_T1_SR_B4.TIF')
# Infrarrojo cercano NIR
b5<-raster('./Landsat/Prefire/LC08_L2SP_201035_20210317_20210328_02_T1_SR_B5.TIF')
# Infrarrojo cercano SWIR 1
b6<-raster('./Landsat/Prefire/LC08_L2SP_201035_20210317_20210328_02_T1_SR_B6.TIF')
# Infrarrojo medio SWIR 2
b7<-raster('./Landsat/Prefire/LC08_L2SP_201035_20210317_20210328_02_T1_SR_B7.TIF')
# Infrarrojo tÃ©rmico TIRS 1
b10<-raster('./Landsat/Prefire/LC08_L2SP_201035_20210317_20210328_02_T1_ST_B10.TIF')
~~~

##### Imprimimos las variables si queremos explorar información de las mismas como resolución, extensión, crs, valores max y min de reflectividad, etc.:
```b2```

##### Vamos a recortar ahora a nuestra zona de interés, para optimizar el procesamiento. Para ello, es necesario que el shape y la imagen estén en el mismo sistema de referencia, por lo que a nuestra AOI:
```Limites.AOI <- st_read('./Limites_AOI.shp')```

##### le aplicaremos la transformación al sistema de coordenadas proyectadas WGS84 UTM 30N de la imagen Landsat:
```Limites.AOI<-st_transform(Limites.AOI,crs = 32630)```

##### Comprobamos que los limites de la zona de estudio tienen la extension y sistema de coordenadas nuevo:
~~~
extent(Limites.AOI)
crs(Limites.AOI)
~~~

##### Y ahora si, procedemos al recorte de la imagen Landsat por la extension de la zona de estudio:
~~~
b2<-crop(b2,extent(Limites.AOI))
b3<-crop(b3,extent(Limites.AOI))
b4<-crop(b4,extent(Limites.AOI))
b5<-crop(b5,extent(Limites.AOI))
b6<-crop(b6,extent(Limites.AOI))
b7<-crop(b7,extent(Limites.AOI))
b10<-crop(b10,extent(Limites.AOI))
~~~

##### Antes de combinar las bandas, observamos que la propiedad *values* de las bandas  varía entre 0 y 65.535, es decir, está descrita en valores de 16 bits. Normalmente, los valores de reflectividad describen la fracción de radiación incidente que es reflejada por una superficie en valores de 0, cuando no refleja nada, a 1, cuando refleja toda la energía incidente. Para evitar que los valores decimales de la fracción saturen la capacidad de almacenamiento de la imagen, se utiliza un factor de escalado, que transforman los valores para que queden circunscritos en 16 bits:

> Pixel[0−1]=(Pixel[0−65535]∗0.0000275)−0.2

##### Procedemos por tanto a transformar los valores de reflectividad de las bandas de 0-65535 a 0-1 usando el factor de escala:
~~~
b2<-(b2*0.0000275)- 0.2
b3<-(b3*0.0000275)- 0.2
b4<-(b4*0.0000275)- 0.2
b5<-(b5*0.0000275)- 0.2
b6<-(b6*0.0000275)- 0.2
b7<-(b7*0.0000275)- 0.2
~~~

##### Comprobamos visualizando el histograma de valores de las bandas:
~~~
par(mfrow=c(2,3))
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b6,main = "Banda 6",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c5e.png)


##### De esta forma, los valores de fluctuancia habrían de oscilar entre 0 y 1, si bien vemos que salen valores por debajo de 0. Obtener valores por debajo o por encima puede suceder en función de situaciones físicas concretas, como la presencia de zonas nevadas que saturan el sensor. Estas situaciones se pueden identificar y solucionar limitando los valores digitales de los píxeles. Antes, podemos visualizar las imágenes de las bandas una a una para explorar las posibles causas de valores anormales en los histogramas:

~~~
par(mfrow=c(1,1))
plot(b2, main = "Azul",col = grey.colors(255, start=0, end=1))
plot(b3, main = "Verde",col = grey.colors(255, start=0, end=1))
plot(b4, main = "Rojo", col = grey.colors(255, start=0, end=1))
plot(b5, main = "NIR",col = grey.colors(255, start=0, end=1))
plot(b6, main = "SWIR 1", col = grey.colors(255, start=0, end=1))
plot(b7, main = "SWIR 2",col = grey.colors(255, start=0, end=1))
~~~

##### En nuestro caso, al comprobar las imágenes, comprobamos que estos valores son muy residuales y al parecer coincidentes con una antena RTV.  Procedemos por tanto a limitar los valores de los píxeles a 0:
~~~
b2[b2<0]=0
b3[b3<0]=0
b4[b4<0]=0
b5[b5<0]=0
b6[b6<0]=0
b7[b7<0]=0
~~~

##### Comprobamos de nuevo el histograma de valores:
~~~
par(mfrow=c(2,3))
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b6,main = "Banda 6",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c60.png)




##### A continuación, vamos a unir las bandas mediante un stack para visualizar las imágenes en color natural (real) y falso color: 


##### **2.1.1. Color natural**:
~~~
# Unión de bandas rojo-verde-azul en una sola imagen:
Color_real<-stack(b4,b3,b2)

# Impresión de resultado:
Color_real

# Cambiamos de nombre a las bandas para manipularlas mejor en procesos posteriores:
names(Color_real)<-c("B4","B3","B2")

# Visualizamos la imagen:
par(mfrow=c(1,1))
plotRGB(Color_real,scale=1)
~~~

###### Podemos realizar un ajuste del histograma lineal para mejorar la imagen, oportuno si los máximos son por ejemplo menores que 0.5 como en nuestro caso:

```plotRGB(Color_real,scale=1,stretch='lin')```


![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c61.png)


##### También podemos realizar una ecualización, mediante la cual el estiramiento asigna más valores a las partes más frecuentes del histograma:

```plotRGB(Color_real,scale=1,stretch='hist')```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c63.png)


##### **2.1.2. Falso color**:

~~~
#Unión de bandas infrarrojo-rojo-verde en una sola imagen
Falso_color<-stack(b5,b4,b3)

#Visualización de la imagen en falso color
plotRGB(Falso_color,scale=1)
~~~

##### Falso color con ajuste del histograma lineal:

```plotRGB(Falso_color,scale=1,stretch='lin')```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c65.png)


##### Falso color con ajuste del histograma siguiendo una ecualización:
```plotRGB(Falso_color,scale=1,stretch='hist')```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c66.png)




##### **2.1.3. Unión de bandas**
##### Por último, vamos a realizar la unión de las bandas espectrales de Landsat 8 en una sola imagen y a combinar las mismas en RGB 6-5-3:
~~~
#Unión: 
img_preincendio<-stack(b2,b3,b4,b5,b6,b7,b10)

#Nombres de las bandas:
names(img_preincendio)

#Cambiar nombres de las bandas para hacer más manejable su representación en pasos posteriores:
names(img_preincendio)<-c("B2","B3","B4","B5","B6","B7","B10")

#Comprobación del cambio en los nombres de las bandas:
names(img_preincendio)

#Visualización de la imagen con la combinación de bandas 6-5-3:
plotRGB(img_preincendio, r=6,g=5,b=3,scale=1,stretch='lin')
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c69.png)

##### Podríamos visualizar la imagen con la combinación de bandas 6-5-3 con zoom: 
~~~
plotRGB(img_preincendio, r=6,g=5,b=3,scale=1,stretch='lin',
        ext=extent(c(483500,490000,4125000,4130000)))
~~~

##### Procedemos a guardar la imagen raster:
~~~
writeRaster(Color_real, filename = "./Landsat/Stacks_prefire/color_real.tif", 
            format= "GTiff", datatype= 'FLT4S')

writeRaster(Falso_color, filename = "./Landsat/Stacks_prefire/falso_color.tif", 
            format= "GTiff", datatype= 'FLT4S')

writeRaster(img_preincendio, filename = "./Landsat/Stacks_prefire/img_preincendio.tif", 
            format= "GTiff", datatype= 'FLT4S')
~~~



##### **2.1.4. Construcción del Índice NDVI**

##### Puede darse la situación de que distintas bandas de la imagen estén aportando la misma información sobre el terreno. En estos casos, una matriz de diagrama de dispersión puede resultar útil para comprender el comportamiento espectral de los objetos mediante la exploración de las relaciones entre capas ráster.

##### Se va a establecer un grupo de 10000 puntos al azar sobre el que realizará dicha exploración. Estudiamos las relaciones entre bandas:

~~~
# Semilla que permite la repetibilidad de la muestra seleccionada al azar
set.seed(1)

# Selección de muestra aleatoria con un tamaño de 10.000 píxeles de la imagen
sr <- sampleRandom(img_preincendio, 10000)
~~~

##### Visualizamos la relación entre la banda verde y la banda azul de la imagen a partir de la muestra seleccionada:

~~~
plot(sr[,c(1,2)], main = "Relaciones entre bandas")
mtext("Azul vs Verde", side = 3, line = 0.5)
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c6d.png)


##### Consultamos el coeficiente de correlación de Pearson entre las bandas verde y azul:
```cor(sr[,1],sr[,2])```
```0.9724398```

##### El gráfico revela que existe alta correlación entre las regiones de longitud de onda azul y verde, puesto que los valores de las bandas se sitúan en una línea, por tanto están aportando una información muy parecida de los objetos que describen en la imagen. Analíticamente, con el coeficiente de correlación se comprueba que el nivel de correlación entre las bandas es bastante cercano a 1.


##### Ahora, vamos a ver la relación entre la banda rojo y la banda infrarrojo cercano de la imagen a partir de la muestra seleccionada:

~~~
plot(sr[,c(4,3)], main = "Relaciones entre bandas")
mtext("NIR vs Rojo", side = 3, line = 0.5)
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c6e.png)


##### De nuevo, consultamos el coeficiente de correlación de Pearson:
```cor(sr[,4],sr[,3])```
```0.4485278```

##### Cuando se enfrentan los valores de las bandas del infrarrojo cercano y de rojo, se puede observar una dispersión mayor de los datos. También se comprueba que el coeficiente de correlación toma valores mucho más bajos, esto es, las bandas están menos correlacionadas entre sí y, por tanto, aportan información diferente sobre el terreno.


##### Una forma de reducir información redundante y simplificarla para detectar mejor los objetos propuestos es realizar una operación matemática entre las bandas para obtener un índice. Uno de los más empleados en teledetección es el índice NDVI, cuya formulación es:
> NDVI=NIR−R/ NIR+R

##### Se trata de una diferencia normalizada entre las bandas del rojo y el infrarrojo cercano. Calculamos pues el Índice NDVI a partir de las bandas:
```NDVI_pre<-(b5-b4)/(b5+b4)```

##### Imprimimos el resultado,
```NDVI_pre```

##### Obtenemos el histograma de valores de la imagen del Índice NDVI,
```hist(NDVI_pre)```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c6f.png)

##### Como se puede observar, hereda casi todas las características de las bandas de origen, pero los valores máximos y mínimos pueden variar en una franja entre -1 y 1. Aunque generalmente los valores del NDVI se situarán en un área pequeña de su rango potencial entre -1 y 1, en nuestro caso sí hay valores -1 y 1 (en posteriores entradas exploraremos el por qué de este resultado):

```plot(NDVI_pre)```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c70.png)

##### Normalmente, los píxeles en zonas con vegetación sana o densa reflejan más luz Infrarroja, lo que da como resultado valores altos de NDVI. Los píxeles en zonas con vegetación enferma o donde no hay vegetación absorben más luz Infrarroja, lo que da como resultado valores NDVI bajos o negativos. Según su valor NDVI, se puede identificar la vegetación en una región como vegetación densa, vegetación moderada, vegetación escasa o sin vegetación. El rango de valores NDVI que se suele emplear para cada tipo de situación:

> Vegetación densa: valor de NDVI mayor o igual a 0,5
> Vegetación moderada: valor de NDVI en el rango entre 0,4 y 0,5
> Vegetación escasa: valor de NDVI en el rango entre 0,2 y 0,4
> Sin vegetación: valor de NDVI por debajo de 0,2

##### Se puede dividir el territorio en estas las regiones de vegetación deseadas, mediante la umbralización de los valores NDVI:

~~~
tipos.veg <- reclassify(NDVI_pre, 
            c(-Inf,0.2,1, 0.2,0.4,2, 0.4,0.5,3, 0.5,Inf,4))
~~~

##### Visualizamos los resultados de la umbralización:
~~~
plot(tipos.veg,col = rev(terrain.colors(4)),
     main = 'NDVI umbralizado')
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c72.png)


##### Podemos obtener también un gráfico de distribución de tipos de vegetación:
~~~
barplot(tipos.veg,
        main = "Distribución de tipos de vegetación según NDVI",
        col = rev(terrain.colors(4)), cex.names=0.7,
        names.arg = c("Sin vegetaciÃ³n", 
                      "Vegetación escasa o enferma", 
                      "Vegetación moderada", 
                      "Vegetación densa o sana"))
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c73.png)

##### **2.1.5. Construcción del Índice NBR**

##### Otro índice ampliamente utilizado es el NBR, *Normalized Burn Ratio*. Se suele emplear para identificar zonas quemadas y su formulación es parecida a la del índice NDVI, pero emplea el infrarrojo cercano y el infrarrojo lejano o de onda corta.
> NBR=NIR−SWIR/NIR+SWIR

##### Para calcularlo se va a emplear otro procedimiento, a través de la creación de una función que describa el proceso matemático a ejecutar.
~~~
VI <- function(img, i, j) {
  bi <- img[[i]]
  bj <- img[[j]]
  vi <- (bi - bj) / (bi + bj)
  return(vi)
}
~~~
##### Donde *img* corresponde a la imagen que se quiere analizar, e *i* y *j* se refieren a las bandas que participarán en la operación. 

##### Creamos el Índice de vegetación en base a la función,
```NBR_pre <- VI(img_preincendio, 4, 6)```

##### Visualizamos el resultado;
~~~
plot(NBR_pre,
     main = "NBR Pre-Incendio",
     axes = FALSE, box = FALSE)
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c7c.png)


##### Por último, guardamos los índices generados
~~~
writeRaster(NDVI_pre,
            filename="./Landsat/Indices/NDVI_pre.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

writeRaster(NBR_pre,
            filename="./Landsat/Indices/NBR_pre.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales
~~~


### **2.2. Situación Postincendio**

##### Este proceso es análogo al anterior. De nuevo indicar que si empezamos de cero el script, es recomendable definir un directorio de trabajo (si trabajamos desde nuestro software de escritorio):
```setwd("C:/Geodirectorio/Geodatos/Sierra_Bermeja")```

##### Seguidamente, activamos las librerias que se van a emplear:
~~~
library(raster)
library(sf)
~~~

##### Cargamos las bandas de la imagen que vamos a utilizar:
~~~
# Azul
b2<-raster('./Landsat/Postfire/LC08_L2SP_201035_20210925_20211001_02_T1_SR_B2.TIF')
# Verde
b3<-raster('./Landsat/Postfire/LC08_L2SP_201035_20210925_20211001_02_T1_SR_B3.TIF')
# Rojo
b4<-raster('./Landsat/Postfire/LC08_L2SP_201035_20210925_20211001_02_T1_SR_B4.TIF')
# Infrarrojo cercano NIR
b5<-raster('./Landsat/Postfire/LC08_L2SP_201035_20210925_20211001_02_T1_SR_B5.TIF')
# Infrarrojo cercano SWIR 1
b6<-raster('./Landsat/Postfire/LC08_L2SP_201035_20210925_20211001_02_T1_SR_B6.TIF')
# Infrarrojo medio SWIR 2
b7<-raster('./Landsat/Postfire/LC08_L2SP_201035_20210925_20211001_02_T1_SR_B7.TIF')
# Infrarrojo termico TIRS 1
b10<-raster('./Landsat/Postfire/LC08_L2SP_201035_20210925_20211001_02_T1_ST_B10.TIF')
~~~


##### Imprimimos las variables si queremos explorar informacion de las mismas como resolución, extension, crs, valores max y min de reflectividad, etc.
```b2```

##### Recortamos a la zona de interes para optimizar el procesamiento, sin olvidar que el shape y la imagen han de estar en el mismo sistema de referencia:
~~~
Limites.AOI <- st_read('./Limites_AOI.shp')

Limites.AOI<-st_transform(Limites.AOI,crs = 32630)

#Comprobar:
extent(Limites.AOI)
crs(Limites.AOI)

# Y ahora sí, recortar:
b2<-crop(b2,extent(Limites.AOI))
b3<-crop(b3,extent(Limites.AOI))
b4<-crop(b4,extent(Limites.AOI))
b5<-crop(b5,extent(Limites.AOI))
b6<-crop(b6,extent(Limites.AOI))
b7<-crop(b7,extent(Limites.AOI))
b10<-crop(b10,extent(Limites.AOI))

# Transformar los valores de reflectividad de las bandas de 0-65535 a 0-1
usando un factor de escala:
b2<-(b2*0.0000275)- 0.2
b3<-(b3*0.0000275)- 0.2
b4<-(b4*0.0000275)- 0.2
b5<-(b5*0.0000275)- 0.2
b6<-(b6*0.0000275)- 0.2
b7<-(b7*0.0000275)- 0.2

# Comprobamos visualizando el histograma de valores de las bandas:
par(mfrow=c(2,3))
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b6,main = "Banda 6",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c7e.png)


~~~
# Exploramos las imágenes de las bandas una a una:
par(mfrow=c(1,1))
plot(b2, main = "Azul",col = grey.colors(255, start=0, end=1))
plot(b3, main = "Verde",col = grey.colors(255, start=0, end=1))
plot(b4, main = "Rojo", col = grey.colors(255, start=0, end=1))
plot(b5, main = "NIR",col = grey.colors(255, start=0, end=1))
plot(b6, main = "SWIR 1", col = grey.colors(255, start=0, end=1))
plot(b7, main = "SWIR 2",col = grey.colors(255, start=0, end=1))
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c7f.png)

~~~
# Limitamos los valores digitales minimos de los pixeles de la imagen a 0
b2[b2<0]=0
b3[b3<0]=0
b4[b4<0]=0
b5[b5<0]=0
b6[b6<0]=0
b7[b7<0]=0

# Nuevo Histograma de valores:
par(mfrow=c(2,3))
hist(b2,main = "Banda 2",breaks=200,xlab = "Valor del pixel")
hist(b3,main = "Banda 3",breaks=200,xlab = "Valor del pixel")
hist(b4,main = "Banda 4",breaks=200,xlab = "Valor del pixel")
hist(b5,main = "Banda 5",breaks=200,xlab = "Valor del pixel")
hist(b6,main = "Banda 6",breaks=200,xlab = "Valor del pixel")
hist(b7,main = "Banda 7",breaks=200,xlab = "Valor del pixel")
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c80.png)


##### Como hicimos para la situación preincendio, unimos las bandas mediante un stack para visualizar: 


##### **2.2.1. Color natural**

~~~
# Union de bandas rojo-verde-azul en una sola imagen
Color_real<-stack(b4,b3,b2)

# Impresion de resultado
Color_real

# Cambiamos de nombre a las bandas para manipularlas mejor en procesos posteriores
names(Color_real)<-c("B4","B3","B2")

# Visualizamos la imagen
par(mfrow=c(1,1))
plotRGB(Color_real,scale=1)

# Visualizacion con ajuste del histograma lineal para mejorar la imagen, 
plotRGB(Color_real,scale=1,stretch='lin')
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c82.png)




##### Visualizacion con ecualización:

```plotRGB(Color_real,scale=1,stretch='hist')```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c83.png)


##### **2.2.2. Falso color**
~~~
#Unión de bandas infrarrojo-rojo-verde en una sola imagen
Falso_color<-stack(b5,b4,b3)

#Visualización de la imagen en falso color
plotRGB(Falso_color,scale=1)

#Visualización de la imagen en falso color con ajuste del histograma lineal
plotRGB(Falso_color,scale=1,stretch='lin')
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c84.png)

##### Visualización siguiendo una ecualizacion:
```plotRGB(Falso_color,scale=1,stretch='hist')```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c86.png)


##### **2.2.3. Unión de bandas** 
~~~
#Unión de bandas espectrales de Landsat en una sola imagen
img_postincendio<-stack(b2,b3,b4,b5,b6,b7,b10)

#Nombres de las bandas
names(img_postincendio)

#Cambiar nombres de las bandas para hacer más manejable su representación en pasos posteriores
names(img_postincendio)<-c("B2","B3","B4","B5","B6","B7","B10")

#Comprobación del cambio en los nombres de las bandas
names(img_postincendio)

#Visualización de la imagen con la combinación de bandas 6-5-3
plotRGB(img_postincendio, r=6,g=5,b=3,scale=1,stretch='lin')

#Combinación de bandas 6-5-3 con zoom: 
plotRGB(img_postincendio, r=6,g=5,b=3,scale=1,stretch='lin',
       ext=extent(c(483500,490000,4125000,4130000)))
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c87.png)


##### Procedemos a guardar las imagenes ráster:
~~~
writeRaster(Color_real, filename = "./Landsat/Stacks_postfire/color_real.tif", 
            format= "GTiff", datatype= 'FLT4S')

writeRaster(Falso_color, filename = "./Landsat/Stacks_postfire/falso_color.tif", 
            format= "GTiff", datatype= 'FLT4S')

writeRaster(img_postincendio, filename = "./Landsat/Stacks_postfire/img_postincendio.tif",
            format= "GTiff", datatype= 'FLT4S')
~~~

##### **2.2.4. Índice NDVI**

~~~
#Cálculo del Indice NDVI a partir de las bandas
NDVI_post<-(b5-b4)/(b5+b4)

#Impresión de resultado
NDVI_post

#Histograma de valores de la imagen del Indice NDVI
hist(NDVI_post)
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c88.png)


##### Visualizamos nuestro Índice NDVI:
```plot(NDVI_post)```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c89.png)


##### Umbralizamos:
~~~
tipos.veg <- reclassify(NDVI_post, 
                        c(-Inf,0.2,1, 0.2,0.4,2, 0.4,0.5,3, 0.5,Inf,4))
~~~

##### Visualizamos los resultados de la umbralización,
~~~
plot(tipos.veg,col = rev(terrain.colors(4)),
     main = 'NDVI umbralizado')
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c8a.png)

##### Y su gráfico de distribución de tipos de vegetación:
~~~
barplot(tipos.veg,
        main = "Distribución de tipos de vegetación según NDVI",
        col = rev(terrain.colors(4)), cex.names=0.7,
        names.arg = c("Sin vegetación", 
                      "Vegetación escasa o enferma", 
                      "Vegetación moderada", 
                      "Vegetación densa o sana"))
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c8b.png)


##### **2.2.5. Índice NBR**

~~~
#Creamos la función:
VI <- function(img, i, j) {
  bi <- img[[i]]
  bj <- img[[j]]
  vi <- (bi - bj) / (bi + bj)
  return(vi)
}

#Creamos el Indice de vegetación a traves de la función:
NBR_post <- VI(img_postincendio, 4, 6)

#Visualizamos el resultado
plot(NBR_post,
     main = "NBR Post-Incendio",
     axes = FALSE, box = FALSE)
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c8d.png)


##### Finalmente, guardamos los Índices generados:
~~~
writeRaster(NDVI_post,
            filename="./Landsat/Indices/NDVI_post.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

writeRaster(NBR_post,
            filename="./Landsat/Indices/NBR_post.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales
~~~

# 3. OBTENCION DE LA SEVERIDAD DEL INCENDIO


##### Si empezamos de cero el script, tendremos que indicar de nuevo el directorio de trabajo si trabajamos desde nuestro software de escritorio:
```setwd("C:/Geodirectorio/Geodatos/Sierra_Bermeja")```

##### Seguidamente, activamos las librerias que se van a emplear:
~~~
library(raster)
library(sf)
~~~

##### Vamos a utilizar los indices NBR previamente calculados, por lo que cargamos nuestras imagenes NBR pre y post incendio:
~~~
NBR_pre<-raster('./Landsat/Indices/NBR_pre.tif')
NBR_post<-raster('./Landsat/Indices/NBR_post.tif')
~~~

##### Calculamos el delta del indice NBR (la diferencia entre las imágenes):
```dNBR <- (NBR_pre) - (NBR_post)```

##### Visualizamos el resultado:
```plot(dNBR, main="dNBR")```

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c91.png)


##### A continuacion, vamos a clasificar el mapa en niveles se severidad siguendo los umbrales del proyecto FIREMON (Lutes *et al.*, 2006)
~~~
NBR_rangos <- c(-Inf, -.50, 1, #Severidad alta
                -.50, -.25, 2, #Severidad moderada
                -.25, -.10, 3, #Severidad baja 
                -.10,  .10, 4, #No quemado
                .10,  .27, 5, #Bajo rebrote posterior al fuego 
                .27,  .66, 6, #Alto rebrote posterior al fuego
                .66, +Inf, 7) #Muy alto rebrote posterior al fuego
~~~

##### Convertimos los valores de rangos en matriz,
```class.matrix <- matrix(NBR_rangos, ncol = 3, byrow = TRUE)```


##### Umbralizamos con estos rangos, 
```dNBR_umb <- reclassify(dNBR, NBR_rangos,  right=NA)```

##### Y creamos el mapa dNBR umbralizado:

~~~
# Creamos el texto que se introducirá en la leyenda:
leyenda=c("Severidad alta",
          "Severidad moderada",
          "Severidad baja",
          "No quemado",
          "Bajo rebrote posterior al fuego",
          "Alto rebrote posterior al fuego",
          "Muy alto rebrote posterior al fuego")

# Establecemos los colores del mapa de severidad:
mis_colores=c("purple",        #Severidad alta
              "red",           #Severidad moderada
              "orange2",       #Severidad baja 
              "yellow2",       #No quemado
              "limegreen",     #Bajo rebrote posterior al fuego 
              "green",         #Alto rebrote posterior al fuego
              "darkolivegreen")#Muy alto rebrote posterior al fuego
~~~

##### Podemos visualizar el mapa con los ejes,
~~~
plot(dNBR_umb, col = mis_colores,
     main = 'dNBR umbralizado')
~~~
![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c93.jpeg)


##### O sin ejes y con la leyenda creada:
~~~
plot(dNBR_umb, col = mis_colores,legend=FALSE,box=FALSE,axes=FALSE,
     main = 'Severidad del incendio')
legend("topright", inset=0.05, legend =rev(leyenda), fill = rev(mis_colores), cex=0.5) 
~~~

![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c92.png)


##### Guardamos los Rasterlayers dNBR generados:
~~~
writeRaster(dNBR,
            filename="./Landsat/Indices/dNBR.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales

writeRaster(dNBR_umb,
            filename="./Landsat/Indices/dNBR_umb.tif",
            format = "GTiff", # guarda como geotiff
            datatype='FLT4S') # guarda en valores decimales
~~~

##### Es importante tener en cuenta que la tabla de umbralización anterior es una interpretación cuantitativa de lo que realmente significan los resultados de dNBR. El término “severidad” es un término cualitativo que podría cuantificarse de diferentes formas. Por ejemplo, ¿quién puede decir que un valor de 0.5 no podría ser representativo de “alta gravedad” frente a 0.660? Por eso, la mejor manera de asegurarse de que la umbralización representa lo que realmente está sucediendo en el suelo en términos de severidad del fuego es verificar las condiciones reales en el suelo.

##### Para evaluar cómo ha evolucionado la vegetación tras el incendio es muy útil utilizar una plataforma de computación como Google Earth Engine para procesar imágenes de satélite y otros datos geoespaciales y de observación, ya que ofrece la potencia computacional necesaria para analizar imágenes de varios años. Nuestro evento en concreto es muy reciente, por lo que utilizaremos esta herramienta con otro evento como ejemplo en próximos ejercicios.

(https://code.earthengine.google.com/731befd948a1743943baaf352242c0d6)


![](https://codimd.s3.shivering-isles.com/demo/uploads/60ef7cbdee8520724c6968c96.png)


