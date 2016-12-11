#Problem Statement 2

#Read the Joined CSV File and rename review_user_business.csv file
yelp_data <-read.csv("review_user_business.csv")

#Run the data manipulation tool library
library(dplyr)


#find "indian" in "categories" column, add cat_ind attribute and set T or F accordingly
yelp_data$cat_ind <- grepl("ind", yelp_data$categories) == TRUE

#create ind dataframe for indian restaurants
ind <- subset(yelp_data, cat_ind == TRUE)

#create reviews based on cuisine by each user
rev_ind <- ind %>% select(user_id, username, cat_ind) %>% group_by(user_id) %>% summarise(rev_tot = sum(cat_ind))

#print table, count and mean
table(rev_ind$rev_tot)
count(rev_ind)
mean(rev_ind$rev_tot)



# join the num_reviews info with data frame of ind restaurant reviews
join_rev_ind <- inner_join(ind, rev_ind)

# compute "weighted_stars" for furthur calculation
join_rev_ind$weighted_stars <- join_rev_ind$stars * join_rev_ind$rev_tot

# Use "summarise" to generate a new_average rating for all restaurant
new_ind_rate <- join_rev_ind %>% select(city, business_name, avg_stars, stars,rev_tot, weighted_stars) %>% group_by(city, business_name, avg_stars) %>% 
summarise(cnt = n(),average = sum(stars) / cnt,new_average = sum(weighted_stars) / sum(rev_tot),difference = new_average - average)

# Print summary 
summary(new_ind_rate$difference)

# limit users with atleast five ratings
nri5 <- subset(new_ind_rate, cnt > 5)

#print summary
summary(nri5$difference)



############################################

#Problem Statement 3

# Read indian names in ind_names
ind_names <- scan("ind_names.txt", what = character())

#compare ind_names in "username" 
ind$rev_ind_name <- ind$username %in% ind_names

# create "ind_stars" for calculation
ind$ind_stars <- ind$stars * ind$rev_ind_name

# find reviewers with unique ind names
table(ind$rev_ind_name)

# create new_average "immigrant" rating
avg_ind_rate <- ind %>% select(business_id, business_name, city, stars,avg_stars, rev_ind_name,cat_ind, ind_stars) %>% group_by(city, business_name, avg_stars) %>%
  summarise(count = n(), # tot reviews
            a = sum(rev_ind_name), # indian reviews
            b = sum(rev_ind_name) / n(), #fraction of reviews done by indians
            average = sum(stars) / count, 
            average_ind_rev = sum(ind_stars) / a, 
            difference = average_ind_rev - average)

# print new_average rating
summary(avg_ind_rate$difference)

# limit users with atleast five ratings
ari5 <- subset (avg_ind_rate, a > 5)  

#print summary                                      
summary(ari5$difference)
