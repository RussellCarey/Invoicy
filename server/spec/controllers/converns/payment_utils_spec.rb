require 'rails_helper'
require 'api_helper'

class PaymentController < ApplicationController
  include PaymentUtils
end

RSpec.describe PaymentController do
    let!(:test_user) { Fabricate(:user) }

    before do
        sign_in test_user
    end

    context 'Creating checkouts session' do
        it 'creates a payment session' do
            checkout_session = subject.create_payment("price_1LXxxiCwt4CLusOHnwmAINJT", 10);
            expect(checkout_session['url']).to be
        end
     end

     context 'Creating subscription session' do
        it 'creates a payment session' do
            checkout_session = subject.create_subscription("price_1LXzPJCwt4CLusOHzIWxs8Wp", 1);
            expect(checkout_session['url']).to be
        end
     end

end