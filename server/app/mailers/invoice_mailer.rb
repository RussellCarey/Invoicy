#https://guides.rubyonrails.org/action_mailer_basics.html

class InvoiceMailer < ApplicationMailer
    # The default method sets default values for all emails sent
    default from: 'admin@invoicy.com'

    def invoice_email
        @client = params[:client]
        @invoice = params[:invoice]

        attachments['attachment' + params[:attachment_type]] = params[:attachment]
    
        mail(to: @client.email, subject: 'Invoicy - Your invoice!')
    end
end
