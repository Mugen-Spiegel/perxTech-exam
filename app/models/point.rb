class Point < ApplicationRecord

    FREE_COFFEE_IN_100_POINTS_EVERY_MONTH_REWARD = "Free Coffee reward in 100 points"
    CASH_REBATE_REWARD = "5% Cash Rebate"
    FREE_COFFEE_FOR_BIRTHDAY_MONTH_REWARD = "Free Coffee reward in birthday month"
    FREE_MOVIE_TICKET_REWARD = "Free Movie Tickets"
    AIRPORT_LOUNGE_REWARD = "Give 4x Airport Lounge"
    BONUS_POINTS_REWARD = "Give 100 bonus points"
    STANDARD_TIER = "standard"
    GOLD_TIER = "gold"
    PLATINUM_TIER = "platinum"

    # basic point computation for every customers transaction
    def self.points_computation(transaction)
        
        points = where(customer_id: transaction.customer_id, customer_transaction_id: transaction.id)
        if !(points.exists?)
            previous = where(customer_id: transaction.customer_id)
            previous_point = previous.empty? ? 0 : previous.last.total_points
            customer_country = transaction.customer.origin_country
            multiplier = transaction.country == customer_country ? 2 : 1
            points = ((transaction.amount.to_f * 0.10) * multiplier)
            total_points = previous_point.to_f + points.round(1)
            create!(
                points: points.round(1),
                total_points: total_points.round(1),
                multiplier: multiplier,
                customer_id: transaction.customer_id,
                customer_transaction_id: transaction.id,
                transaction_date: transaction.transaction_date
            )

            check_monthly_reward(transaction.customer_id)
            check_rebate_rewards(transaction.customer_id)
            check_customer_tier(transaction.customer_id)
        end
    end
    
    # Free Coffee reward in 100 points for every month
    def self.check_monthly_reward(customer_id)
        reward = Reward.where(reward_name: FREE_COFFEE_IN_100_POINTS_EVERY_MONTH_REWARD).first
        start_date = Date.current.beginning_of_month
        end_date = Date.current.end_of_month
        points = get_monthly_records(start_date, end_date)
        if points.last.total_points.to_i  >= 100
            CustomerReward.is_reward_exist(reward.id, customer_id, start_date, end_date)
        end
        
    end

    # A 5% Cash Rebate reward is given to all users who have 10 or more transactions that have an amount > $100
    def self.check_rebate_rewards(customer_id)

        reward = Reward.where(reward_name: CASH_REBATE_REWARD).first
        start_date = Date.current.beginning_of_year
        end_date = Date.current.end_of_year
        points = get_monthly_records(start_date, end_date)
        if points.count() >= 10 && points.last.total_points.to_i > 100
            CustomerReward.is_reward_exist(reward.id, customer_id, start_date, end_date)
        end

    end

    def self.get_monthly_records(start_date, end_date)
        points = where("transaction_date >= '#{start_date}' and 
            transaction_date <= '#{end_date}'")
    end

    # A Free Coffee reward is given to all users during their birthday month
    # This script will run every first day of the month
    def self.check_birthday_reward
        customers = Customer.where("birthdate LIKE '%-#{Date.today.strftime("%m")}-%'")
        reward = Reward.where(reward_name: FREE_COFFEE_FOR_BIRTHDAY_MONTH_REWARD).first
        customers.each do |customer|
            CustomerReward.generate_reward(reward.id, customer.id)
        end
    end

    # A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction
    def self.check_first_sixty_days
        end_date = Date.today
        sixty_days = Date.today - 60.days
        reward = Reward.where(reward_name: FREE_MOVIE_TICKET_REWARD).first
        transactions = CustomerTransaction.select('customer_id, amount')
        .where("transaction_date >= #{sixty_days}")
        .having('sum(amount) >= 1000').group('customer_id').sum('amount')
        transactions.each do |customer_id, amount|
            CustomerReward.is_reward_exist(reward.id, customer_id, sixty_days, end_date)
        end        
    end

    #A standard tier customer is an end user who accumulates 0 points
    # A gold tier customer is an end user who accumelates 1000 points
    # A platinum tier customer is an end user who accumulates 5000 points
    def self.check_customer_tier(customer_id)
        start_date = Date.current.beginning_of_year
        end_date = Date.current.end_of_year
        point = where("customer_id = #{customer_id} and transaction_date  LIKE '%#{Date.today.strftime("%Y")}-%' ")
        customer = Customer.find(customer_id)
        reward = Reward.where(reward_name: AIRPORT_LOUNGE_REWARD).first
        if point.exists?
            point = point.last
            if point.total_points.to_i >= 1000 && point.total_points.to_i <= 4999
                customer.tier = GOLD_TIER
                customer.save
                CustomerReward.is_reward_exist(reward.id, customer_id, start_date ,end_date)
            elsif point.total_points.to_i >= 5000
                customer.tier = PLATINUM_TIER
                customer.save
                CustomerReward.is_reward_exist(reward.id, customer_id, start_date ,end_date)
            end
        end
    end

    
    # This script will run using jobs for every end of the quarter
    def self.check_quarter_reward(quarter)
        start_date = Date.new(Date.today.year, quarter * 3 - 2)
        end_date = Date.new(Date.today.year, quarter * 3, -1)
        reward = Reward.where(reward_name: BONUS_POINTS_REWARD).first
        transactions = CustomerTransaction.where("transaction_date >= '#{start_date}' and transaction_date <= '#{end_date}'" ).
        having('sum(amount) >= 2000').group('customer_id').sum('amount')
        
        transactions.each do |customer_id, amount|
            CustomerReward.generate_reward(reward.id, customer_id)
            previous = where(customer_id: customer_id)
            previous_point = previous.empty? ? 0 : previous.last.total_points
            total_points = previous_point.to_f + 100
            create!(
                points: 100,
                total_points: total_points.round(1),
                customer_id: customer_id
            )
        end

    end
end
