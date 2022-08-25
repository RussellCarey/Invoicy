class ClientsController < ApplicationController
  include CheckAdmin

  before_action :authenticate_user!
  before_action :set_client, only: %i[ show update destroy ]
  before_action :check_user_owns_resource, only: %i[ show update destroy ]


  # GET /clients
  def index
    clients = Client.all
    render json: clients
  end

    # GET /clients/all
  def all
    page = params[:page].to_i
    page_size = (params[:limit] || 10).to_i

    clients = Client.where("user_id = ?", current_user.id)
    clients.offset(page * page_size).limit(page_size)
    render json: clients
  end

  # GET /clients/1
  def show
    render json: @client
  end

  # POST /clients
  def create
    client = Client.new(client_params)
    client.user_id = current_user.id

    if @client.save
      render json: client, status: :created
    else
      render json: client.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      render json: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:email, :first_name, :last_name, :phone, :note, :is_active, :address_number, :address_street, :address_city, :address_county, :address_postcode)
    end

    def check_user_owns_resource
      if(@client.user_id != current_user.id)
        return render json: { message: "You dont not own this resource"}, status: :unauthorized
      end
    end
end
