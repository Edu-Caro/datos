cat("=================================\n")
cat("=================================\n")
cat("=================================\n")
cat('\014')  
rm(list = ls())  
cat("=================================\n")
cat("  Environment borrado.\n")
 

#===============================================================================
#===============================================================================
bbdd_nombres <- c(
  "Alumnos", "Alumnos_cabecera", "CUERPO", "Calles", "Cavendish", "Centeno", "DdE8",
  "Forbes2000", "Heyl", "MWE_nord", "Michelson_Newcomb", "Nitrogeno", "NotasTFM",
  "Oldfaithful", "Olimpiada", "Prueba", "SEOUL1988", "SEOUL1988_comma", "SEOUL_NAMES",
  "Termometros", "Tryptone.dat", "USAcrime", "USAcrime_comma", "aditivos",
  "autobus", "battery", "body", "cars", "cerezos",
  "coches", "coches2", "datos", "demog", "desint", "drug", "espesor",
  "experimento", "fev", "fluorita", "forbes", "fotos", "gafas", "gsi", "iq", "madrid_2021", "peso", "pima", "pinos",
  "pinosycerezos", "pintura", "possum", "prestige", "prod", "quimico", "radon",
  "renta", "students", "tabaco", "tuffts", "venenos")

bbdd_nombres <- c('cars', 'fev', 'madrid_2021', 'SEOUL1988')

bbdd_nombres <- sub("\\.txt$", "", bbdd_nombres)

#===============================================================================
#===============================================================================



#===============================================================================
# Cargar funciones
source("https://raw.githubusercontent.com/javiercara/DisRegETSII/refs/heads/master/R/ICplot.R")
source("https://raw.githubusercontent.com/javiercara/DisRegETSII/refs/heads/master/R/interIC.R")

# Cargar datos en bucle usando los nombres para construir las URLs
for (nombre in bbdd_nombres) {
  url <- paste0("https://raw.githubusercontent.com/Edu-Caro/datos/refs/heads/main/", nombre, ".txt")
  assign(nombre, read.table(url, header = TRUE))
}
rm(list = c('nombre', 'url'))
#===============================================================================

#===============================================================================
if (all(sapply(c("ICplot", "interIC", bbdd_nombres), exists))) {
  cat("\nTodos los objetos necesarios se han cargado correctamente.\n")
} else {
  cat("\nAdvertencia: Faltan algunos objetos necesarios en el entorno.\n")
}
#===============================================================================


#===============================================================================
rm(list = c('bbdd_nombres'))
cat("---------------------------------\n")
cat("\nObjetos cargados:\n")
invisible(lapply(ls(), function(x) cat(paste0(" > ", x, "\n"))))
cat("=================================\n")
#===============================================================================
