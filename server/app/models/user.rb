# https://github.com/heartcombo/devise/wiki/How-To:-Add-:confirmable-to-Users

# Fields
#  "email",                                                   
#  "encrypted_password",                                      
#  "reset_password_token",                                    
#  "reset_password_sent_at",                                  
#  "remember_created_at",                                     
#  "created_at",                                              
#  "updated_at",                                              
#  "confirmation_token",                                      
#  "confirmed_at",                                            
#  "confirmation_sent_at",                                    
#  "phone_number",                                            
#  "company_name",                                            
#  "address_number",
#  "address_street",
#  "address_city",
#  "address_country",
#  "address_postcode"]


class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
  :jwt_authenticatable, 
  jwt_revocation_strategy: JwtDenylist
  :recoverable
  # :recoverable, :rememberable, :validatable,

  # Validations
  validates :email, presence: :true, uniqueness: true

  has_many :clients
  has_many :invoices, through: :clients

      # PATCH
    def self.set_premium_member(user_id, status)
        @user = User.find(user_id)
        if @user.update(:is_member: status)
            render json: @user
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    # PATCH
    def self.add_credits_to_user(user_id, value)
        @user = User.find(user_id)
        @user.credits += value

        if @user.save
            render json: @user
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end
end