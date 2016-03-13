shinyUI(fluidPage(   

   titlePanel("Plotting distribution of p-values from a gene expression top table, considering up- or down- log Fold Change direction"),

   hr(),
   
   sidebarLayout(

      sidebarPanel(

         p('Please, use the demo .tsv file provided',
           a(href = 'http://raw.githubusercontent.com/ferran-brianso/datasciencecoursera/master/demo_data.tsv','here'), 
           '(save it locally and then upload)',
           'or try your own file',
           '(using the same column names!):'),

         fileInput('file1', 'Choose file to upload',
                   accept = c('text/csv',
                              'text/comma-separated-values',
                              'text/tab-separated-values',
                              'text/plain',
                              '.csv',
                              '.tsv')),
         
         tags$hr(),

         p('Set format parameters of your',
           'input data file, if these are not',
           'as the default settings:'),
         
         radioButtons('sep', 'Separator',
                      c(Tab='\t',
                        Comma=',',
                        Semicolon=';'),
                      '\t'),
         
         radioButtons('dec', 'Decimal',
                      c(Point='.',
                        Comma=','),
                      '.'),
         
         radioButtons('quote', 'Quote',
                      c(None='',
                        'Double Quote'='"',
                        'Single Quote'="'"),
                      '')
      ),
      mainPanel(
         
         sliderInput('thrFC', 'Set Fold Change Threshold', 0, 2, 1, step=0.10),
         div("Threshold value is used to distinguish up- and down- regulated genes", 
             style = "color:darkgray"),
         
         hr(),
         
         radioButtons('fdr', 'Use adjusted p-values (FDR)?',
                      c(No=FALSE,
                        Yes=TRUE),
                      FALSE),
         div("If 'Yes' checked, column 'adj.P.Val' will be used instead of 'P.Value'", 
             style = "color:darkgray"),
         
         hr(),                  
         
         plotOutput('plot'),
         
         hr(),         
         
         tableOutput('contents')
      )
      
   )
   
))
