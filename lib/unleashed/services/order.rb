module Services
  class Order < Base
    include OrderSerializer

    def get
      create_query_string

      response = request('SalesOrders')
      get_last_update(response)

      response["Items"].map { |order| serialize_order(order) }
    end

    def create(order)
      get_guid(order)

      @query_string = ''
      post_request("SalesOrders/#{@guid}", serialize_for_post(order), "xml")

      { id: order["id"], unleashed_id: @guid }
    end

    private

    def get_guid(order)
      @guid ||=
      if order["unleashed_id"].present?
        order["unleashed_id"]
      elsif guid = find_order(order['id'])
        guid
      else
        SecureRandom.uuid
      end
    end

    def find_order(id)
      @query_string = "?orderNumber=#{id}"
      request('SalesOrders')["Items"].first["Guid"]
    rescue => e
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