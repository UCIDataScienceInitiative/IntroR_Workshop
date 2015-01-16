# Please first work on the regular problems (with no "optional" marks). 
# If you still have time after finishing all the regular problems, work on the optional ones. 

# 1. import the data "auto-mpg.csv" and store it as an object "data". 
# Check what string/symbol is used to denote missing values in the data and specify the argument 
# na.strings for the function to read data. 
datafolder = './data/'
data = read.csv(file = paste(datafolder, "auto-mpg.csv",sep=""), 
                header = FALSE)

# optional:
# read data file "auto-mpg.data-original". What happens and why? Check the original data file.
data_baddata = read.table(file = paste(datafolder, "auto-mpg.data-original",sep=""), 
                  header = FALSE, sep=" ")
# returns error

# 2. check the top 6 rows of data; open the original data in excel or 
# notepad and compare with the rows printed in R
# tip: need to set header = FALSE since the data starts right from the first line 
# - no header
head(data)

# 3. check the dimension of data
dim(data)

# 4. Add variable names to data: 
# 4.1. read variables names from "auto-mpg-names.txt"
varnames = readLines(paste(datafolder,"auto-mpg-names.txt",sep=""))
# 4.2. assign variable names to data
names(data) = varnames
# 4.3. check if the variable names are correctly assigned
# you can either print the variable names of the data or print the top rows of the data

# data summary
# 5.1. Use a function to summarize the data structure and the class of each column;
str(data)
# 5.2 apply function summary() on data and see how it is different from the function above  
# one nice thing is that it tells you # missing values for each variable
summary(data)


# 6. Subset exercises 
# 6.1 summarize the variable mpg by applying function summary() on the variable
# (there are 3 ways you can get the variable mpg)
# See something weird in the result? What might be the reason? 
# We will get back to this later. 
summary(data$mpg)
summary(data[, "mpg"]])
summary(data[, 1]])


# 6.2 create a vector of the column indicies for the continuous variables 
# (refer to dataset description), 
# summarize the subset of the continuous variables (again, apply summary())
index_cont = c(1, 3:6) 
summary(data[,index_cont])

# 6.3 use the index vector created above to subset the non-continous variables
# summarize the non-continuous variables; 
# notice how summary() works differently for a factor variable from a numerical variable
summary(data[, -index_cont])

# 6.4 create a vector of logical values for whether origin is 2 or 3. 
# create a new data that contains only the instances (rows) where origin is 1 using the logical vector 
origin_23 = data$origin > 1 
#or, 
origin_23 = (data$origin == 2) |(data$origin == 3)
#or, 
origin_23 = data$origin != 1
#or, 
origin_23 = data$origin %in% c(2,3)
data_origin_1 = data[origin_23 , ]
# read the help file for which(); use it to get the indices for the instances where origin is 2 or 3.
index_origin_23 = which(origin %in% c(2,3))


# 7. discrete variables 
# 7.1 check and apply function table() on variable cylinders
table(data$cylinders)
# 7.2 use a loop function to print the name and the frequency table for each discrete variable
for(i in c(2,7,8)){
  print(names(data)[i])
  print(table(data[,i]))
}
# OK. Wait... -99 again? Actually these should already be shown in summary(data) (min.). 

# 7.3 we are going to change the data, so please first make a copy of the original data;
data_ori = data
# origin is a categorical variable by nature, so we are going to convert it to a factor type. 
# before doing that, we need to first fix the weird values -99 -- replace it with NA. 
# table() the new variable and check if -99's are successfully replaced. 
data$origin[data$origin == -99] = NA
table(data$origin)
# convert variable origin into factor type, add the labels for the values (1: American, 2: European, 3:Japanese)
# check the variable type of the converted variable and the variable from the original copy of the data
# table() on the new variable and see how the output changes
data$origin = factor(data$origin)
levels(data$origin) = c("American", "European", "Japanese")
class(data$origin)
class(data_ori$origin)
table(data$origin)
# 8.0 notice that there are -99's in mpg and 

# 8. Missing values
# 8.0 We have seen weird values on mpg. Let's also fix it. 
# and then use summary(data) to check if every variable looks reasonable
# note: in reality, there could be dirtier data coding, e.g. multiple bad codings, 
# in which case histograms and boxplots will be useful - 
# able to see all weird values at the same time. The same as checking outliers.  
data$origin[data$mpg == -99] = NA
summary(data)

# 8.1 using is.na() function, take a subset of the dataset that has non-missing mpg 
# and check the dimension of the subset
# hint: !is.na() refers to NOT NA !
dim(data[!is.na(data$mpg), ])

# 8.2 using is.na() function, create a new data that is the subset of the dataset that 
# has no missing values in any variables
# hint: refer to summary(data) to see which variables have missing values
# logical operator: & for and, | for or
# and then check # instances in the new data
data_noNA = data[(!is.na(data$mpg)) & (!is.na(data$horsepower)) & (!is.na(data$origin)), ]
nrow(data_noNA)
dim(data_noNA)[1]

# ***#
# 8.3 create a vector "contain_no_NA", with each element being a logical value indicating
# whether it has all non-missing values, for each instance. 
# hint: use all() to return whether the statement is true for all elements of a vector
# a) use for loop to get contain_no_NA (loop over the rows of data)
contain_no_NA = NULL
for(i in 1:dim(data)[1]){
  contain_no_NA[i] = all(!is.na(data[i,]))
}
# b) use apply() to get contain_no_NA
contain_no_NA = apply(!is.na(data), 1, all)
# c) use contain_no_NA to get the new data that contains only the subset that has no missing values
data_noNA = data[contain_no_NA, ]

# 8.4 read the help file for function na.omit(), and use this function to create a 
# new data that contains only the instances that has no missing variables
data_noNA = na.omit(data)
????completcase

#***#
# from now on use the data set that contains no missing values
# 9. Exercises for *apply() and split()
# 9.1 use one of the *apply() functions to get the frequency table on all discrete variables 
# note that this can be directly done by summary(data[,c(2,7,8)]) if these variables are all of factor type instead of numerical type
sapply(data_noNA[,c(2, 7, 8)], table)
# Find average mpg for each # cylinders
tapply(data_noNA$mpg, data_noNA$cylinders, mean)
# Find 2.5 and 97.5 percentile of mpg for each # cynlinders 
tapply(data_noNA$mpg, data_noNA$cylinders, quantile, c(0.025, 0.975))
# Split the dataset based on # cylinders 
data_by_origin = split(data_noNA, data_noNA$origin)

# randomization testing for mean mpg is higher for Japanese cars than European cars
# calculate the difference between mean mpg for Japanese cars and European cars and save in object dif_JapVSEuro
dif_JapVSEuro = mean(data_by_origin$Japanese$mpg) - mean(data_by_origin$European$mpg)
# find the number of instances for European cars and save in object n_European
n_European = sum(data_noNA$origin == "European")
# or 
n_European = dim(data_by_origin$American)[1]
# run a simulation that does the following in each iteration:
  # find the subset of European cars and Japanese cars
  # randomize the origin of the cars: (hypothetically) randomly assign the instances to 
  # be European cars and Japanese cars
  # calcualte the new difference in the mean mpg of the randomized data 
  # (Jap - Euro)
  # record whether the new difference is >= the observed difference, dif_JapVSEuro
# Run a simulation of 1000 iterations; 
# obtain the p value by calculating the proportion of times that the difference of the randomized data 
# is >= the observed difference
B = 1000
E_le_J = rep(NA, B)
for(iter in 1:B){
  index = which(data_noNA$origin!= "American")
  rand_samp_Euro = sample(seq(index), n_European)
  index_rand_Euro = index[rand_samp_Euro]
  index_rand_Jap = index[-rand_samp_Euro]
  mpg_rand_Euro = mean(data_noNA$mpg[index_rand_Euro])
  mpg_rand_Jap = mean(data_noNA$mpg[index_rand_Jap])
  E_le_J[iter] = (mpg_rand_Jap - mpg_rand_Euro)> dif_JapVSEuro
}
p_val = mean(E_le_J)


# 10. histogram of the continuous variables
a) separate plot for each variable
* b) use reshape and facet

# 11. boxplot of mpg by factor 
boxplot by cylinders
optional: facet_grid() and jitter

# 12. scatterplot 
a) single scatterplot + lm fit
b) matrix - ggplotmatrix

# 12.1 data transformation: 
# based on scatterplot matrix, add new variables: log transformed versions of horsepower, displacement, and weight 
data_noNA$loghorsepower = log(data_noNA$horsepower)
data_noNA$logdisplacement = log(data_noNA$displacement)
data_noNA$logweight = log(data_noNA$weight)
# add new factor version of cylinders:
data_noNA$cylinders_cat = factor(data_noNA$cylinders)

???opacity

??? add more specific goals in the data intro part

# 13. linear regression 
# ANOVA for origin
model_origin = lm(mpg ~ origin , data = data_noNA)
summary(model_origin)
anova(model_origin)

# *** # two way anova
model_origin_cylinder = lm(mpg ~ origin*cylinders_cat , data = data_noNA)
summary(model_origin_cylinder)
anova(model_origin_cylinder)

# Build a regression that contains all the variables 
# (if a transformed version is available for a variable, use only the transformed version)
model = lm(mpg ~ cylinders_cat + logdisplacement + loghorsepower + 
             logweight + acceleration + model_year + origin , data = data_noNA)

summary(model)
?plot.lm
plot(model)

