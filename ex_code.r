# Exercises

### SECTION 1 ###

# The first set of exercises will deal with reading a dataset into R, exploring various structural and content-related feature of the data, and manipulating the dataset so that it is in a form we can use later for analyses. 

# We will be using the Auto MPG Data Set, a collection of automobile records from 1970 to 1982 containing variables such as miles per gallon (mpg), car name, weight, and origin. Specifically, we will be focusing on the relationships between miles per gallon (mpg) and various other features of the car (such as model year, weight, number of cylinders, etc.). 

# Exercise 1. Find and import R data.

## 1.1 Find the folder where your R data files are saved and set your working directory to that folder using setwd(). 

setwd("~/Documents/education/uci/research/misc/data_science_initiative/intro_r/IntroR_Workshop-gh-pages/data")

## 1.2 Import "auto-mpg.csv" using read.csv(), storing the data as an object called "data" 
  # In this dataset, there is no header (i.e., no variable names) and missing values are denoted as NA. Therefore, within the read.csv() function:
    # Set header = FALSE
    # Set na.strings = "NA"
  # If you need help, type ?read.csv

data <- read.csv(file = "auto-mpg.csv", header = FALSE, na.strings= "NA")

## 1.3 Now that your data is loaded, use the head() function to look at the first few rows of the data to make sure it looks okay (you can open the original CSV file in Excel or Notepad to compare). As mentioned above, you should notice that the data does not contain variable names. We will fix that in the next exercise. 

head(data)


## Check the dimensions of the data, the number of rows in the data, and the number of columns in the data using the functions dim(), nrow(), and ncol(), respectively. 

dim(data)
nrow(data)
ncol(data)

# Exercise 2. Add variable names to the data. 

## 2.1 Use the function readLines() to read in "auto-mpg-names.txt", a file that contains the variable names for our data. Store this as an object called varnames. 

varnames <- readLines("auto-mpg-names.txt")

  # The difference between readLines() and read.table() (or read.csv()) is that readLines() imports the data file into a vector of strings, while read.table() imports the data file into a data frame.

## 2.2 Run names(data). This returns the variable names of our data frame.  

names(data)

## 2.3 Assign the new variable names (i.e., varnames) to names(data). 

names(data) <- varnames


# Exercise 3. Summarize the data

# 3.1 Summarize the data using the str() and summary() commands. 

str(data)
summary(data)

  # Notice the different kinds of information each of these functions provide with respect to the data. In particular, str() summarizes the structure of the data, while summary() summarizes the content of the data. 


# Exercise 4. Subsetting data.

# 4.1 Select:
  # a. The first row of the data frame
    data[1,]
  # b. The mpg (first) column of the data frame (there are three ways to do this)
    data[,1]
    data[,"mpg"]
    data$mpg
  # c. The second row, first column of the data frame
    data[2,3]

# 4.2 Summarize the variable mpg using summary(). Do you see something weird in the result? What might be the reason? We will get back to this later.

summary(data$mpg)

# 4.3 Above we summarized a single variable. Next, we will summarize multiple variables at once. 
  # Create an index vector called "index_cont" for the numbers 1,3,4,5,6 using c(). These numbers the correspond to the columns that contain continuous variables. Then, use that vector to subset the continuous variables from our data, and summarize them using summary(). 

index_cont <- c(1,3:6)
summary(data[,index_cont])



# 4.4 Finally, let's remove the variable car_name (we will not use it in subsequent exercises). Hint: you can either assign NULL (empty) to the variable "car_name", or redefine data to be the subset of the data that does not contain "car_name".

data$car_name <- NULL
# or,
data <- data[,-9]


# Exercise 5. Discrete variables and factors. 

# In this section, we will convert a variable to a factor and change the levels of the factor.

# 5.1 The variable "origin" is of the class integer (run class(data$origin) to check for yourself), but it is categorical by nature. Convert "origin" to a factor using the factor() function and assign it back to data$origin. 

data$origin <- factor(data$origin)

# 5.2 Next, we want to change the levels of data$origin. Check the current levels by running levels(data$origin). Then, change the levels to the following: 
  # 1: American, 2: European, 3: Japanese

levels(data$origin) <- c("American", "European", "Japanese")


# Exercise 6. Missing values. 

# In this section, we will recode missing values and then remove entries containing missing values from our data. 

## 6.1 Recall that in Exercise 4.2 we saw the weird value of "-99" in "mpg". Sometimes, an unlikely value (commonly, values like -99, 99, or 999) is used to code missing values. It's always important to confirm these values were coded as missing with the data entry clerk. Let's assume that this has been confirmed, and replace all "-99" with NA. 

data$mpg[data$mpg == -99] <- NA

## 6.2 Read the help file for the function na.omit(), and use this function to create a new dataset (store it as data_noNA) that contains only the instances that has no missing value on any variables. We will be using data_noNA for the remaining exercises. 

data_noNA <- na.omit(data)

### SECTION 2 ###

# The second set of exercises will focus on data descriptives and data analysis. 

# Exercise 7. Descriptive plots. 

# Now that we have our dataset in its final form, we can start analyzing it. We will start by simply plotting the data to check for outliers and the distributions of the variables. 

# 7.1 Generate a histogram plot for each continuous variable (remember to use data_noNA). 
hist(data_noNA$mpg)
hist(data_noNA$displacement)
hist(data_noNA$horsepower)
hist(data_noNA$weight)
hist(data_noNA$acceleration)

# 7.3 Generate a boxplot of mpg by origin to visually check if mpg is different across different countries of origin. Type ?boxplot for help. Make sure that your variable on the x-axis (in this case, origin) is a factor (you can type class(data_noNA$origin) to confirm this; if not refer to Exercise 5).

boxplot(mpg ~ origin, data = data_noNA)

# 7.4 Create a scatterplot of mpg by cylinders and examine the form of the relationship (i.e., is it linear or not?). In other words, we want to decide if we should treat cylinders as a numerical variable (linear) or categorical variable (not linear).
  # Include the following:
    # 1. Default smooth curve overlayed (lines(lowess())
        
    # 2. A linear regression fit overlayed (abline(reg())
        

  # The two fitted curves should both have non-zero slopes but look quite different, suggesting mpg and cylinders are associated, but not linearly associated, in which case we want to keep cylinder as a categorical variable. You can see very few cases have cylinder = 3 or 5; sometimes you may want to do a secondary analysis with those cases removed. 

# 7.5 Next we are going to create a scatterplot matrix by applying the function scatterplotMatrix() to our data.
scatterplotMatrix(data_noNA)


# Exercise 8. Data transformation. 

# Based on the scatterplot matrix from 7.5, we need to transform some of our variables before we can perform a statistical analysis. In particular, we can see that the variance increases as mpg increases, and there are non-linear relationships between mpg and some of the other variables. 

# 8.1 Add the following variables to the dataset: 

# Add log-transformed versions of mpg, horsepower, displacement, and weight. Name them as logmpg, loghorsepower, etc.
  # Hint: to add a new variable, assign, for example, log(data_noNA$mpg) to data_noNA$logmpg. 

data_noNA$logmpg <- log(data_noNA$mpg)
data_noNA$loghorsepower <- log(data_noNA$horsepower)
data_noNA$logdisplacement <- log(data_noNA$displacement)
data_noNA$logweight <- log(data_noNA$weight)

# Add a factor version of cylinders. Call it cylinders_cat. 

data_noNA$cylinders_cat <- factor(data_noNA$cylinders)

# 8.2 Look at the data using the head() function to make sure everything looks good.

# Exercise 9. Statistical analysis. 

# Now that we have transformed our variables, we can perform statistical analyses to explore the relationship of mpg to other variables. 

# 9.1 Let's test whether mean mpg is different across cars of the three origins, using a significance level of 0.05. First, fit a linear regression model for mpg against origin. Then, use both anova() and summary() to check the results. 

model_origin = lm(mpg ~ origin , data = data_noNA)
summary(model_origin)
anova(model_origin)

# We can see that both outputs show p value "< 2.2e-16", and therefore mpg does depend on car origin. 

# 9.2 Next, fit a linear regression model predicting mpg. Include all other variables, using only the log-transformed versions if available. Store the model as "model". Then, fit a model using the same predictors, but predict log(mpg). Store the model as "model_log".

model <- lm(mpg ~ cylinders_cat + logdisplacement + loghorsepower + logweight + acceleration + model_year + origin , data = data_noNA)
model_log <- lm(logmpg ~ cylinders_cat + logdisplacement + loghorsepower + logweight + acceleration + model_year + origin , data = data_noNA)


# 9.3 Apply summary() to both of the model objects and examine the results. Is origin still helpful in predicting mpg/log(mpg) after including other predictors? 

summary(model)
summary(model_log)

# We can see that the p value (the column Pr(>|t|)) for originEuropean is above 0.05, but originJapanese is very small. After including other predictors, it seems that car origin is still helpful in predicting mpg, but due to the Japanese category not European cateogory. 

# 9.4 What do the numbers in the "Estimate" column in the summary() output  represent? 

# Each number tells you on average how many units of increase in mpg is associated with one unit increase in the corresponding variable.  

# 9.5 Run "newcase = data_noNA[1:10,]" to take the first 10 instances, and treat them as new car data for which we want to predict mpg. Use predict() to predict mpg for them using respectively the object "model" and "model_log". Keep in mind that from "model_log", predict() returns the predictions for log(mpg) instead of mpg. 

newcase = data_noNA[1:10,]
predict(model, newcase)
exp(predict(model_log, newcase))


## Exercise 10. Bootstrapping. (Optional)

# In this exercise, we will learn the technique of bootstrapping, a general method for determining the variance of a parameter. In particular, we will find an estimate of the variance for the median mpg.
  
# 10.1 Subset the mpg column of the data and store it as "mpg_data".

mpg_data <- data_noNA$mpg

# 10.2 Find the median mpg using the function median(). We will eventually work toward finding an estimate for the variance of this parameter. 

median(mpg_data)

# 10.3 Sample mpg_data using the function sample(). Store this as an object called "mpg_bootstrap". 
  # Hint: There are length(mpg_data) = 392 elements in mpg_data. We want to sample mpg_data 392 times (with replacement). Read ?sample if you need help.

mpg_bootstrap <- sample(mpg_data, length(mpg_data), replace = TRUE)

# 10.4 Find the median of mpg_bootstrap. Store this as an object called "med".

med <- median(mpg_bootstrap)

# 10.5 Now, we want to repeat steps 10.3 and 10.4 one thousand times, storing the median of mpg_bootstrap each time. Create a for loop to do this. 
  # Hint: Begin by creating a NULL vector called med_bootstrap. Within the for loop, include a line of code that concatenates the previous medians ("med_bootstrap") with current median ("med") using the function c(). Store this as "med_bootstrap". 

med_bootstrap <- NULL

for (i in 1:1000){
  mpg_bootstrap <- sample(mpg_data, length(mpg_data), replace = TRUE)
  med <- median(mpg_bootstrap)
  med_bootstrap <- c(med_bootstrap, med)
}


# 10.6 After running your for loop, you should be left with a vector called med_bootstrap that contains 1000 median mpg estimates. Find the variance of this using the function var().

var(med_bootstrap)


