module Services
  class Order < Base

    def get
      create_query_string

      response = request('SalesOrders')
      response["Items"].map { |order| serialize_order(order) }
    end

    private

    def serialize_order(item)
      {
        id: item["OrderNumber"]
      }
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end