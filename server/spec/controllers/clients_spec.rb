require 'rails_helper'
require 'api_helper'

RSpec.describe ClientsController, :type => :controller do
    include ApiHelper

    let(:test_user) { User.create(email: "123@test.com", password: "11111111", is_admin: false, confirmed_at: "02/02/2021") }
    let(:test_user_admin) { User.create(email: "1234@test.com", password: "11111111", is_admin: true, confirmed_at: "02/02/2021") }
    let!(:added_client) { Client.create(email: "12345@test.com", first_name: "Mrrr", last_name: "Client", address_number: 36, address_street: "sdfsdf", address_city: '23423432', address_county: '243234', address_postcode: "PO33RFV", user_id: test_user.id) }
    let!(:added_client_two) { Client.create(email: "1234567@test.com", first_name: "Mrrr", last_name: "Client", address_number: 36, address_street: "sdfsdf", address_city: '23423432', address_county: '243234', address_postcode: "POs212VV", user_id: test_user_admin.id) }

    before do
        sign_in test_user
    end

    context 'GET #all' do
        it 'Can get the users owned clients and return them' do
            authenticated_header(request, test_user)
            get :all, as: :json
            expect(JSON.parse(response.body).length).to eq(1);
            assert_response :success
        end

        it 'Cannot get all clients if not logged in' do
            sign_out test_user
        
            get :all, as: :json
            assert_response :unauthorized
        end
    end

     context 'GET #show' do
        it 'Can find and return a single resource ONLY if it is owned by the user' do
            authenticated_header(request, test_user)
            new_client = Fabricate(:client, user_id: test_user.id)
            get :show, params: { id: new_client.id }, as: :json
            assert_response :success
        end

        it 'Cannot get a client if not logged in' do
            sign_out test_user
            get :show, params: { id: 2 }, as: :json
            assert_response :unauthorized
        end
    end

    context 'POST #create' do
        it 'Can create a new client' do
            authenticated_header(request, test_user)
            post :create, params: {email: "testingclientt@test.com", first_name: "Mrrr", last_name: "Client", address_number: 36, address_street: "sdfsdf", address_city: '23423432', address_county: '243234', address_postcode: "PO33RFV", user_id: test_user.id}, as: :json
            assert_response :created
        end

         it 'Cannot post client if not logged in' do
            sign_out test_user

            post :create, params: {email: "testingclientt@test.com", first_name: "Mrrr", last_name: "Client", address_number: 36, address_street: "sdfsdf", address_city: '23423432', address_county: '243234', address_postcode: "PO33RFV", user_id: test_user.id}, as: :json
            assert_response :unauthorized
        end
    end

    # context 'PUT #update' do
    #      it 'Can updated a new client' do
    #         authenticated_header(request, test_user)
    #         put :update, params: { email: "edited@test.com" }, as: :json
    #         assert_response :updated
    #     end

    #      it 'Cannot updated client if not logged in' do
    #         sign_out test_user

    #         put :update, params: { email: "edited@test.com" }, as: :json
    #         assert_response :unauthorized
    #     end
    # end

    # context 'DELETE #destroy' do
    #     it 'Can delete a client' do
    #         authenticated_header(request, test_user)
    #         delete :destory, params: {id: 3}, as: :json            
    #         assert_response :deleted
    #     end

    #     it 'Can not delete client if not logged in' do
    #         sign_out test_user

    #         delete :destory, params: {id: 3}, as: :json
    #         assert_response :unauthorized
    #     end
    # end


    
    context 'GET #index ' do
        it 'Can check the user is an admin and can return all clients' do
            sign_in test_user_admin
            authenticated_header(request, test_user_admin)
            get :index, as: :json
            expect(JSON.parse(response.body).length).to eq(2);
            assert_response :success
        end

        it 'Will fail as the user is not an admin' do
            authenticated_header(request, test_user)
            get :index, as: :json
            assert_response :unauthorized
        end
    end
end