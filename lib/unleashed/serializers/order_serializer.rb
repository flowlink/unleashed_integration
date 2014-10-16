module OrderSerializer
  def serialize_order(order)
    {
      id:           order["OrderNumber"],
      unleashed_id: order["Guid"],
      channel:      'unleashed',
      status:       order['OrderStatus'],
      email:        customer_email(order['Customer']['Guid']),
      placed_on:    parse_date(order['OrderDate']),
      shipping_address: {
        firstname: order["Customer"]["CustomerName"].split(" ").first,
        lastname:  order["Customer"]["CustomerName"].split(" ").last,
        address1:  order["DeliveryStreetAddress"],
        zipcode:   order["DeliveryPostCode"],
        city:      order["DeliveryCity"],
        state:     order["DeliveryRegion"],
        country:   order["DeliveryCountry"]
      },
      totals: {
        order: order['Total'],
        tax:   order['TaxTotal']
      },
      line_items:   order['SalesOrderLines'].map do |item|
        {
          product_id:   item['Product']['ProductCode'],
          unleashed_id: item['Product']['Guid'],
          description:  item['Product']['ProductDescription'],
          quantity:     item['OrderQuantity'],
          price:        item['UnitPrice']
        }
      end
    }
  end

  def serialize_for_post(order)
    customer = find_or_create(order)

    builder = Nokogiri::XML::Builder.new do |xml|
        xml.SalesOrder("xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
                       "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                       "xmlns"     => "http://api.unleashedsoftware.com/version/1") {
          xml.Guid(@guid)
          xml.OrderNumber(order["id"])
          xml.OrderStatus("Placed")
          xml.Tax {
            xml.Guid(SecureRandom.uuid)
            xml.TaxCode("None")
            xml.TaxRate(0.00)
          }
          xml.Customer {
            xml.Guid(customer["Guid"])
            xml.CustomerCode(customer["CustomerCode"])
          }
        }
      end

    builder.to_xml
  end

    # {
    #   "Guid" => @guid,
    #   "OrderNumber" => order["id"],
    #   "OrderStatus" => "Placed",
    #   "Tax"=> {
    #     "Guid" => SecureRandom.uuid,
    #     "TaxCode" => "None",
    #     "TaxRate" => 0.00
    #   },
    #   "Customer" => {
    #     "Guid" => customer["Guid"],
    #     "CustomerCode" => customer["CustomerCode"]
    #   }
    # }

  def find_or_create(order)
    email = order["email"]
    raise(RecordNotFound, 'order must have an email') unless email.present?

    @query_string = "?customerCode=#{email}"
    customer = request('Customers')

    if customer["Items"].empty?
      create_customer(order)
    else
      customer["Items"].first
    end
  end

  def create_customer(order)
    guid = SecureRandom.uuid
    customer =
    {
      "Guid" => guid,
      "CustomerCode" => order["email"],
      "CustomerName" => "#{order["billing_address"]["firstname"]} #{order["billing_address"]["lastname"]}"
    }

    @query_string = ''
    post_request("Customers/#{guid}", customer)
  end
end