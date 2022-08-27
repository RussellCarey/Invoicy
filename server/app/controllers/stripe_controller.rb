require 'rubygems'
require 'stripe'

# gem 'figaro' - bundle exec figaro install - use ENV 
class StripeController < ApplicationController
    include PaymentUtils

    before_action :authenticate_user!, only: %i[ create_checkout_session, create_subscription_session, create_product, get_all_products, get_product cancel_subscription ]
    before_action :check_user_id_admin, only: %i[ create_product  get_all_subscriptions ]
    Stripe.api_key = ENV["stripe_api_key"]

    # Redirect user to pre-built checkout page with defined URLS for their redirect.
    def create_checkout_session
        price_id = params[:price_id]
        product_qty = params[:qty]
        return render json: { message: "Missing price or qty"}, status: :not_found if price_id.nil? || product_qty.nil?

        session = create_payment(4, price_id, product_qty);
        render json: {sessionURL:  session.url}, status: :ok
    end

    def create_subscription_session
        price_id = params[:price_id]
        return render json: { message: "Missing price or qty"}, status: :not_found if price_id.nil?

        session = create_subscription(4, price_id, 1);
        render json: {sessionURL:  session.url}, status: :ok
    end
    
    # Subscriptions
    def get_all_subscriptions 
        limit = params[:limit] ||= 100;
        subscriptions = Stripe::Subscription.list({limit: limit})
        render json: {subscriptions: subscriptions}, status: :ok
    end

    # errors?
    def cancel_subscription
        user_subscription_token = current_user.member_id

        if delete_now
            Stripe::Subscription.update(user_subscription_token, {cancel_at_period_end: true})
        else
            Stripe::Subscription.delete(user_subscription_token)
        end
    end

    # Products
    def create_product
        product_name = params[:name]
        product_price = params[:price]

        price_data = {
            currency: 'jpy',
            unit_amount: product_price
        }

        new_product = Stripe::Product.create({name: product_name, default_price_data: price_data })

        render json: {product: new_product}, status: :ok
    end

    def get_all_products
        limit = params[:limit] ||= 100;
        products = Stripe::Product.list({limit: limit})
        render json: {products: products}, status: :ok
    end

    def get_product
        product_code = params[:product_id]
        product = Stripe::Product.retrieve(product_code)
        render json: {product: product}, status: :ok
    end

    def delete_product
        product_code = params[:product_id]
        product = Stripe::Product.delete(product_code)
        render json: {product: product}, status: :ok
    end

    # https://stripe.com/docs/webhooks/test
    # stripe listen --forward-to localhost:3000/stripe/webhook
    # https://stripe.com/docs/api/events/types
    def webhook
        payload = request.body.read
        event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))

        case event.type            
            when 'customer.subscription.deleted'
                set_premium_member(event.data.object.metadata.user_id, false, nil)

            when 'invoice.payment_succeeded'
                user_id = event.data.object.lines.data[0].metadata.user_id;

                if event.data.object.lines.data[0].type === "subscription"
                    set_premium_member(user_id , true, event.data.object.lines.data[0].subscription)
                else
                    # Hardcode for now..
                    add_credits_to_user(user_id , 200)
                end
        end
    end

    private
    def check_user_id_admin
        return render json: { message: "You are not an admin and cannot access this resource" }, status: :unauthorized unless current_user.is_admin
    end

    def user_params
      params.fetch(:user, {}).permit(:price_id, :qty, :product_id, :name, :price)
    end
end




