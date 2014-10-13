module Services
  class Inventory < Base

    def get
      create_query_string

      response = request('StockOnHand')
      response["Items"].map { |order| serialize_inventory(order) }
    end

    private

    def serialize_inventory(inventory)
      {
        id: inventory['ProductCode']
      }
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end