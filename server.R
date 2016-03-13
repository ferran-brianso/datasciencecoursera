library(Hmisc)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output) {
   
   ## Loads data and plots the distribution of p-values colored by fold change direction
   output$plot <- renderPlot({

      inFile <- input$file1
      if (is.null(inFile)) return(NULL)
      
      data <- read.csv2(inFile$datapath, header = TRUE,
                        sep = input$sep, dec = input$dec, quote = input$quote)
      thr.fc <- input$thrFC
      
      up <- which(data$logFC >= thr.fc)
      down <- which(data$logFC <= -thr.fc)
      und <- which(data$logFC > -thr.fc & data$logFC < thr.fc)
      
      data$FC.direction <- rep("und.", dim(data)[1])
      data$FC.direction[up] <- "up"
      data$FC.direction[down] <- "down"
      data$FC.direction <- as.factor(data$FC.direction)

      colors <- c("darkgray")
      if ("down" %in% levels(data$FC.direction)) {colors <- c("green", colors)}
      if ("up" %in% levels(data$FC.direction)) {colors <- c(colors, "magenta")}
      if (!("und." %in% levels(data$FC.direction))) {colors <- c("green", "magenta")}
      
      data$P.Values <- cut2(data$P.Value, cuts=c(0.001, 0.01, 0.05, 0.10))
      data <- data[which(!is.na(data$P.Values)),]

      data$FDR.Values <- cut2(data$adj.P.Val, cuts=c(0.01, 0.05, 0.10, 0.25))
      data <- data[which(!is.na(data$FDR.Values)),]      

      if (input$fdr){
         p <- ggplot(data, aes(x=FDR.Values, fill=FC.direction)) + 
            geom_histogram() + 
            ggtitle("Distribution of adjusted p-values\nby logFC direction") + 
            scale_fill_manual(values=colors) + 
            scale_x_discrete(labels=c("<0.01", "<0.05", "<0.10", "<0.25", ">=0.25"))
         print(p)
      }else{
         p <- ggplot(data, aes(x=P.Values, fill=FC.direction)) + 
            geom_histogram() + 
            ggtitle("Distribution of p-values\nby logFC direction") + 
            scale_fill_manual(values=colors) + 
            scale_x_discrete(labels=c("<0.001", "<0.01", "<0.05", "<0.10", ">=0.10"))
         print(p)
      }
      
   })
})