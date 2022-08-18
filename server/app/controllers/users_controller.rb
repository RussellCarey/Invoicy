class UsersController < ApplicationController
    before_action :authenticate_user!

    # PATCH
    def update 
        @user = User.find(current_user.id)
        if @user.update(user_params)
            render json: @user
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end
    
    private
     # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {}).permit(:email, :phone_number, :address_city, :address_county, :address_number, :address_postcode, :address_street, :credits, :is_member)
    end
end