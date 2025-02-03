
# Load Packages

library(tidyverse)

# Functions to test and convert types; Data types. "Is" checks, "As" forces it to be something else.

x <- 1
x
typeof(x)
is.numeric(x)
is.character(x)
as.character(x)
x + 1

#To assign data frames labels & merge things together if you have assigned x a specific value. 
x <- "data.csv"
typeof(x)
is.numeric(x)
is.character(x)
as.numeric(x)
"data_raw" + x
paste0("data_raw/",x)

# Missing values. is na = checks if something is missing. Null = empty variable.
#na.rm = TRUE means remove the NA, hence the rm.

x <-  c(1, 2, 3, NA)
print(x)
is.na(x)
mean(x)
mean(x, na.rm = TRUE)

x <- c(1, 2, 3, NULL)
x

# Logical comparisons 

x <- 1
x > 0
x > 2
x == 1
x != 2
!(x == x)
"s" == "S"
1 > 0 | 0 > 1
1 > 0 & 0 > 1

# Element-wise logical statements
x <- c(-1, 0, 1)
x < 0
x == 0

# Quickly test is a value is contained in a set
1 %in% x

# How do we use logical statements?

x <- c(0, 1, 2, 3, NA)
ifelse(NA %in% x, "x contains a missing value", "x does not contain a missing value")

x <- c(0, 1, 2, 3)
ifelse(NA %in% x, "x contains a missing value", "x does not contain a missing value")

# Each dplyr function uses a similar structure

# Arrange

ds <- starwars #loads built-in star wars database
glimpse(ds) #ROTATE
arrange(ds, name) #ROTATE
arrange(ds, height) #ROTATE
arrange(ds, desc(height), mass) #ROTATE to make in descending order because ascending is the default. 
arrange(ds, eye_color, hair_color) #ROTATE. NA will always come last. 

# Filter

filter(ds, height < 100) #ROTATE. Notice it doesn't automatically arrange it without the arrange command. 
filter(ds, name == "Yoda") #ROTATE. If we want to look at a specific case. 
filter(ds, is.na(hair_color)) #ROTATE. Add additional functions within filter
filter(ds, height > 100, height < 150) #ROTATE. Using multiple criteria by putting them in their own classes.
filter(ds, eye_color %in% c("blue","brown")) #ROTATE. Can select specific values within a column. 
filter(ds, !(eye_color %in% c("blue","brown"))) #ROTATE. If we want to select specific values by weeding out other values. 

# Slice. Involves more human intervention because you have to index by position. 

slice(ds, 1:5) #ROTATE. Want to look at the first 5 rows of a data set.  
slice_head(ds, n = 5) #ROTATE. Slight variants to look at different things. "head" is the top of the data frame.n = 5 is how many rows. 
slice_tail(ds, n = 4) #ROTATE. Slice tail is th end of the data. n = 4 is the last 4 rows in this case. 
slice_sample(ds, n = 2) #ROTATE. Look at a random 2 rows in the data set. 
slice_sample(ds, n = 2) #ROTATE. If we did it again, you will different rows because it's random. 
slice_min(ds, height, n = 3) #ROTATE. The three rows on height that have the minimum values. 

# Select works with coulmns, not rows. In this case, we are subsetting columns. 

select(ds, name) #ROTATE. 
select(ds, name, height, mass) #ROTATE. We can call multiple variable names at once.
select(ds, c("name", "height", "mass")) #ROTATE. You could also write it this way as a vector.
select(ds, name:eye_color) #ROTATE.  
select(ds, -(eye_color:starships)) #ROTATE.If we wanted to drop all of the columns after eye color. The - is a negation argument. 
select(ds, ends_with("color")) #ROTATE. Using helper functions by naming the column. We're telling R to only grab the ones that end with color. 
select(ds, contains("_")) #ROTATE. Contains is another helper function. In this case, we only want variables that contain an underscore (_)
select(ds, where(is.numeric)) #ROTATE. Select base on data types. If we only wanted to select numeric variables. 
select(ds, where(is.character)) #ROTATE. Same thing, but selecting based on character this time. 

# What's going on here? It's not going to string these arguments together.  

select(ds, name, height, eye_color)
filter(ds, height < 70)
ds

# Reassign the transformations back to the tibble. Use reassign to tibble to save these changes to strong arguments together. If we only wanted to keep these 3 columns.

ds <- select(ds, name, height, eye_color)
ds <- arrange(ds, height, eye_color)
ds <- filter(ds, height < 70)
print(ds)

# Not a good strategy. You want to save those changes separately so you don't mess up your original dataset. Create a new dataframe.

ds <- starwars
ds_name_height_eye_color <- select(ds, name, height, eye_color)
ds_sorted <- arrange(ds_name_height_eye_color, height, eye_color)
ds_sorted_filtered <- filter(ds_sorted, height < 70)
ds_sorted_filtered

# Introducing the pipe operator. Let's look at ds, but within ds I want to select these variables and re-assign to back to ds. 

ds <- starwars
ds <- ds %>% select(name, height, eye_color)

#If you want to do that, but you have a lot of arguments. Careful about stringing together too many things at once.
ds <- ds %>% 
  select(name, eye_color) %>% 
  arrange(eye_color) %>% 
  filter(eye_color == "blue")

# These are equivalent but <- is most conventional/common. There are different ways to write the same thing with the pipe.

ds <- starwars
ds <- ds %>% select(height) %>% slice_tail(n = 5)
ds %>% select(height) %>% slice_tail(n = 5) -> ds
ds <- select(ds, height) %>% slice_tail(n = 5)
ds <- slice_tail(select(ds, height), n = 5)

# Rename. Clear renaming is desirable. Janitor package can help make naming more cosnsistent. 

install.packages("janitor")
library(janitor)
# Switching to built-in iris data set since starwars has good names
iris #ROTATE
iris %>% rename(sepal_length = Sepal.Length) #ROTATE. Rename variable to have understcore instead of period.
iris %>% rename(sepal_length = Sepal.Length, sepal_width = Sepal.Width, petal_length = Petal.Length, petal_width = Petal.Width, species = Species) #ROTATE
iris %>% rename_with(toupper) #ROTATE. Toupper is a helper function which tells R to change all the variable to uppercase.
iris %>% rename_with(tolower, starts_with("Petal")) #ROTATE. Same thing with lowercase, but adding an argument to only do it to "petal" variables.

iris %>% clean_names() #ROTATE. Clean names takes all those variables to make it consistent. Underscore and undercase is the default. 
iris %>% clean_names("small_camel") #ROTATE. If you want to specify a specific approach. 

# Mutate and summarize. Mutate to add or modify columns.


ds <- starwars %>% select(name, mass, height, hair_color)
ds <- ds %>% mutate(in_movie = "yes") #Create a new variable that represents whether something is in a movie. To create a new coulmn.
ds <- ds %>% mutate(height_m = height/100,
                    bmi = mass/(height_m^2),
                    bmi = round(bmi)) %>% 
  arrange(desc(bmi))

#Separate mutate statements or stringing them together up above. It's easier to put it in one mutate clause.

#String togehter arguments, can use the pipe. 
ds <- ds %>% 
  filter(hair_color %in% c("blond", NA)) %>% 
  mutate(hair_color = ifelse(is.na(hair_color),"no hair", hair_color),
         mass = ifelse(mass > 1000, "huge", "not huge"))

# Tricky, common task: Changing some but not all values within a column

# Change all NA values to "no hair", keep all others the same. Filter out hair color. Can write an "if-else" statement inside of mutate.
ds <- ds %>% mutate(hair_color = ifelse(is.na(hair_color),"no hair", hair_color))

# Set all heights greater than 100 to 100, keep all others the same. Can also set all values above a certain value.
ds <- ds %>% mutate(height = ifelse(height > 100,100, height))

# Summarize (calculate all variables in aggregate)

ds <- starwars %>% select(name, mass, height, species)
ds %>% summarize(min_height = min(height))
ds %>% summarize(min_height = min(height, na.rm = T))

#Can string together lots of arguments into the same summarize

ds %>% summarize(min_height = min(height, na.rm = T),
                 m_height = mean(height, na.rm = T),
                 max_height = max(height, na.rm = T))

#If we wnated to see how data differed by group. 

ds %>% group_by(species) %>% 
  summarize(min_height = min(height, na.rm = T),
            m_height = mean(height, na.rm = T),
            max_height = max(height, na.rm = T),
            n = n())


