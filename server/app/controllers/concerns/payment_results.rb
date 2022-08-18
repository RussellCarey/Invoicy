module PaymentResults
    extend ActiveSupport::Concern

        def set_premium_member(user_id, status, member_id)
            puts "User with ID #{user_id} has is trying to change his membership status to #{status}"
            @user = User.find(user_id)
            @user.is_member = status
            @user.member_id = member_id

            if @user.save
                puts "#{@user.email} has changed his membership to #{status}"
            else
                puts json: @user.errors
            end
        end

        def add_credits_to_user(user_id, value)
            puts "User with ID #{user_id} is trying to add #{value} credits"
            @user = User.find(user_id)
            @user.credits += value

            if @user.save
                puts "User with ID #{user_id} added #{value} credits!"
            else
                puts json: @user.errors
            end
        end
end