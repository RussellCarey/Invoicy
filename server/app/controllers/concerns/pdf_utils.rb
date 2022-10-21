module PdfUtils 
    extend ActiveSupport::Concern

    def convert_html_to_pdf(client, invoice)
      html = ActionController::Base.new.render_to_string(
        template: 'invoice_mailer/invoice_pdf',
        formats: [:html],
        locals: { :client => client, :invoice => invoice, :invoice_items => invoice.invoice_items },
        layout: false
      )

      pdf = Grover.new(html, format: 'A4').to_pdf
    end
end