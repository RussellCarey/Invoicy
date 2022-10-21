class InvoicesController < ApplicationController
  include CheckAdmin
  include PdfUtils

  before_action :authenticate_user!
  before_action :set_invoice, only: %i[ show update destroy send_invoice_email download_invoice_pdf ]
  before_action :check_user_owns_resource, only: %i[ show update destroy send_invoice_email download_invoice_pdf ]

  # GET /invoices (Admin only)
  def index
    @invoices = Invoice.all
    render json: @invoices
  end

  # GET /invoices/1
  def show
    render json: @invoice
  end

  # GET /invoices/all?..
  def all
    invoices = search_invoice_with_params()
    filtered_invoices = invoices.filter { |inv| inv.client.user_id === current_user.id}
    render json: filtered_invoices
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.user_id = current_user.id

    if @invoice.save
      render json: @invoice, status: :created
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_params)
      render json: @invoice, status: :ok
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    if @invoice.destroy
      render json: @invoice, status: :ok
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # SEND EMAIL WITH PDF INVOICE /invoices/1/send_email
  def send_invoice_email
    client = @invoice.client
    pdf = convert_html_to_pdf(client, @invoice);

    ##### UPDATE LAST SEND DATE IN INVOICE
    InvoiceMailer.with(client: @client, invoice: @invoice, invoice_items: @invoice_items, attachment: pdf, attachment_type: ".pdf").invoice_email.deliver_now
    render json: { message: "Email sent!"}, status: :ok
  end 

  # DOWNLOAD FILE invoices/:id/download_invoice_pdf
  def download_invoice_pdf
    client = @invoice.client
    pdf = convert_html_to_pdf(client, @invoice);

    send_data pdf, filename: "invoice.pdf", type: "application/pdf"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.fetch(:invoice, {}).permit(:title, :issue_date, :due_date, :last_send_date, :status, :discount, :tax, :client_id)
    end

    def check_user_owns_resource
      if(@invoice.user_id != current_user.id)
        return render json: { message: "You dont not own this resource"}, status: :unauthorized
      end
    end

    def search_invoice_with_params
      page = params[:page].to_i
      page_size = (params[:limit] || 10).to_i

      #! Simplify..
      invoices = Invoice.all
      invoices = invoices.filter_by_status(params[:status]) if params[:status].present?
      invoices = invoices.filter_due_date(params[:due_date]) if params[:due_date].present?
      invoices = invoices.filter_due_date_gt(params[:due_date_gt]) if params[:due_date_gt].present?
      invoices = invoices.filter_due_date_lt(params[:due_date_lt]) if params[:due_date_lt].present?
      invoices = invoices.filter_issue_date(params[:issue_date]) if params[:issue_date].present?
      invoices = invoices.filter_issue_date_gt(params[:issue_date_gt]) if params[:issue_date_gt].present?
      invoices = invoices.filter_issue_date_lt(params[:issue_date_lt]) if params[:issue_date_lt].present?
      invoices = invoices.filter_total(params[:total]) if params[:total].present?
      invoices = invoices.filter_total_gt(params[:total_gt]) if params[:total_gt].present?
      invoices = invoices.filter_total_lt(params[:total_lt]) if params[:total_lt].present?
      invoices.offset(page * page_size).limit(page_size)

      return invoices
    end
end
