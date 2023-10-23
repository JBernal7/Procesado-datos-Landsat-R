
# Procesamiento de Datos Landsat en R
Este repositorio proporciona un script que utiliza R para descargar, procesar y analizar datos de Landsat en el contexto de los incendios forestales en la Sierra Bermeja, una de las regiones más amenazadas por los riesgos asociados al agua y a los efectos del cambio climático en Málaga.

Este script proporciona una forma de identificar y caracterizar las áreas quemadas en la Sierra Bermeja a través del uso de ortofotos generadas con imágenes de teledetección antes y después del incendio, así como la aplicación del índice de vegetación de diferencia normalizada (NDVI) y el índice normalizado de área quemada (NBR). El objetivo final es obtener la severidad del incendio a través del delta del índice NBR (dNBR).

## Requisitos
- R y RStudio instalados
- Paquetes de R necesarios:
    - `sf`
    - `devtools`
    - `getSpatialData`
    - `raster`

## Uso
### Paso 1: Obtención de imágenes Landsat 8
Las imágenes Landsat se pueden obtener utilizando las funciones de descarga disponibles en el script. Se proporcionan ejemplos para la obtención de imágenes antes y después del incendio.

### Paso 2: Combinación de bandas y generación de índices
Una vez obtenidas las imágenes Landsat, el script ofrece funciones para combinar diferentes bandas de la imagen y para generar índices relevantes para la caracterización del terreno, como el NDVI y el NBR.

### Paso 3: Obtención de la severidad del incendio
Finalmente, el script proporciona funciones para calcular la severidad del incendio a partir del dNBR. Los resultados se pueden visualizar y analizar directamente en R.

Para utilizar estos ejercicios, puedes clonar este repositorio y abrir los archivos en tu entorno R preferido. No he actualizado estos ejercicios desde que los creé, así que considera esto como un archivo de mi viaje de aprendizaje más que como un recurso de aprendizaje actualizado.

## Contribución
Dado que este repositorio está destinado a ser un archivo personal (registro de las actividades realizadas en el marco del Máster Oficial [Geoforest](https://mastergeoforest.es/) ), no estoy buscando contribuciones activamente. Sin embargo, si encuentras algún error o tienes alguna sugerencia de mejora, no dudes en abrir un issue.

## Referencias
[Landsat Program]: https://www.usgs.gov/land-resources/nli/landsat](https://landsat.gsfc.nasa.gov/
[R Project for Statistical Computing]: https://www.r-project.org/
[Lutes, D. C., et al. (2006). FIREMON: Fire effects monitoring and inventory system. Gen. Tech. Rep. RMRS-GTR-164-CD. Fort Collins, CO: U.S. Department of Agriculture, Forest Service, Rocky Mountain Research Station. p. CD.]: https://www.researchgate.net/publication/228690001_FIREMON_Fire_effects_monitoring_and_inventory_system



Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg

