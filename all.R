rm(list = ls())

source("https://raw.githubusercontent.com/javiercara/DisRegETSII/refs/heads/master/R/ICplot.R")
source("https://raw.githubusercontent.com/javiercara/DisRegETSII/refs/heads/master/R/interIC.R")

notas = read.table('https://raw.githubusercontent.com/Edu-Caro/datos/refs/heads/main/notas.txt', header = TRUE)
rendimiento = read.table('https://raw.githubusercontent.com/Edu-Caro/datos/refs/heads/main/DdE8.txt', header = TRUE)

# Verificación del entorno
cat("\nObjetos cargados en el entorno:\n")
print(ls())

# Comprobaciones específicas
if (exists("ICplot") && exists("interIC") && exists("notas") && exists("rendimiento")) {
  cat("\nTodos los objetos necesarios se han cargado correctamente.\n")
} else {
  cat("\nAdvertencia: Faltan algunos objetos necesarios en el entorno.\n")
}

# Vista previa de los datos cargados
cat("\nVista previa de los datos 'notas':\n")
print(head(notas))

cat("\nVista previa de los datos 'rendimiento':\n")
print(head(rendimiento))
