require_relative 'lib/unleashed/unleashed'

class UnleashedIntegration < EndpointBase::Sinatra::Base
  set :logging, true

  post '/get_products' do
    begin
      products = Services::Product.new(@config).get
      products.each { |product| add_object :product, product }

      code    = 200
      message = products.size > 0 ? "Received #{products.size} Products" : ""
    rescue => e
      binding.pry
      code    = 500
      message = 'error!'
    end

    result code, message
  end

  post '/get_customers' do
    begin
      customers = Services::Customer.new(@config).get
      customers.each { |customer| add_object :customer, customer }

      code = 200
      message = customers.size > 0 ? "Received #{customers.size} Customers" : ""
    rescue => e
      code    = 500
      message = 'error!'
    end

    result code, message
  end

  post '/get_orders' do
    begin
      orders = Services::Order.new(@config).get
      orders.each { |order| add_object :order, order }

      code = 200
      message = orders.size > 0 ? "Received #{orders.size} Orders" : ""
    rescue => e
      code    = 500
      message = 'error!'
    end

    result code, message
  end

  post '/get_inventory' do
    begin
      inventory = Services::Inventory.new(@config).get
      inventory.each { |inventory| add_object :inventory, inventory }

      code = 200
      message = inventory.size > 0 ? "Received #{inventory.size} Inventory" : ""
    rescue => e
      code    = 500
      message = 'error!'
    end

    result code, message
  end

  post '/get_shipments' do
    begin
      shipments = Services::Shipment.new(@config).get
      shipments.each { |shipment| add_object :shipment, shipment }

      code = 200
      message = shipments.size > 0 ? "Received #{shipments.size} Shipments" : ""
    rescue => e
      code    = 500
      message = 'error!'
    end

    result code, message
  end
end