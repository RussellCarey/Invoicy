class InvoiceItemsController < ApplicationController
  include CheckAdmin

  before_action :authenticate_user!
  before_action :set_invoice_item, only: %i[ show update destroy ]
  before_action :check_user_owns_resource, only: %i[ update destroy ]


  # POST /invoice_items
  def create
    # CHeck user owns invoice being added too..
    invoice = Invoice.find(params[:invoice_id]);
    return render json: { message: "You dont not own this resource"}, status: :unauthorized if (invoice.user_id != current_user.id)
        
    invoice_item = InvoiceItem.new(invoice_item_params)
    invoice_item.invoice_id = params[:invoice_id]

    if invoice_item.save
      render json: invoice_item, status: :created
    else
      render json: invoice_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoice_items/1
  def update
    if @invoice_item.update(invoice_item_params)
      render json: @invoice_item
    else
      render json: @invoice_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoice_items/1
  def destroy
    if @invoice_item.destroy
      render json: @invoice_item
    else
      render json: @invoice_item.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice_item
      @invoice_item = InvoiceItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_item_params
      params.require(:invoice_item).permit(:details, :price, :amount, :invoice_id)
    end

    def check_user_owns_resource
      @client = Client.find(@invoice_item.invoice.client_id)

      if(@client.user_id != current_user.id)
        return render json: { message: "You dont not own this resource"}, status: :unauthorized
      end
    end
end
