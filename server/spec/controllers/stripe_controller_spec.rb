# expect(response).to include products.first.name

require 'rails_helper'
require 'api_helper'

RSpec.describe StripeController, :type => :controller do
    include ApiHelper

    let(:test_user) { Fabricate(:user) }
    let(:admin_user) { Fabricate(:user) }

    before do
        sign_in test_user
    end

    context 'checkout session' do
        it 'can create a stripe checkout session and return it to the user' do
            authenticated_header(request, test_user)

            post :create_checkout_session, params: { price_id: "price_1LXxxiCwt4CLusOHnwmAINJT", qty: 10 }, as: :json

            expect(response.content_type).to include("application/json")
            expect(response.body).to include 'sessionURL'
            expect(response.body.length).to_not eq 0
            assert_response :success
        end
    end

    context 'subscription session' do
        it 'can create a stripe checkout session and return it to the user' do
            authenticated_header(request, test_user)

            post :create_subscription_session, params: { price_id: "price_1LXzPJCwt4CLusOHzIWxs8Wp"}, as: :json

            expect(response.content_type).to include("application/json")
            expect(response.body).to include 'sessionURL'
            expect(response.body.length).to_not eq 0
            assert_response :success
        end
    end

     context 'products' do
        it 'can get all products from stripe (admin)' do
            authenticated_header(request, test_user)

            get :get_all_products, params: { limit: 100 }, as: :json

            expect(response.content_type).to include("application/json")
            assert_response :success
        end

        it 'can get a single product from stripe (admin)' do
            authenticated_header(request, test_user)

            post :get_product, params: { product_id: 'prod_MGUxio0I8QjCOv' }, as: :json

            expect(response.content_type).to include("application/json")
            assert_response :success
        end
    end
end