# EX0. Set working directory
# + use setwd() to set the working directory to the folder where the data files are. 
setwd('./data/') # replace "./data/" to the path of the folder where your data files are

# EX1. Import data
# + 1.1  to mport the data "auto-mpg.csv" and store it as an object "data", run the code data = read.csv(file = "auto-mpg.csv", header = FALSE, na.strings= "NA"). We need to set header = FALSE since the data starts right from the first line (no header). Look at the data set to see what string/symbol is used to denote missing values; in this data "NA" is used, so na.strings = "NA" is specified in the read.csv(). You can also use read.table() but you will need to specify sep="," additionally. 
data = read.csv(file = "auto-mpg.csv", header = FALSE)

# + 1.2 (optional) Read data file "auto-mpg.data-original". What happens and why? Check the original data file.
data_baddata = read.table(file = "auto-mpg.data-original", header = FALSE, sep=" ")
# It returns error because the data format is not suitable for read.table or read.csv. It has fixed width format so you need to use read.fwf() and specify the column widths. Therefore you need to know the column widths in advance; if you don't know, you can look at the data and count the widths). Or, you can open the data in Excel which automatically obtains the column widths, convert it to a csv file, and import the data using read.csv(). 

# EX2. General check for the data
# + 2.1 check the top 6 rows of data; open the original data in excel or notepad and compare with the rows printed in R. 
head(data)
# + 2.2. check the dimension of data
dim(data)

# EX3. Add variable names to data
# + 3.1 read variable names from "auto-mpg-names.txt" using readLines(). The difference between readLines() and read.table() is that readLines() imports the data file into a vector of strings, but read.table() imports the data file into a data frame (could be any data type depending on the actual data values). Each element of the vector returned by readLines() is the content of a entire line in the data file. 
varnames = readLines("auto-mpg-names.txt")
# if you used read.table("auto-mpg-names.txt") instead, then you need to extract the actual vector of names out of the dataframe by varnames = varnames[,1] or varnames = varnames[[1]]
# + 3.2 assign variable names to data (you can assign values to names(data) to change the names of data)
names(data) = varnames
# + 3.3 check if the variable names are correctly assigned. Hint: you can either print the variable names of the data or print the top rows of the data
names(data)
# or,
head(data)

# EX4. Data summary
# + 4.1. use a function to summarize the data structure and the class of each column;
str(data)
# + 4.2 apply function summary() on data and see how it is different from the function above. One nice thing is that it tells you #missing values for each variable
summary(data)


# EX5. Subset exercises 
# + 5.1 summarize the variable mpg (use summary()). (There are 3 ways you can get the variable mpg.) Do you see something weird in the result? What might be the reason? We will get back to this later. 
summary(data$mpg)
summary(data[, "mpg"])
summary(data[, 1])

# + 5.2 create a vector in R for the numbers 1,3,4,5,6, which are the column indices for the continuous variables; use that vector to extract the continuous variables and summarize the continuous variables (use summary()).
index_cont = c(1, 3:6) 
summary(data[,index_cont])

# + 5.3 use the index vector you created above to extract the non-continuous variables and summarize them; compare how summary() works differently for a factor variable (car_name) from a numerical variable.
summary(data[, -index_cont])

# + 5.4 (optional) read the help file for which(); create a vector of indices for the instances (rows) where origin is 2 or 3; create a new data that contains only the instances where origin is 2 or 3. Hint: logical operator: & for and, | for or, ! for NOT.  
index_origin_23 = which((data$origin == 2) |(data$origin == 3))
#or, 
index_origin_23 = which(data$origin != 1)
#or, 
index_origin_23 = which(data$origin %in% c(2,3))

# + 5.5 drop variable "car_name". We will not use it in our analysis. Hint: you can either assign NULL (empty) to the variable "car_name", or redefine data to be the subset of the data that does not contain "car_name". 
data  = data[,-9]
# or,
data$car_name = NULL


# EX6. Discrete variables 
# + 6.1 check and apply function table() on variable cylinders
table(data$cylinders)
# + 6.2 use a loop to print the name and the frequency table for each discrete variable. Note that there are very few instances with odd number of cylinders. We will revisit this. Also... weird value -99 again? 
for(i in c(2,7,8)){
  print(names(data)[i])
  print(table(data[,i]))
}
# + 6.3 we are going to change the data, so please first make a copy of the original data; in case you do something wrong later you can easily reset the new data to be the original data. 
data_ori = data
# + 6.4 origin is a categorical variable by nature, so we are going to convert it to a factor type. But before doing that, we need to first fix the weird values "-99" - sometimes the coding gets messed up and the unlikely values like "-99" are used to code missing values - in which case we should confirm this with the data entry clerk. Now assuming this has been confirmed, let's replace all "-99" in origin with NA (not "NA"). 
data$origin[data$origin == -99] = NA
# + 6.5 table() the new variable and check if "-99" is successfully replaced. 
table(data$origin)
# + 6.6 convert variable origin into factor type, and then add the labels for the values (1: American, 2: European, 3:Japanese). 
data$origin = factor(data$origin)
levels(data$origin) = c("American", "European", "Japanese")
# + 6.7 check the variable type of the converted variable and the variable from the original data
class(data$origin)
class(data_ori$origin)


# EX7. Missing values
# + 7.1 First let's also fix the "-99" in mpg as for origin. 
data$mpg[data$mpg == -99] = NA
# + 7.2 use summary(data) to check if every variable looks reasonable now. Note: in reality, even dirtier data coding could happen, e.g. multiple bad codings, in which case histograms and boxplots will be useful - since we are able to see all weird values at the same time. Similar as checking outliers.  
summary(data)
# + 7.3 using is.na() function, take a subset of the dataset that has non-missing mpg and check the dimension of the subset. Hint: !is.na() refers to NOT NA. 
dim(data[!is.na(data$mpg), ])
# + 7.4 write a function total_NAs(x) that returns the total number of missing values in the dataset given in the argument "x". Test your function on the current data, it should return 17. 
total_NAs = function(x){
  return(sum(is.na(x)))
}
total_NAs(data)
# + 7.5 read the help file for function na.omit(), and use this function to create a new data (name it as data_noNA) that contains only the instances that has no missing value on any variables
data_noNA = na.omit(data)


# # From now on use the data set that contains no missing values
# EX8. (optional) Exercises for *apply() and split()
# + 8.1 use one of the *apply() functions to get the frequency table on all discrete variables. Note that if these variables were all of factor type instead of numerical type, this could be directly done by summary(data[,c(2,7,8)]) 
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
# + calcualte the new difference in the mean mpg of the randomized data (Jap - Euro)
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
p_val = mean(E_le_J)
# + 9.5 obtain the p value by calculating the proportion of times that the difference of the randomized data >= the observed difference. If this p value <= the alpha level we set for the test, then we can conclude mean mpg is higher for Japanese cars than European cars. 
p_val = mean(E_le_J)



# EX10. Histogram of the continuous variables: to check the outliers and the distribution of the variables
# + 10.1 generate a histogram for each variable (one histogram per plot); save all plots in a pdf file and check the file. Need to install and load "ggplot2" package if you have not done so. 
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


# EX11. Boxplot of mpg by different levels of origin to visually check if mpg is different across different categories. First look up how to make a boxplot in the online ggplot2 documentation. In order for boxplot to work, make sure the variable for the x-axis (origin in this case) needs to be of factor type. After you've generated the plots, you can see mpg does look different across different origin categories, suggesting mpg is likely to depend on the car origin. We will do a formal statistical test later.   
ggplot(data_noNA, aes(origin, mpg)) + geom_boxplot()

# + (optional) add an additional layer a)geom_point or b)geom_jitter() and see what happens
ggplot(data_noNA, aes(origin, mpg)) + geom_boxplot() + geom_jitter()
ggplot(data_noNA, aes(origin, mpg)) + geom_boxplot() + geom_point()


#   EX12. Scatterplot of mpg vs cylinders to check what the relationship is like, and to check if it is suitable to treat cylinder as a numerical variable or categorical variable.
# + 12.1. check the use of stat_smooth() and the argument "method". Generate a scatter plot with the default smooth curve fit overlayed, and the other scatter plot with a linear regression fit overlayed. The two fitted curves should both have non-zero slopes but look quite different, suggesting mpg and cylinders are associated, but not linearly associated, in which case we want to keep cylinder as a categorical variable. You can see very few cases have cylinder = 3 or 5; sometimes you may want to do a secondary analysis with those cases removed. 
ggplot(data_noNA, aes(cylinders, mpg)) + geom_point() + stat_smooth()
ggplot(data_noNA, aes(cylinders, mpg)) + geom_point() + stat_smooth(method="lm")
# + 12.2 (optional) create another data with instances with odd number of cylinders removed, and check the above plots again. The two fitted curves look similar -> could treat cylinder as numerical. Hint: you can either print the variable names of the data or print the top rows of the data
data_noNA_evenCyl = data_noNA[data_noNA$cylinders%%2==0, ]
ggplot(data_noNA_evenCyl, aes(cylinders, mpg)) + geom_point() + stat_smooth()
ggplot(data_noNA_evenCyl, aes(cylinders, mpg)) + geom_point() + stat_smooth(method="lm")



# EX13. Scatterplot matrix 
# + Apply function pairs() or ggpairs() on the data to create the scatterplot matrix. If you use ggpairs(), you need to install and load R package "GGally".
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
# + Add new variables to the data: 
# + (a) log transformed versions of mpg, horsepower, displacement, and weight. Hint: to add a new variable, e.g. log of mpg, you can run data_noNA$logmpg = log(data_noNA$mpg), where "logmpg" is the name for the new variable you choose. 
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

# + 15.2 linear regression. Build a linear regression model to predict mpg. Include all other variables but if a transformed version is available for a variable, use only the transformed version) (name the regression object as model); build another regression model using the same predictors but to predict log(mpg) (name the regression object as model_log). 
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

# + 15.5 Diagnostics (important in statistical analysis). Execute plot(model) and plot(model_log) in R and check the four plots for each model. You can find the specific help file for "plot()" for a lm object by executing "?plot.lm". Based on the diagnostic plots, are these reasonable models? Which one is better? Check the following aspects.  
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

