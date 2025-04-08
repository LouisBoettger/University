# Week 8 Data Vis ---------------------------------------------------------

install.packages("palmerpenguins")
install.packages('ggpubr')
library(palmerpenguins)
library(tidyverse)
library(dplyr)
library(ggpubr)

#Have a look at the penguins dataframe with your favourite looking-at-datasets function
str(penguins)
head(penguins)
view(penguins)


#Have a look at the code below and identify the bits that are high-lighted in bold
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g))
#data = penguins
#geom = point
#variables = bill length and body mass
#mapping to aesthetic '(mapping = aes())'


#Mapping the colour the species
peng_colour_spp <-ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = species))


#Does this cluster also correlate with the island the penguins are from? Copy and change the code above to check
peng_colour_island <- ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = island))

#arranging them next to each other to compare
ggarrange(peng_colour_spp, peng_colour_island, nrow = 1)


#Adding layers to the plot
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_smooth(mapping = aes(x = bill_length_mm, y = body_mass_g))

#do not have to repeat the mapping if using the same stuff:
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth()

#mapping colour to species again
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth()

#fitting a curve to each species
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth(mapping = aes(colour = species))



#assign it to a variable and add other layers later
pengu_plot <-
  ggplot(data = penguins,
         mapping = aes(x = bill_depth_mm, y = bill_length_mm, shape = species)) +
  geom_point(aes(colour = species))

#We can add layers to our plot
pengu_plot +
  geom_smooth()


#Write code to produce the following plot
#Hint: Look at the documentation for geom_smooth to find the arguments you need for a linear model and to remove the confidence intervals
?geom_smooth
pengu_plot +
  geom_smooth(method = lm, mapping = aes(colour = species), se = FALSE)
#method = lm makes them linear,
#se is for the confidence intervals, removing them removes the rarefaction

#saving plots as a png
ggsave(filename = "penguin_plot_1.png", plot = pengu_plot)

pengu_plot +
  geom_smooth()

#Or if we don’t pass it a variable it will save the last plot we printed to screen
ggsave("penguin_plot_2.png")



# Continuous Variables ----------------------------------------------------

ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot(mapping = aes(colour = species))

#Change the code, so that it fills the boxes with colour instead of the lines. You might have to google how to do that - it’s not obvious from the documentation
ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot(mapping = aes(fill = species))
#use fill instead of colour to fill in the box plots


#Look at penguins using both head() and str(). Where can you see which variables are factors? What additional information does str() show you?
str(penguins) #shows what variables are factors, str also shows the amount of data
head(penguins) #shows what variables are factors

#Here is an example where alphabetical order would be annoying
df_days <-
  data.frame(day = c("Mon", "Tues", "Wed", "Thu"),
             counts = c(3, 8, 10, 5))
df_days$day <- as.factor(df_days$day)
str(df_days)

ggplot(data = df_days, mapping = aes(x = day, y = counts)) +
  geom_col()

#Luckily we can change that very easily:
df_days$day <- factor(df_days$day, levels = c("Mon", "Tues", "Wed", "Thu"))
str(df_days)
#reordering the days to go in the right order instead of alphabetically

ggplot(data = df_days, mapping = aes(x = day, y = counts)) +
  geom_col()


#Write the code to reproduce this plot. You’ll have to use the data visualisation cheat sheet to find the correct geom
penguins2 <- penguins #making a copy to be safe before changing factors

#specifying order of species for the graph
penguins2$species <- factor(penguins$species, levels = c("Chinstrap", "Gentoo", "Adelie"))

#separate the adelies using fill = island
ggplot(data = penguins2,
       aes(x= species, y= body_mass_g, fill =island)) +
  geom_violin()


# Statistical Transformations ---------------------------------------------

ggplot(data = penguins) +
  geom_bar(mapping = aes(x = species)) +
  coord_flip()

#Have a look at the documentation for geom_bar. What is the difference between geom_bar() and geom_col()? 
#Also, what does coord_flip() do?

#coordflip() changes the orientation of the plot
?geom_bar
#geom_bar makes the height of bar proportional to number of cases in each group 
#geom_col makes height represent values in the data


# Plotting Subsets --------------------------------------------------------

penguins %>% filter(!species == "Chinstrap") %>%
  ggplot(mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species, shape = island))

#Use is.na(sex) with filter() to reproduce the plot below, so that it only contains penguins where sex is known
ggplot(penguins,
       aes(x=species, y=body_mass_g, fill = sex))+
  geom_violin()


# Labels ------------------------------------------------------------------

penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  labs(title = "Weight distribution among penguins",
       subtitle = "Gentoo penguins are the heaviest",
       x = "Species",
       y = "Weight in g",
       fill = "Sex",
       caption = "Data from Palmer Penguins package\nhttps://allisonhorst.github.io/palmerpenguins/"
  )

#Changing the legend labels can’t be done within labs(), because the legend is part of scales. 
#Which function we need to use depends on the aesthetics and variables.
#Here we have mapped a categorical, i.e. discrete, variable (sex) to fill, so the function to use is scale_fill_discrete().
#This function also allows you to change the colours, but we’ll talk about colours a lot more over the next couple of weeks

penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  labs(title = "Weight distribution among penguins",
       subtitle = "Gentoo penguins are the heaviest",
       x = "Species",
       y = "Weight in g",
       caption = "Data from Palmer Penguins package\nhttps://allisonhorst.github.io/palmerpenguins/"
  ) +
  scale_fill_discrete(name = "Sex", # the legend title can be changed here or in labs()
                      labels = c("Female", "Male", "Unknown"),
                      type = c("yellow3", "magenta4", "grey"))

#Generate a new plot from the penguin data with at least two geoms, good labels, and maybe even try out some colours. For example, you could try and find a geom that allows you to show the individual datapoints on top of boxplots. Be creative!
penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  geom_smooth(mapping = aes(colour = species), method = lm, se = FALSE) +
  labs(title = "Weight distribution among penguins",
       subtitle = "Gentoo penguins are the heaviest",
       x = "Species",
       y = "Weight in g",
       fill = "Sex",
       caption = "Data from Palmer Penguins package\nhttps://allisonhorst.github.io/palmerpenguins/"
  )
#^broken


# Challenge ---------------------------------------------------------------

#Read in the modelling table (“wmr_modelling.txt”) and reproduce the following plot. You’ll have to figure out a way to order the dataframe by deaths and then convince ggplot to keep the data in that order when plotting (hint: factors are your friends!).

wmr <- read.table('wmr_modelling.txt',
                  header = T,
                  na.strings = '')
view(wmr)


ggplot(wmr, aes(x=deaths, y=reorder(country, deaths))) +
  geom_col()+
  labs(x='deaths', y='country')
?arrange
