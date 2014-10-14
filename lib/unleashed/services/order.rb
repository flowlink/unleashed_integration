module Services
  class Order < Base

    def get
      create_query_string

      response = request('SalesOrders')
      get_last_update(response)

      response["Items"].map { |order| serialize_order(order) }
    end

    private

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

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end

    def customer_email(id)
      @query_string = ''

      res = request("Customers/#{id}")
      res['Email']
    rescue => e
    end
  end
end