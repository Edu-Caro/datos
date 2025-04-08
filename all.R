# Borrar consola
cat('\014')  # Este comando limpia la consola en RStudio

# Borrar entorno
rm(list = ls())

# Mensaje de entorno borrado
cat("=================================\n")
cat("  Environment borrado.\n") 
cat("=================================\n")

# Cargar funciones
source("https://raw.githubusercontent.com/javiercara/DisRegETSII/refs/heads/master/R/ICplot.R")
source("https://raw.githubusercontent.com/javiercara/DisRegETSII/refs/heads/master/R/interIC.R")

# Cargar datos
notas = read.table('https://raw.githubusercontent.com/Edu-Caro/datos/refs/heads/main/notas.txt', header = TRUE)
rendimiento = read.table('https://raw.githubusercontent.com/Edu-Caro/datos/refs/heads/main/DdE8.txt', header = TRUE)

# Verificación del entorno
cat("=================================\n")
cat("\nObjetos cargados en el entorno:\n")
lapply(ls(), function(x) cat(paste0(" > ", x, "\n")))
# Comprobaciones específicas
if (exists("ICplot") && exists("interIC") && exists("notas") && exists("rendimiento")) {
  cat("\nTodos los objetos necesarios se han cargado correctamente.\n")
} else {
  cat("\nAdvertencia: Faltan algunos objetos necesarios en el entorno.\n")
}
cat("=================================\n")

# Vista previa de los datos cargados
cat("---------------------------------\n")
cat("\nVista previa de los datos 'notas':\n")
print(head(notas))
cat("---------------------------------\n")
cat("\nVista previa de los datos 'rendimiento':\n")
print(head(rendimiento))
cat("---------------------------------\n")
