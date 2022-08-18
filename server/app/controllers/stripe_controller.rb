require 'rubygems'
require 'stripe'

# gem 'figaro' - bundle exec figaro install - use ENV 
class StripeController < ApplicationController
    before_action :authenticate_user!, only: %i[ create_checkout_session, create_subscription_session, create_product, get_all_products, get_product ]
    before_action :check_user_id_admin, only: %i[ create_product ]
    Stripe.api_key = ENV["stripe_api_key"]

    # Redirect user to pre-built checkout page with defined URLS for their redirect.
    def create_checkout_session
        price_id = params[:price_id]
        product_qty = params[:qty]

        return render json: { message: "Missing price or qty"}, status: :not_found if price_id.nil? || product_qty.nil?

        session = Stripe::Checkout::Session.create({
            line_items: [{
            price: price_id,
            quantity: product_qty,
            }],
            payment_intent_data: { metadata: { user_id: 4}},
            metadata: {user_id: current_user.id},
            mode: 'payment',
            success_url: 'https://localhost:3000/success.html',
            cancel_url: 'https://localhost:3000/cancel.html',
        })

        render json: {sessionURL:  session.url}, status: :ok
    end

    def create_subscription_session
        price_id = params[:price_id]
        puts params[:price_id]

        session = Stripe::Checkout::Session.create({
            mode: 'subscription',
            line_items: [{
                quantity: 1,
                price: price_id,
            }],
            subscription_data: { metadata: {user_id: 4}},
            success_url: 'https://localhost:3000/success.html?session_id={CHECKOUT_SESSION_ID}',
            cancel_url: 'https://localhost:3000/cancel.html',
        })

        render json: {sessionURL:  session.url}, status: :ok
    end
    
    # ADMIN
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
        puts "WEBOOK FOR STRIPE HAS BEEN FIRED"
        payload = request.body.read
        event = nil

        event = Stripe::Event.construct_from(
            JSON.parse(payload, symbolize_names: true)
        )

        puts event.type
        puts event.data.object.metadata

        case event.type
            when 'payment_intent.created'
                puts "PAYMENT METHOD CREATEDDD"

            when 'payment_intent.succeeded'
                puts "PAYMENT METHOD SUCCESSDD"
                # payment_intent = event.data.object # contains a Stripe::PaymentIntent
                # Then define and call a method to handle the successful payment intent.
                # handle_payment_intent_succeeded(payment_intent)

            when 'charge.succeeded'
                puts "PAYMENT CHARGE SUCCEEDED"
                
                user = User.find(event.data.object.metadata.user_id)
                user.credits += 200;
                user.save

            when 'customer.subscription.created'
                puts "A SUBSCRIPTION HAS BEEN MADE"

                user = User.find(event.data.object.metadata.user_id)
                user.is_member = true;
                user.save

            else
                puts "Unhandled event type: #{event.type}"
        end

        render json: {message: "test"}, status: :ok
    end

    private
    def check_user_id_admin
            return render json: {message: "You are not an admin"}, status: :unauthorized unless current_user.is_admin
     end
end




