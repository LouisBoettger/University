install.packages('tidyr')
install.packages('dplyr')
library(tidyr)
library(dplyr)


dataX <- read.table("dataset_X.csv", sep=",",header=T)

?select

dataX %>% select(1:11) #clumsy approach
dataX %>% select(3:11)

#Use the matches function to generate the same table as you did above
dataX %>% select(c('Site','Month',matches('_')))
?matches

dataX %>% select(!Month) #! is the negotion operator - selects all but that 

dataX %>% select(!matches('X'))#selecting everything that doesnt have an X



# Filter ------------------------------------------------------------------

#remove rows (all sites) that were found to have less than 9 of Cat_3
dataX %>% 
  filter(Cat_3 > 9) #select subsets of rows based on specific criteria

dataX %>% 
  filter(Cat_3 > 9  & Dog_3 > 2) #combining columns using &

#When you include the two species (Cat_3 and Dog_3), notice how the number of rows decreases (in comparison to when Cat_3 was used alone)? Do you understand why?
#it has removed the row where dog_3 had 2 

#Write your own script that selects only the row(s) for which Cat_3 has greater than 7 samples in the month of January
dataX %>%
  filter(Cat_3 > 7) %>%
  filter(Month=='January') #filtering the cats first and then the month

#Instead of and ( & ) try to figure out how to make an or statement. What is the or symbol? Try to write the above code so that it selects only the row(s) for which Cat_3 has greater than 7 samples in the month of January or November
dataX %>%
  filter(Cat_3 > 7) %>%
  filter(Month=='January' | Month =='November')


# Rename ------------------------------------------------------------------

dataX %>% rename(c(Dag_2=Dog_2,
                   cap_2=Cat_2,
                   ...)) #long, could use functions to be faster

?rename
fixNamesDogs <- function(x) {gsub("ag","og",x)}
fixNamesCats <- function(x) {gsub("ap","at",x)}

dataX <- dataX %>% 
  rename_with(fixNamesDogs, .cols = matches('ag','og', ignore.case=FALSE)) %>% 
  rename_with(fixNamesCats, .cols = matches('ap','at', ignore.case=FALSE)) %>% 
  rename_with(tolower, .cols = everything())
#using rename with then specify what function, then what columns and what in the columns
#ignore.case=FALSE makes it consider case
#tolower is a function that changes capitals to lowercase
?matches
     


# First Pivot -------------------------------------------------------------

?pivot_longer        
dataX <- dataX %>% 
  pivot_longer(matches('_'), names_to = 'spp', values_to = 'count') %>% 
  select(!matches('x'))


# Separate ----------------------------------------------------------------

dataX %>% separate_wider_delim("spp","_",
                                 names=c("animal",
                                         "tag"))


# Mutate ------------------------------------------------------------------

?mutate
dataX %>% mutate("spp"=gsub("_"," ",spp)) #In the case of our dog/cat table we could replace our underscore with something like this

casesdf <- read.table("WMR2022_reported_cases_3.txt",
                      sep="\t",
                      header=T,
                      na.strings=c("")) %>% 
  fill(country) %>% 
  pivot_longer(cols=c(3:14),
               names_to="year",
               values_to="cases") %>%
  pivot_wider(names_from = method,
              values_from = cases)

?rename

casesdf <- rename(casesdf, c('suspected' = 'Suspected cases',
                  'examined' = 'Microscopy examined',
                  'positive' ='Microscopy positive'))


str(casesdf)
head(casesdf)

#Use mutate and gsub to remove the ‘X’ from every value in the years column
casesdf <- casesdf %>% mutate('year'=gsub('X','',year))
casesdf$year <- as.numeric(casesdf$year)
str(casesdf)



unique(casesdf$country)

#That check above revealed that some countries have footnote numbers. Try the same application of unique to a different column to see if they have other footnotes/symbols.
unique(casesdf$examined)

#can you use mutate and gsub to remove all numbers from this column?
casesdf <- casesdf %>% mutate('country'=gsub('[1-9]','',country))


#can you use mutate and gsub to remove all non-number characters from the suspected column?
unique(casesdf$suspected)
casesdf %>% mutate('suspected'=gsub('[^1-9]','',suspected))
#using ^ inside [] makes it specify everything other than 
casesdf$suspected <- as.numeric(casesdf$suspected)

clean_number <- function(x) {as.numeric(gsub("[^0-9]","",x))}

?across

casesdf <- casesdf %>% mutate(across(c(suspected,examined,positive),clean_number))

#tidy_select way to select everything except ‘country’
casesdf %>% mutate(across(!country,clean_number)) 

#Use the mutate function together with round function to make a new column for ‘test_positivity’ rounded to two significant digits and add it to your table
casesdf<-casesdf %>% 
  mutate(across(!country,clean_number)) %>%
  mutate(test_positivity = round(positive / examined,2)) 


# Factors -----------------------------------------------------------------

#use as.factor and mutate to convert country to a factor
casesdf <- casesdf %>% mutate(country = as.factor(country)) 


#Use mutate and gsub to replace ‘Eritrae’ with ‘Eritrea’; then convert it to a factor
casesdf <- casesdf %>% 
  mutate(country = gsub("Eritrae",
                        "Eritrea",
                        country)) %>%
  mutate(country = as.factor(country)) 




# Write To File -----------------------------------------------------------

write.table(casesdf, "WMR2022_reported_cases_clean.txt",
            sep="\t",
            col.names = T,
            row.names = F,
            quote = F)

