module PaymentUtils
    extend ActiveSupport::Concern

        def create_payment(user_id, price_id, product_qty)
            return session = Stripe::Checkout::Session.create({
                mode: 'payment',
                line_items: [{
                    price: price_id,
                    quantity: product_qty,
                }],
                payment_intent_data: { metadata: { user_id: user_id}},
                metadata: { user_id: current_user.id },
                success_url: 'https://localhost:3000/success.html',
                cancel_url: 'https://localhost:3000/cancel.html',
            })
        end

        def create_subscription(user_id, price_id, product_qty)
            return session = Stripe::Checkout::Session.create({
                mode: 'subscription',
                line_items: [{
                    price: price_id,
                    quantity: product_qty,
                }],
                subscription_data: { metadata: { user_id: 4 }},
                success_url: 'https://localhost:3000/success.html',
                cancel_url: 'https://localhost:3000/cancel.html',
            })
        end

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