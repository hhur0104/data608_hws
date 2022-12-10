library(ggplot2)
library(shiny)
library(plotly)
library(htmlwidgets)



sortby <- c("Total Prisoner","Per 100K Rate", "Biggest GDPs")
fixedPage(
     fluidRow(
       column(12,
              headerPanel("U.S. Prison Data Dashboard"),
              mainPanel(p("This dashboard summarizes imprisonment data made available by PrisonStudies.org, World Prison Brief and Bureau of Justice Statistics.
                           This dashboard offers users a way to engage with the data to make comparison of prison populations and 
                           their trends among different set of nations.", style = "font-size:18px;"), width="150%")      
       )
     ),
     fluidRow(
       column(12,
              headerPanel('U.S. vs. Others'),
              p("U.S. is leading the incarceration rate in the world even though the changing curve is in a downward slope since few years ago.
                Also, imprisonment rate per 100,000 residents is even bigger than the rate of the small populated nations where the rate 
                has been bloated out of scale due to the normalization. On top of that, prisons in the U.S. is running out of spaces 
                even though it has the largest number of prison facilities in the world. Compared to the top 12 GDP nations, 
                the number of prisoners in the U.S. is comparable to that of more authoritative 
                governments like China, Russia, India and Brazil.", style = "font-size:18px;")
              )
       ),
     fluidRow(
       column(6, 
          mainPanel(
                selectInput('sort_by', 'Sort By', c("Total Prisoner","Per 100K Rate", "Biggest GDPs"), selected='Total Prisoner', width = 150),
                plotlyOutput(outputId = "p1", width = "170%", height = "500px")
          )
       ),
       column(6,
          mainPanel(
                fluidRow(plotlyOutput(outputId = "p2", width="150%", height="330px")),
                fluidRow(plotlyOutput(outputId = "p3", width="150%", height="300px"))
          )
       )
     ),
     fluidRow(
       column(12,
              headerPanel("U.S. in Depth"),
              mainPanel(p("Below we can observe the number of prionsers in the U.S. has shown sharp surge starting from 1980s which lasted until late 2000s.
                           Which may have been driven by Reagan Administration's effort to reduce drug related crimes. Many criticizes that such effort focused more on 
                           shutting down drug supplier cartels using brute police force and harsh punishments and less on providing quality 
                           care and solution for addiction problem related to drugs.", style = "font-size:18px;"),
                        p("To see how much of the prison populations were related to drug use, I looked for a data set that tells about offense committed by the inmates. 
                          But disappoingtly I failed to locate the data to back this. I located data from Bureau of Justice Statistics that show the trends of offense committed by prisoners in state 
                          and federal prisons in last 20 or so years in the United States. Trending curves below summarizes that most of the prisoners are 
                          in state prisons and most of them committed Violent crimes.", style = "font-size:18px;")
                        ,width="150%")      
       )
     ),
     fluidRow(
       column(10, offset=1,
              mainPanel( plotlyOutput(outputId = "p4", width = "160%"))
              )
     ),
     fluidRow(
       column(12,
              mainPanel( plotlyOutput(outputId = "p5", width = "150%"))
       )
     ),
     fluidRow(
       column(12,
              headerPanel("On Data & Limitations"),
              mainPanel(p("Data used in above visualizations are coming from three different sources. Data needed no preprocessing such as null handling or normalizations.
                          Only processing needed was matching the indexes because data sets used slightly different format of country names.
                          Since I am only using the prison data for 38 countries picked by ranks per categories, this processing was merely 
                          examining list of names and spotting out unmatched names.", style = "font-size:18px;"),
                        p("It is important to point out that countries included in above visualizations have different levels of transparency on this types of data. 
                          Also, authoritative governments may not invest as much effort to make this data accurate or updated as democratic societies in developed countries.
                          For instance, Occupancy level of prison facilities in China is not available. On top of that, the number of prisoners do not include those
                          who are in controversial political or refugee camps like Xinjiang, China. ", style = "font-size:18px;"),
                        p("Initially, the objective of this project was to provide visuals that offers a way to compare the impact of drug usage punishments in different countries 
                          to their prison populations to see if U.S is suffering from high prison population due to its harsh lined punishments on drug related crimes.
                          But unfortunately, such data is hard to locate and may be considerably harder to collect. However, upon acquirement of such data, 
                          the plots above with its linked interactions will become much more potent in comparing 
                          and contrasting the narratives behind the prison population for many countries.", style = "font-size:18px;"),
                        width="150%")      
       )
     )
     ,
     fluidRow(
       column(12,
              headerPanel("Reference"),
              mainPanel(p("Coyne, Christopher J, and Abigail R Hall. “Four Decades and Counting: The Continued Failure of the War on Drugs.” Cato.org, 17 Apr. 2017,
                          https://www.cato.org/policy-analysis/four-decades-counting-continued-failure-war-drugs.", style="font-size:15px;"),
                        p("“A History of the Drug War.” Drug Policy Alliance, 
                          https://drugpolicy.org/issues/brief-history-drug-war.", style="font-size:15px;"),   
                        p("“Prisoner Characteristics.” https://csat.bjs.ojp.gov/quick-tables. Accessed 10 Dec. 2022. ", style="font-size:15px"),
                        p("“The 'War on Drugs' Has Failed, Commission Says.” The Leadership Conference Education Fund, 15 Mar. 2019, 
                          https://civilrights.org/edfund/resource/the-war-on-drugs-has-failed-commission-says", style="font-size:15px;"),
                        p("“World-Prison-Brief-Data.” https://www.prisonstudies.org/world-prison-brief-data. 
                         Accessed 10 Dec. 2022.", style="font-size:15px;"))
       )
     )
)