# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


CustomerTransaction.destroy_all
Customer.destroy_all
Client.destroy_all

10.times do |index|
    Client.create!(
        company_name: Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 0).chop,
        company_address: Faker::Name.name,
)
end


client = Client.all()

client.each do |v|
    10.times do |index|
        Customer.create!(
            last_name: Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 0).chop,
            first_name: Faker::Name.name,
            birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
            origin_country: ["USA", "CHN", "PH"].sample,
            client_id: v['id'],
            points: 0,
            tier: 'standard',
            types: 'new',
        )
    end
end



customer = Customer.all

customer.each do |v|
    10.times do |index|
        CustomerTransaction.create!(
            amount: rand(1000..5000) + index,
            currency: ["USD", "CAD"].sample,
            transaction_date: Date.current,
            country: ["USA", "CHN", "PH"].sample,
            client_id: v['client_id'],
            customer_id: v['id'],
        )
    end
end

Reward.create!(
    reward_name: "Free Movie Tickets",
    start_date: Date.current,
    condition: "A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction",
)

Reward.create!(
    reward_name: "5% Cash Rebate",
    start_date: Date.current,
    condition: "A 5% Cash Rebate reward is given to all users who have 10 or more transactions that have an amount > $100",
)

Reward.create!(
    reward_name: "Free Coffee reward in 100 points",
    start_date: Date.current,
    condition: "If the end user accumulates 100 points in one calendar month they are given a Free Coffee reward",
)

Reward.create!(
    reward_name: "Free Coffee reward in birthday month",
    start_date: Date.current,
    condition: "A Free Coffee reward is given to all users during their birthday month",
)


Reward.create!(
    reward_name: "Give 4x Airport Lounge",
    start_date: Date.current,
    condition: "Give 4x Airport Lounge Access Reward when a user becomes a gold tier customer",
)

Reward.create!(
    reward_name: "Give 100 bonus points",
    start_date: Date.current,
    condition: "Every calendar quarterly give 100 bonus points for any user spending greater than $2000 in that quarter",
)



#TEST


CustomerTransaction.all.each do |transaction|
    Point.points_computation(transaction)
end


#Every calendar quarterly give 100 bonus points for any user spending greater than $2000 in that quarter
# 1, 2, 3, 4 quarter
Point.check_quarter_reward(3)