Rails.application.routes.draw do
  devise_for :users, 
  defaults: { format: :json },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  # get 'member/data', to: 'members#show'
  
  # restrict some routes from resource..
  # resources :reports, :only => [:create, :edit, :update]


  scope "/clients" do
    get '/all', to: 'clients#all'
  end
  resources :clients

  # Nested route efor invoice items
  scope "/invoices" do
    get '/overview', to: 'overview#all'
    get '/all', to: 'invoices#all'
    get '/all_by_status', to: 'invoices#all_by_status'
    post '/:id/send_invoice', to: 'invoices#send_invoice_email'
    get '/:id/download_invoice_pdf', to: 'invoices#download_invoice_pdf'
  end
  resources :invoices

  scope "/invoices/:invoice_id" do
    resources :invoice_items
  end

  scope "/invoice_items" do
    get '/all', to: 'invoice_items#all'
  end

scope "/stripe" do
    post '/create_checkout_session', to: 'stripe#create_checkout_session'
    post '/create_subscription_session', to: 'stripe#create_subscription_session'
    post '/create_product', to: 'stripe#create_product'
    get '/get_all', to: 'stripe#get_all_products'
    get '/get_all_subscriptions', to: 'stripe#get_all_subscriptions'
    get '/get_product/:product_id', to: 'stripe#get_product'
    delete '/cancel_subsciption', to: 'stripe#cancel_subscription'
    post '/webhook', to: 'stripe#webhook'
  end

    # Add so we can update user
  resources :users, only: [:show, :update]
end
