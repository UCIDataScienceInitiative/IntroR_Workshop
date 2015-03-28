# EX1. Import data
# + 1.1  find the folder where the data files are saved, and set working directory to that folder using setwd().
# + 1.2 use read.csv() to import the data "auto-mpg.csv" (the data is of comma separated value file format), and store it as an object "data" ( data = read.csv(....) ). We need to set header = FALSE since the data starts right from the first line (i.e. the data has no header). Look at the data set to see what string/symbols are used to denote missing values; in this data "NA" is used, so na.strings = "NA" should be specified in read.csv().  
data = read.csv(file = "auto-mpg.csv", header = FALSE, na.strings= "NA")

# + 1.3 (optional) Read data file "auto-mpg.data-original.txt". What happens and why? Check the original data file.
data2 = read.table(file = "auto-mpg.data-original.txt", header = FALSE, sep=" ")
# It returns error because the data format is not suitable for read.table or read.csv. It has fixed width format so you need to use read.fwf() and specify the column widths. Therefore you need to know the column widths in advance; if you don't know, you can look at the data and count the widths). Or, you can open the data in Excel which automatically obtains the column widths, convert it to a csv file, and import the data using read.csv(). 
data2 = read.fwf("data/auto-mpg.data-original.txt", widths = c(7, 5, 11, 11, 11, 7, 5, 3, 50))

# EX2. General check for the data
# + 2.1 check the top few rows of data; open the original data in excel or notepad and compare with the rows printed in R.  
head(data)
# + 2.2. check the dimension of data
dim(data)

# EX3. Add variable names to data
# + 3.1 import variable names from "auto-mpg-names.txt" using readLines() and store as an object "varnames" (varnames = readLines(...)). Type "varnames" in the console to see what's inside. The difference between readLines() and read.table() is that readLines() imports the data file into a vector of strings, but read.table() imports the data file into a data frame. Each element of the vector returned by readLines() is the content of an entire line in the data file. 
varnames = readLines("auto-mpg-names.txt")
varnames
# if you used read.table("auto-mpg-names.txt") instead, then you need to extract the actual vector of names out of the dataframe by varnames = varnames[,1] or varnames = varnames[[1]]
# + 3.2 Run "names(data)". It returns the variable names of the data. Assign the new variable names to data by "names(data) = varnames". Check again the variable names, to see if they are updated correctly.
names(data)
names(data) = varnames
names(data)

# EX4. Data summary
# + 4.1. summarize the data structure and the class of each column (use str() );
str(data)
# + 4.2 apply function summary() on data and see how it is different from the function above. One nice thing is that it tells you #missing values for each variable (NA's). 
summary(data)


# EX5. Subset exercises 
# + 5.1 summarize the variable mpg (use summary()). (There are 3 ways you can get the variable mpg.) Do you see something weird in the result? What might be the reason? We will get back to this later.  
summary(data$mpg)
summary(data[, "mpg"])
summary(data[, 1])

# + 5.2 create a vector "index_cont" in R for the numbers 1,3,4,5,6, which are the column indices for the continuous variables; use that vector to extract the continuous variables and summarize the continuous variables (use summary()).
index_cont = c(1, 3:6) 
summary(data[,index_cont])

# + 5.3 (optional) use the index vector you created above to extract the non-continuous variables and summarize them ( using "-index_cont" for subsetting will return the complement of "index_cont"); 
summary(data[, -index_cont])

# + 5.4 (optional) read the help file for which(); create a vector of indices "index_origin_23" for the instances (rows) where origin is 2 or 3; create a new data that contains only the instances where origin is 2 or 3. Hint: logical operator: & for and, | for or, ! for NOT.  
index_origin_23 = which((data$origin == 2) |(data$origin == 3))
#or, 
index_origin_23 = which(data$origin != 1)
#or, 
index_origin_23 = which(data$origin %in% c(2,3))

# + 5.5 drop variable "car_name" (we will not use it in our analysis). Check the top few lines of the data. Hint: you can either assign NULL (empty) to the variable "car_name", or redefine data to be the subset of the data that does not contain "car_name". 
data$car_name = NULL
# or,
data  = data[,-9]


# EX6. Discrete variables 
# + 6.1 we are going to change the data, so please first make a copy of the original data (assign data to a new object "data_ori"); in case you do something wrong later you can easily reset the new data to be the original data.
data_ori = data
# + 6.2 origin is a categorical variable by nature, so we need to convert it to a factor type (use factor()), and assign it back to data$origin.  
data$origin = factor(data$origin)
# + 6.3 run "levels(data$origin)" to see the current labels for the variable origin. Change the labels for the values (1: American, 2: European, 3:Japanese). 
levels(data$origin) = c("American", "European", "Japanese")
# + 6.4 use summary() on the converted variable and see how the summary output changes for a factor variable.


# EX7. Missing values
# + 7.1 recall the weird values '-99' we saw before in 'mpg'. Sometimes the coding gets messed up and the unlikely values like "-99" are used to code missing values - in which case we should confirm this with the data entry clerk. Now assuming this has been confirmed, let's replace all "-99" with NA (not "NA"). 
data$mpg[data$mpg == -99] = NA
# + 7.2 use summary(data) to check if every variable looks reasonable now. Note: in reality, even dirtier data coding could happen, e.g. multiple bad codings, in which case histograms and boxplots will be useful - since we are able to see all weird values at the same time. Similar as checking outliers.  
summary(data)
# + 7.3 calculate the total number of missing values in data (use is.na() and sum()). And then rewrite it to make it a function total_NAs(x) that returns the total number of missing values in the dataset given in the argument "x". Test your function on the current data, it should return 17. 
sum(is.na(x))
total_NAs = function(x){
  return(sum(is.na(x)))
}
total_NAs(data)
# + 7.4 read the help file for function na.omit(), and use this function to create a new data (store it as data_noNA) that contains only the instances that has no missing value on any variables
data_noNA = na.omit(data)


# # From now on use the data set that contains no missing values (data_noNA)
# EX8. (optional) Exercises for *apply() and split()
# + 8.1 use one of the *apply() functions to get the frequency table on all discrete variables (use table()). Note that if these variables were all of factor type instead of numerical type, this could be directly done by summary(data[,c(2,7,8)]) 
sapply(data_noNA[,c(2, 7, 8)], table) 
# or,
lapply(data_noNA[,c(2, 7, 8)], table) 
# + 8.2 find average mpg for each # cylinders
tapply(data_noNA$mpg, data_noNA$cylinders, mean)
# + 8.3 find 2.5 and 97.5 percentile of mpg for each # cylinders 
tapply(data_noNA$mpg, data_noNA$cylinders, quantile, c(0.025, 0.975))
# + 8.4 split the dataset based on # cylinders 
data_by_origin = split(data_noNA, data_noNA$origin)


# EX9. (optional) Randomization testing for whether mean mpg is higher for Japanese cars than European cars
# + 9.1 calculate the difference between mean mpg for Japanese cars and European cars and save in object dif_JapVSEuro
dif_JapVSEuro = mean(data_by_origin$Japanese$mpg) - mean(data_by_origin$European$mpg)
# + 9.2 find the number of instances for European cars and save in object n_European
n_European = sum(data_noNA$origin == "European")
# + 9.3 write a for loop that does the following in each iteration:
#   + find the subset of European cars and Japanese cars
# + randomize the origin of the cars: randomly sample n_European instances to be "European" and the rest to be "Japanese"
# + calculate the new difference in the mean mpg of the randomized data (Jap - Euro)
# + record whether the new difference >= the observed difference, dif_JapVSEuro
# + 9.4 Run the simulation of 1000 iterations
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

# + 9.5 obtain the p value by calculating the proportion of times that the difference of the randomized data >= the observed difference. If this p value <= the alpha level we set for the test, then we can conclude mean mpg is higher for Japanese cars than European cars. 
p_val = mean(E_le_J)



# EX10. Histogram of the continuous variables: to check the outliers and the distribution of the variables
# + 10.1 generate a histogram for each continuous variable (mpg, displacement, horsepower, weight, acceleration) (manually plot each variable or use a for loop); save all plots in a pdf file and check the file (use pdf() and dev.off()). Need to install and load "ggplot2" package if you have not done so. 
library(ggplot2)
pdf("histogram-cont-vars.pdf")
ggplot(data_noNA, aes(mpg)) + geom_histogram()
ggplot(data_noNA, aes(displacement)) + geom_histogram()
ggplot(data_noNA, aes(horsepower)) + geom_histogram()
ggplot(data_noNA, aes(weight)) + geom_histogram()
ggplot(data_noNA, aes(acceleration)) + geom_histogram()
dev.off()
# + 10.2 (optional) reshape the continuous-variable-subset of the data and use facet_grid to generate a graph that contains the histograms for all the continuous variables. Hint: melt the data so that the values of all variables go into one column and with another column (a factor) recording which variable the value is from. The variable names will be the levels of this factor. Save the graph in a pdf file and check the file. You will need the "reshape2" package. 
library(reshape2)
data_noNA_cont_melt = melt(data_noNA[,index_cont])
head(data_noNA_cont_melt)
pdf("histogram-cont-vars-multiplot.pdf")
ggplot(data_noNA_cont_melt, aes(value)) + geom_histogram() + 
  facet_grid(.~variable, scales = "free_x")
dev.off()


# EX11. Boxplot to check relationship between a continuous variable and a categorical variable
# Boxplot of mpg by origin to visually check if mpg is different across different countries of origin. First look up how to make a boxplot in the online ggplot2 documentation. In order for boxplot to work, make sure the variable for the x-axis (origin in this case) is converted to factor type. After you've generated the plots, you can see mpg does look different across different origin categories, suggesting mpg is likely to depend on the car origin. We will do a formal statistical test later.
ggplot(data_noNA, aes(origin, mpg)) + geom_boxplot()

# + (optional) add an additional layer a)geom_point or b)geom_jitter() and see what happens
ggplot(data_noNA, aes(origin, mpg)) + geom_boxplot() + geom_jitter()
ggplot(data_noNA, aes(origin, mpg)) + geom_boxplot() + geom_point()

#   EX12. Scatterplot to check what the relationship of the two variables is like, e.g. linear or not.
# + 12.1. Scatterplot of mpg vs cylinders to check the relationship and see if it is suitable to treat cylinder as a numerical variable (linear) or categorical variable (not linear). For this task, first check the use of stat_smooth() and the argument "method". Generate a scatter plot with the default smooth curve fit overlayed, and the other scatter plot with a linear regression fit overlayed (method="lm"). The two fitted curves should both have non-zero slopes but look quite different, suggesting mpg and cylinders are associated, but not linearly associated, in which case we want to keep cylinder as a categorical variable. You can see very few cases have cylinder = 3 or 5; sometimes you may want to do a secondary analysis with those cases removed. 
ggplot(data_noNA, aes(cylinders, mpg)) + geom_point() + stat_smooth()
ggplot(data_noNA, aes(cylinders, mpg)) + geom_point() + stat_smooth(method="lm")
# + 12.2 (optional) create another data with instances with odd number of cylinders removed, and check the above plots again. The two fitted curves look similar -> could treat cylinder as numerical. 
data_noNA_evenCyl = data_noNA[data_noNA$cylinders%%2==0, ]
ggplot(data_noNA_evenCyl, aes(cylinders, mpg)) + geom_point() + stat_smooth()
ggplot(data_noNA_evenCyl, aes(cylinders, mpg)) + geom_point() + stat_smooth(method="lm")



# EX13. Scatterplot matrix 
# + Apply function pairs() or ggpairs() on the data to create the scatterplot matrix. Save the plot in a pdf file. If you use ggpairs(), you need to install and load R package "GGally".
# + to check the relationship between any pair of variable
# + to check for linearity assumption and homogeneity assumption
# + If violated, data transformation will be needed when building a linear regression model
# base plots: 
pairs(data_noNA)
# or, advanced plots
install.packages("GGally")
library(GGally)
ggpairs(data_noNA)


# EX14. Data transformation
# + Based on scatterplot matrix, we see increasing variance as mpg increases, and also non-linear relationship between mpg and other variables. We need to transform the variables.
# + Add the following new variables to the data. 
# + (a) log transformed versions of mpg, horsepower, displacement, and weight; name the new variables as logmpg, loghorsepower, etc. Hint: to add a new variable, e.g. log of mpg, you can assign 'log(data_noNA$mpg)' to 'data_noNA$logmpg'. 
data_noNA$logmpg = log(data_noNA$mpg)
data_noNA$loghorsepower = log(data_noNA$horsepower)
data_noNA$logdisplacement = log(data_noNA$displacement)
data_noNA$logweight = log(data_noNA$weight)
# + (b) a factor version of cylinders.
data_noNA$cylinders_cat = factor(data_noNA$cylinders)
  

#   EX15. Statistical analysis  
# + 15.1 ANOVA for origin. To formally test whether mean mpg is different across cars of the three origins, use significance level 0.05. First build a linear regression for mpg against origin. And then use both ANOVA() and summary() to check the results. 
model_origin = lm(mpg ~ origin , data = data_noNA)
summary(model_origin)
anova(model_origin)
# Both outputs show p value "< 2.2e-16", and therefore mpg does depend on car origin. 

# + 15.2 linear regression. Build a linear regression model to predict mpg. Include all other variables (use only the transformed version if available) (store the regression result in object 'model'); build another regression model using the same predictors but to predict log(mpg) (store in object 'model_log'). 
model = lm(mpg ~ cylinders_cat + logdisplacement + loghorsepower + 
             logweight + acceleration + model_year + origin , data = data_noNA)
model_log = lm(logmpg ~ cylinders_cat + logdisplacement + loghorsepower + 
                 logweight + acceleration + model_year + origin , data = data_noNA)
# + 15.3 Apply summary() on the regression objects and read the outputs. Is origin still helpful in predicting mpg/log(mpg) after including other predictors? 
summary(model)
summary(model_log)
# We can see that the p value (the column Pr(>|t|)) for originEuropean is above 0.05, but originJapanese is very small. After including other predictors, it seems that car origin is still helpful in predicting mpg, but due to the Japanese category not European cateogory. 

# + 15.4 Which column is to answer the relationship between mpg and other variables? 
# the column "Estimate". The number tells you on average how many units of increase in mpg is associated with one unit increase in the corresponding variable.  

# + 15.5 Run "newcase = data_noNA[1:10,]" to take the first 10 instances, and treat them as some new cars for which we want to predict mpg. Use predict() to predict mpg for them using respectively the object "model" and "model**_**log". Keep in mind that from "model_log", predict() returns the predictions for log(mpg) instead of mpg. 
newcase = data_noNA[1:10,]
predict(model, newcase)
exp(predict(model_log, newcase))

# + 15.6 Diagnostics (important in statistical analysis). Execute plot(model) and plot(model_log) in R and check the four plots for each model. You can find the specific help file for "plot()" for a lm object by executing "?plot.lm". Based on the diagnostic plots, are these reasonable models? Which one is better? Check the following aspects.  
# + (a) linearity assumption, (b) normality assumption, (c) constant variance (d) outliers
plot(model)
plot(model_log)
?plot.lm
# The residual plot for "model" has a non-linear trend, the residual does not look normal (quite skewed the right), the variance seems to go up as the fitted value goes up, and there are some outliers in the predictors. 
# The residual plot for "model_log" has no obvious pattern, the residual look closer to normal (still longer tail than normal but at least symmetric), the variance seems quite stable, although there are still some outliers in the predictors. 
# "model_log" looks more reasonable. 

# EX16. (optional) An independent exercise: play with opacity setting for scatterplot of carat vs price for the diamond data. Set alpha to be different functions of the variables and see what happens 
data(diamonds)
ggplot(diamonds, aes(price, carat)) + geom_point(aes(alpha=exp(carat)))

