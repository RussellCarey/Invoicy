module CheckAdmin
    extend ActiveSupport::Concern

        included do
            before_action :check_user_id_admin, only: %i[ index ]
        end

        def check_user_id_admin
            puts current_user.inspect
            return render json: {message: "You are not an admin"}, status: :unauthorized unless current_user.is_admin
        end
end