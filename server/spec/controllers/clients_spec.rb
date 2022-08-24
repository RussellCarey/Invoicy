require 'rails_helper'

RSpec.describe ClientsController, :type => :controller do
    let(:test_user) { User.create(email: "test@test.com", password: "11111111", is_admin: false, confirmed_at: "02/02/2021") }
    let(:test_user_admin) { User.create(email: "test@test.com", password: "11111111", is_admin: true, confirmed_at: "02/02/2021") }

    context 'GET #index' do
        before do  
            request.accept = "application/json"
        end

        it 'Succeeds if user is an admin' do
            sign_in test_user_admin
            get :index
            assert_response :success
        end

        it 'Fails if user is not an admin' do
            sign_in test_user
            get :index
            assert_response :unauthorized
        end
    end
end