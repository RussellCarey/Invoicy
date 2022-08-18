class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  private
  # Sends an email but no link needed to work with API as far as I know
  # Redirect not working. Will need to use this link given in frontend to activate account..
  def after_confirmation_path_for(resource_name, resource)
    
  end
end