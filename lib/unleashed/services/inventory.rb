module Services
  class Inventory < Base

    def get
      response = request('StockOnHand')
      response["Items"].map { |order| serialize_inventory(order) }
    end

    def serialize_inventory(inventory)
      {
        id: inventory['ProductCode']
      }
    end
  end
end