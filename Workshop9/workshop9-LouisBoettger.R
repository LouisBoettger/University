#Workshop 9

install.packages('palmerpenguins')
install.packages('tidyverse')
library(palmerpenguins)
library(tidyverse)
library(dplyr)


# Annotating Data Points --------------------------------------------------

# Subset penguins dataframe to the the five heaviest penguins
big_penguins <- penguins %>%
  filter(species == "Gentoo",!is.na(body_mass_g)) %>% 
  arrange(body_mass_g) %>% tail(n = 5L)

# Add a column with names to big_penguins
big_penguins$names <- c("Dwayne", "Hulk", "Giant", "Gwendoline", "Usain")

# Plot all Gentoo penguins and use big_penguins dataframe for labels
penguins %>% filter(species == "Gentoo") %>%
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(aes(colour = flipper_length_mm)) +
  geom_text(
    data = big_penguins,
    mapping = aes(label = names),
    nudge_x = -1.5,
    nudge_y = -0.5,
    colour = "red"
  ) +
  xlim(3900, 6400)

#For geom_text() we’re switching to different data, namely our big_penguins dataframe.
#Nevertheless, geom_text() inherits the position mappings from ggplot().
#That’s how geom_text() knows where to put the labels

#We use the nudge parameters to push the labels down and left a bit, so that they don’t sit right on top of the dots they are labeling.


# For example, I want to highlight the home islands of Adelie penguins with flipper lengths over 200 mm:
penguins %>% filter(species == "Adelie") %>%
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point() +
  geom_text(
    data = filter(penguins, species == "Adelie" &
                    flipper_length_mm > 200),
    aes(label = island),
    nudge_y = -0.7
  )

#Why do we have to filter for the species again in geom_text()? What happens if we don’t do that?
#because we only want those over flipper length 200mm to be labelled



# Facets ------------------------------------------------------------------

#two types of faceting, facet_wrap() and facet_grid()
#The first takes a number of plots and “wraps” them into a panel

# Reading in data
modeltab <- read.table("wmr_modelling.txt",sep="\t",header=T)

# Subsetting to the first half or so for readability
modeltab_short <- head(modeltab, n = 506L)

# Plotting deaths in years 2019-2021 faceted by country
modeltab_short %>% drop_na() %>% filter(year >2018) %>%
  ggplot(aes(x = year, y = deaths)) +
  geom_col(fill = "firebrick") +
  facet_wrap(~country, ncol = 5, dir = "v")

#~ determines the variable by which we want to split our data into separate plots
#choose the number of rows and columns with ncol or nrow (One follows from the other, so you only need to set one)
#dir controls the direction of the wrap



#Copy the code above and play around with different options.
#What does the facet_wrap() argument as.table do?
#What happens if you set the argument scales to “free”?
#Also note that we use the function drop_na()

modeltab_short %>% drop_na() %>% filter(year >2018) %>%
  ggplot(aes(x = year, y = deaths)) +
  geom_col(fill = "firebrick") +
  facet_wrap(~country, ncol = 5, dir = "v")

?facet_wrap #as.table is true as default, facets laid out like a table with highest values in bottom right
#if false facets are laid out like a plot with highest value at top right

#scales is 'fixed' by default, 'free' sets the y axis to be independent in each facet

?drop_na #drops rows where any column specified contains a missing value

#The second faceting type lays out the plots in a 2D grid.
#This is often used to separate plots by two categorical variables like so:
penguins %>% drop_na() %>% ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point() +
  facet_grid(sex ~ species)

#The formula in facet_grid() determines first the rows, then the columns
#You can also use this to control how you want plots laid out that are separated by just one variable:

p_plot <- penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point()


p_plot + facet_grid(. ~ species)

p_plot + facet_grid(species ~ .)



# Patchwork ---------------------------------------------------------------

install.packages("patchwork")
library(patchwork)

p1 <- penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm, colour = species)) +
  geom_point() + facet_grid(. ~ species)

p2 <- penguins %>%  drop_na() %>%
  ggplot(aes(x = flipper_length_mm)) +
  geom_histogram(aes(fill = species), position = "identity")

p3 <- penguins %>% drop_na() %>% 
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex))

p1/(p2+p3)

#putting one on the left and two on the right
p2 | (p1/p3)


#Patchwork allows you to add annotations using the plot_annotation() function:
p1/(p2+p3) + plot_annotation(tag_levels = "a",
                             title = "Plenty of penguin plots")


#Patchwork is very useful when we want to align plots with the same x- or y-axis:
p_deaths <- modeltab %>% filter(country %in% c("Angola", "Burkina Faso", "Chad")) %>% 
  ggplot(aes(x = year, y = deaths, colour = country)) +
  geom_point() +
  geom_line() +
  xlim(1999,2022)
p_deaths
p_pop <- modeltab %>% filter(country %in% c("Angola", "Burkina Faso", "Chad")) %>% 
  ggplot(aes(x = year, y = population, fill = country)) +
  geom_col(position = "dodge") +
  xlim(1999,2022)

p_deaths/p_pop
#new operator, %in%, handy for subsetting
#Here it’s used with a vector written on the fly, but you can also use a variable that contains a vector you made previously.


# Colours -----------------------------------------------------------------

#Scroll up through this worksheet and identify one plot each for the three ways of using colour
#'fill' - population/year = categorical
#'colour' - flipper length = continuous
#'colour' also used within geom_text() to colour annotations = manually colouring set variables

#Here is an example of how to change discrete colours manually:
s_counts <- penguins %>% ggplot(aes(x = species, fill = species)) +
  geom_bar()

s_counts + scale_fill_manual(values = c("yellow2", "magenta", "darkblue"))


install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()

#ColorBrewer has three types of palettes
#The first type is suitable for ranked discrete graphs, e.g. a series of years
#The second is best for our example plot of unranked categorical data
#The third type is used when you have discrete diverging data going from low to high through 0.

#We can apply ColorBrewer palettes like this:
brew_1 <- s_counts + scale_fill_brewer(palette = "Set1")
brew_2 <- s_counts + scale_fill_brewer(palette = "Dark2", direction = -1)

brew_1 + brew_2

#viridis = colour friendly
viri_1 <- s_counts + scale_fill_viridis_d() #Uses default option viridis
viri_2 <- s_counts + scale_fill_viridis_d(option = "plasma")

viri_1 + viri_2


#the function for continuous viridis scales is scale_colour_viridis_c()
#for ColorBrewer scale_colour_distiller()

con_plot_1 <- penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(size = body_mass_g, colour = body_mass_g))

con_plot_2 <- con_plot_1 + scale_colour_viridis_c(option = "magma")

con_plot_1 + con_plot_2


#if NA values in your graphs it is recommended to give them a colour
#Some palette functions have grey set as default for NA whereas others don’t.
#In the latter case the colour of NA gets sometimes set to the background of the plot
#This can have unintended results, for example if you remove the default grey plot background 

penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  scale_fill_brewer(palette = "Set2", na.value = "yellow2")



# Themes ------------------------------------------------------------------

#ggplot2 has a default theme, theme_grey()
#sets the plot panel to grey, grid lines and axes to white, determines where the legend goes, etc
#complete themes available, such as theme_minimal(), theme_classic(), etc

#We can simply change from the default to another one like so:
con_plot_3 <- con_plot_1 + theme_classic()

con_plot_1 + con_plot_3 + plot_annotation(title = "Default theme on the left, theme_classic() on the right")


#theme() allows us to change each element of the plot


#Have a look at the documentation of theme() for the arguments available to adjust
#type theme_grey (without the brackets) into your console to look at how these arguments are used to set the theme

?theme


#elements of a plot are divided into three broad types: Lines, text and rectangles
#three functions that are used to manipulate them: element_line(), element_text(), and element_rect()
#to remove an element entirely we use the function element_blank()


#Let’s see how this works in practice
penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(colour = body_mass_g)) +
  labs(title = "My pretty plot") +
  scale_colour_viridis_c(option = "magma") +
  theme(legend.position = "bottom",
        axis.title.x = element_text(colour = "red", size = 14, hjust = 1),
        axis.title.y = element_blank(),
        axis.line.y = element_line(colour = "cornflowerblue", linewidth = 4),
        axis.text.y = element_text(size = 20, angle = 45),
        panel.background = element_rect(colour = "green", fill = "yellow", linewidth = 10),
        plot.title = element_text(face = "italic",  hjust = 0.5, size = 18))


#theme() is also very handy for adjusting the position of the legend. As you’ve seen above, we can move it below the plot area, but we can also put it in the plot to save space:
penguins %>%  drop_na() %>%
  ggplot(aes(x = flipper_length_mm)) +
  geom_histogram(aes(fill = species), position = "identity") +
  theme(legend.position = "inside",
        legend.position.inside = c(0.9,0.85),
        legend.background = element_blank())


# Exercises ----------------------------------------------------------------

#1. Labels: Plotted here are only the penguins resident on the island Biscoe.

penguins %>% filter(island == 'Biscoe') %>% 
  ggplot(aes(bill_depth_mm, bill_length_mm)) +
  geom_point(aes(colour = species)) +
  geom_text(filter(penguins, island =='Biscoe' & 
                     species == 'Adelie' & bill_depth_mm >20.2 |
                     species == 'Gentoo' & bill_length_mm >53.5),
            mapping = aes(label = sex),
            nudge_y = -0.7) +
  labs(title = 'Penguins on the island Biscoe')



#2. Facets: Produce this plot using the dataset in the file called wmr_cases_deaths_modelling_summaries.txt
wmr_data <- read.table('wmr_cases_deaths_modelling_summaries.txt', header = T, sep = '\t')

wmr_data %>% filter(region != 'Total') %>% 
  ggplot(aes(year, deaths)) +
  geom_col(fill = 'steelblue4') +
  facet_wrap(~region, nrow = 2, dir= 'h', scale = 'free')


#3. Patchwork: Using the datasets in wmr_modelling.txt and wmr_cases_deaths_modelling_summaries.txt produce a publication-style figure. It should contain at least three plots, one with faceting, arranged with patchwork





# Big Challenge -----------------------------------------------------------

wmr_model <- read.table('wmr_modelling.txt', header=T, sep='\t')
wmr_model$country<-as.factor(wmr_model$country)

wmr_bar <- wmr_model %>% filter(country %in% c('Burkina Faso', 'Mali', 'Niger', 
                                 'Uganda', 
                                 'Democratic Republic of the Congo',
                                 'Mozambique', 'Nigeria',
                                 'United Republic of Tanzania')) %>% 
  ggplot(aes(year, deaths, fill = country)) +
  geom_col() +
  scale_fill_brewer(palette='Dark2') +
  theme(legend.position = 'bottom')


wmr_line <-wmr_model %>% filter(country %in% c('Burkina Faso', 'Mali', 'Niger', 
                                    'Uganda', 
                                    'Democratic Republic of the Congo',
                                    'Mozambique', 'Nigeria',
                                    'United Republic of Tanzania')) %>% 
  ggplot(aes(year, cases, colour = country)) +
  geom_line() +
  geom_point() +
  scale_color_brewer(palette = 'Dark2') +
  theme(legend.position = 'none')

wmr_line/wmr_bar  
