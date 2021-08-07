# README

This README would normally document whatever steps are necessary to get the
application up and running.






```` 

Bundle install - to install all dependencies

rails db:create - to create the database

rails db:migrate - to create the migrate all the tables

rails db:seed - to seed the data and also I put the script to test the whole process

NOTE: I did not put any endpoint in routes.. To test the whole process you can use the db:seed or run this command:

rails c - go to console

paste this script 

CustomerTransaction.all.each do |transaction|
    Point.points_computation(transaction)
end

#Every calendar quarterly give 100 bonus points for any user spending greater than $2000 in that quarter
# 1, 2, 3, 4 quarter

Point.check_quarter_reward(3)

```` 

