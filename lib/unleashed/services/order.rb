module Services
  class Order < Base

    def get
      response = request('SalesOrders')
      response["Items"].map { |order| serialize_order(order) }
    end

    def serialize_order(item)
      {
        id: item["OrderNumber"]
      }
    end
  end
end