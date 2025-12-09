ui <- fluidPage(
  titlePanel("Identificación de dígitos - Análisis de Datos"),
  tags$div(
    style = "display:flex; gap:20px; align-items:flex-start;",
    tags$div(
      tags$canvas(id = "drawCanvas", width = 280*1.5, height = 280*1.5,
                  style = "border:1px solid #000; touch-action: none;"),
      br(),
      actionButton("clear", "Limpiar"),
      actionButton("export", "Identificar")
    ),
    tags$div(
      verbatimTextOutput("status"),
      plotOutput("preview", width = 140, height = 140)
    )
  ),
  # JS incrustado para no necesitar ficheros externos
  tags$script(HTML("
  (function(){
    var canvas = document.getElementById('drawCanvas');
    var ctx = canvas.getContext('2d');
    var drawing = false;
    var last = {x:0, y:0};
    // Inicializar fondo blanco
    ctx.fillStyle = '#ffffff'; ctx.fillRect(0,0,canvas.width, canvas.height);
    ctx.lineWidth = 18; ctx.lineCap = 'round'; ctx.strokeStyle = '#000000';

    function getPos(e){
      var rect = canvas.getBoundingClientRect();
      var x = (e.touches ? e.touches[0].clientX : e.clientX) - rect.left;
      var y = (e.touches ? e.touches[0].clientY : e.clientY) - rect.top;
      return {x:x, y:y};
    }

    canvas.addEventListener('pointerdown', function(e){
      drawing = true; last = getPos(e);
    });
    canvas.addEventListener('pointermove', function(e){
      if (!drawing) return;
      var p = getPos(e);
      ctx.beginPath();
      ctx.moveTo(last.x, last.y);
      ctx.lineTo(p.x, p.y);
      ctx.stroke();
      last = p;
    });
    window.addEventListener('pointerup', function(){ drawing = false; });

    // Handler para limpiar desde R
    Shiny.addCustomMessageHandler('clearCanvas', function(msg){
      ctx.fillStyle = '#ffffff'; ctx.fillRect(0,0,canvas.width, canvas.height);
    });

    // Exportar: escalar a 28x28 y enviar array de 784 valores (0..255)
    Shiny.addCustomMessageHandler('export28', function(msg){
      var tmp = document.createElement('canvas');
      tmp.width = 28; tmp.height = 28;
      var tctx = tmp.getContext('2d');
      // Dibujar el canvas grande en el pequeño (browser hace el muestreo)
      tctx.drawImage(canvas, 0, 0, 28, 28);
      var id = tctx.getImageData(0,0,28,28).data; // RGBA
      var gray = [];
      for (var i = 0; i < id.length; i += 4) {
        var r = id[i], g = id[i+1], b = id[i+2];
        var v = Math.round(0.299*r + 0.587*g + 0.114*b); // 0..255
        // Si quieres invertir (fondo 0, trazo 255), descomenta la siguiente linea:
        // v = 255 - v;
        gray.push(v);
      }
      Shiny.setInputValue('mnist_pixels', gray, {priority: 'event'});
    });

  })();
  "))
)

server <- function(input, output, session) {
  # reactiveValues al principio
  rv <- reactiveValues(last_mat = NULL)
  
  # Al pulsar botones en R, enviamos mensajes al JS
  observeEvent(input$clear, {
    session$sendCustomMessage("clearCanvas", list())
    output$status <- renderText("Lienzo limpiado.")
    output$preview <- renderPlot(NULL)
  })
  
  observeEvent(input$export, {
    session$sendCustomMessage("export28", list())
  })
  
  observeEvent(input$mnist_pixels, {
    pix <- as.numeric(input$mnist_pixels) 
    pix <- 255 - pix
    if (is.null(pix) || length(pix) != 784) {
      output$status <- renderText("Error: no llegaron 784 valores.")
      return()
    }
    
    # Guardar VECTOR en el workspace global
    assign("mnist_global_vector", pix, envir = .GlobalEnv)
    
    # Convertir a matriz 28x28: navegador -> fila 1 = arriba
    mat28 <- matrix(pix, nrow = 28, byrow = TRUE)
    
    # Preparar matriz para mostrar con image()
    mat28_plot <- t(mat28)[, 28:1]
    mat28_plot = 255 - mat28_plot
    
    # Actualizar reactiveValue
    rv$last_mat <- mat28
    
    # Intentar predecir con el modelo randomForest si existe
    library(randomForest)
    
    pred_text <- "Predicción: (modelo no disponible)"  
    
    rf <- readRDS(gzcon(url("https://raw.githubusercontent.com/Edu-Caro/datos/main/bosque.rds", "rb")))
      if (!is.null(rf)) {
        new_row <- as.data.frame(t(as.numeric(pix)))
        colnames(new_row) <- paste0("X", 1:784)
        pred <- tryCatch(predict(rf, newdata = new_row), error = function(e) NA)
        if (!is.na(pred)) pred_text <- paste("Predicción:", as.character(pred)) else pred_text <- "Predicción: (error al predecir)"
      } else {
        pred_text <- "Predicción: (error leyendo modelo)"
      } 
     
    
    output$status <- renderText(sprintf("Recibidos %d píxeles. Min=%d Max=%d. Guardado en .GlobalEnv$mnist_global_vector\n%s",
                                        length(pix), min(pix), max(pix), pred_text))
    
    output$preview <- renderPlot({
      par(mar = c(1,1,4,1))  # un poco más de margen superior para la cajita
      image(1:28, 1:28, mat28_plot, col = gray((0:255)/255), axes = FALSE, useRaster = TRUE)
      abline(h = seq(0.5, 28.5, 1), v = seq(0.5, 28.5, 1), col = "grey70", lwd = 0.5)
      # Cajita con la predicción: la colocamos justo encima del gráfico
      legend(x = 14, y = 29, legend = pred_text, bty = "o", xjust = 0.5, yjust = 0,
             cex = 1.1, xpd = NA, bg = "white")
    })
  })
}

shinyApp(ui, server)
