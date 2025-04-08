#--------------------- Workshop 5 Tidy Data ---------------------------------


beetles1 <- read.csv("beetles_v1.csv")
beetles1

beetles2 <- read.csv("beetles_v2.csv")
beetles2

beetles3 <- read.csv("beetles_v3.csv")
beetles3

beetles4 <- read.csv("beetles_v4.csv")
beetles4

#Q. Issues with the data sets:
#1. each column is not a variable - should be a species column
#2. each column is not a variable - beetles2 has january and february as columns, month should be a single column
#3. each column is not a variable - beetles3 has sites as columns but site should be a single column with rows as site1-5
#4. 4 is good

usites <- unique(beetles1$Site) #gets all unique values 
length(usites) #counts the length of the vector

colnames(beetles1)[3:ncol(beetles1)] #counting number of species


#Q: Use the ‘unique’ and ‘length’ functions to count the number of species using ‘beetles3’: how many beetle species are there?
uspecies <- unique(beetles3$spp)
length(uspecies)

#Q: Which ‘beetles’ table lets you count all unique values for Sites, Months and Species?
usites <- unique(beetles4$Site)
length(usites)
uspecies <- unique(beetles4$spp)
length(uspecies)
umonths <- unique(beetles4$Month)
length(umonths)
#beetles 4


str() 
summary()
head()
View()   # <-- this one is in Rstudio only

#Q: Take a look at the ‘beetles4’ table with each of these functions
str(beetles4)
summary(beetles4)
head(beetles4)
#str shows the type of data, tells how many observations and gives some as demonstration
#summary tells how many observations/length of data set and provides summary stats for numerics
#head shows the data structure - but not all of the data



# Reading Tables ----------------------------------------------------------

beetlesdf <- read.table("beetles_read_1.csv", sep=",",header=T)  # notice how we set the separator
#read.table is more complex than read.csv but more flexible

read.table("beetles_read_2.txt", header=TRUE, sep ='\t')
#\t is to specify separation by tabs

read.table("beetles_read_3.txt", header=TRUE, sep='\t', skip =1)
#skip = specifies what to skip when reading in, skip 1 skips the first row/heading
?read.table()


# Fill --------------------------------------------------------------------
install.packages(tidyr)
library(tidyr)

?fill 
fill(beetlesdf,Site)  
beetlesdf <- fill(beetlesdf,Site) #careful - this is a common source of errors

beetlesdf %>% fill(Site) #replaces top to bottom, using a pipe example

beetlesdf2 <- read.table('beetles_read_4.txt')
beetlesdf2 <- read.table("beetles_read_4.txt", sep = '\t', header=T, na.strings = '-')
#na.strings specifies what NA is equivalent to, blanks in this are '-' so they are equivalent to NA
fill(beetlesdf2,Site)
beetlesdf2 <- fill(beetlesdf2,Site)


# Pipe --------------------------------------------------------------------

beetlesdf <- read.table("beetles_read_1.csv", sep=",",header=T) %>% fill(Site)
#piping takes the output from the first function and puts it straight into the next
#use %>% to pipe


# Pivoting ----------------------------------------------------------------

pivot_longer(data=beetlesdf, cols = c("blue_beetle", "green_beetle",
                                      "purple_beetle", "red_beetle",
                                      "brown_beetle", "black_beetle",
                                      "orange_beetle", "white_beetle"),
             names_to="species")

#using pivot longer to make our column names become variables

beetlesdf <- pivot_longer(data=beetlesdf, cols = c(3:10),names_to="species")


#There’s lots of functions like ‘starts_with()’, ‘ends_with()’, ‘last_col()’, ‘contains()’, ‘matches()’
#These can replace your list of columns like this:
beetlesdf <- pivot_longer(data=beetlesdf, cols = contains("blue"))

#Q. Look through the possible ways of selecting columns, can you find a selection helper that selects all your values?
beetlesdf <- pivot_longer(data=beetlesdf, cols = matches('beetle'),
                          names_to = 'Species')

?pivot_longer
#Q. Using the help page for pivot_longer, figure out how to change ‘value’ to ‘count’
#change values_to = 'value' to values_to = 'count'
beetlesdf <- pivot_longer(data=beetlesdf, values_to = 'count', cols = matches('beetle'),
                          names_to = 'Species')



# Pivoting Wider ---------------------------------------------------------

casesdf <- read.table("WMR2022_reported_cases_1.txt", 
                      sep="\t", header = T, 
                      na.strings = '') %>% #using na.strings to specify there are nulls to be filled
  fill(country)
casesdf

casesdf <- pivot_wider(casesdf,names_from="method",values_from ="n")
casesdf

sessionInfo()


# Extra Challenge ---------------------------------------------------------

#Q1.
casesdf2 <-read.table("WMR2022_reported_cases_2.txt",sep="\t", na.strings = '',
           header = T) %>% 
  fill(country)
casesdf2

#Q2.
casesdf2 <- pivot_longer(data=casesdf2, cols = contains('20'))
casesdf2

#Q3.
casesdf2 <- pivot_wider(casesdf2, names_from="method",values_from ="value")

#Q4.
casesdf2 <-read.table("WMR2022_reported_cases_2.txt",
                      sep="\t", 
                      na.strings = '',
                      header = T) %>% 
  fill(country) %>%
  pivot_longer(
    cols = contains('20'),
    names_to='year', 
    values_to = 'cases') %>%
  pivot_wider(
    names_from="method",
    values_from ="cases")
casesdf2  

?pivot_longer
