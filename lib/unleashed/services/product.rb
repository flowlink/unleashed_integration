module Services
  class Product < Base
    def get
      response = request('products')
      response["Items"].map { |item| serialize_product(item) }
    end

    def serialize_product(item)
      {
        id: item["ProductCode"]
      }
    end
  end
end