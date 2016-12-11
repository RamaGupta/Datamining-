
import numpy as np
import csv
import pandas as pd

"""
business = pd.read_csv("yelp_academic_dataset_business.csv")
user= pd.read_csv("yelp_academic_dataset_user.csv")
review = pd.read_csv("yelp_academic_dataset_review.csv")

review = pd.read_csv("review.csv")"""



with open('review.csv',newline='') as file:
    r = csv.reader(file)
    dataset= [line for line in r]
with open('review.csv','w',newline='') as file:
    w = csv.writer(file)
    w.writerow(['votes','user_id','text','business_id', 'stars'])
    w.writerows(dataset)
    

with open('yelp_academic_dataset_business.csv',newline='') as file:
    r = csv.reader(file)
    dataset= [line for line in r]
with open('yelp_academic_dataset_business.csv','w',newline='') as file:
    w = csv.writer(file)
    w.writerow(['business_id', 'city', 'business_name' , 'categories', 'review_count', 'avg_stars'])
    w.writerows(dataset)

    
with open('yelp_academic_dataset_user.csv',newline='') as file:
    r = csv.reader(file)
    dataset= [line for line in r]
with open('yelp_academic_dataset_user.csv','w',newline='') as file:
    w = csv.writer(file)
    w.writerow(['user_id','username'])
    w.writerows(dataset)
"""
"""code to merge files"""

"""review_user = .merge(user, on='user_id')
review_user.to_csv("review_user.csv", index=False)
"""
"""review_userb = review_user.merge(business, on='business_id')
review_userb.to_csv("review_userb.csv", index=False)
"""
