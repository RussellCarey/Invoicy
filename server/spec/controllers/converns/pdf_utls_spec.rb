require 'rails_helper'
require 'api_helper'

class PDFController < ApplicationController
  include PdfUtils
end

RSpec.describe PDFController do
    context 'PDF Utils' do
        let(:client) { Fabricate(:client) }
        let(:invoice) { Fabricate(:invoice, client_id: client.id) }
        let(:invoice_item) { Fabricate(:invoice_item, invoice_id: invoice.id) }


        it 'Creates PDF from data without an error' do
            pdf = subject.convert_html_to_pdf(client, invoice);
            expect(pdf).to_not be_nil
        end
     end
end