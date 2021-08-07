class CustomerReward < ApplicationRecord
    has_many :customer
    has_many :reward


    def self.is_reward_exist(reward_id, customer_id, start_date, end_date)
        is_reward_exist = where("reward_id = #{reward_id} and customer_id = #{customer_id} and created_at >= '#{start_date}' and created_at <= '#{end_date}'")
        if is_reward_exist.empty?
            generate_reward(reward_id, customer_id)
        end
        
    end

    def self.generate_reward(reward_id, customer_id)
        create!(
            customer_id: customer_id,
            reward_id: reward_id,
        )
    end


end
