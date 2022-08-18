class MemberController < ApplicationController
before_action :authenticate_user!

def show 
    user = get_user_from_token()
    render json: {
        status: "success",
        message: "You are logged in."
    }
end

private
def get_user_from_token
    secret_key = Rails.application.credentials.devise[:jwt_secret_key]
    split_token = request.headers['Authorization'].split(' ')[1]
    jwt_payload = JWT.decode(split_token, secret_key).first

    user_id = jwt_payload['susb']
    user = User.find(user_id.to_s);
end
end