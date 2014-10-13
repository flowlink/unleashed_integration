module Services
  class Product < Base
    def get
      create_query_string
      response = request('products')
      response["Items"].map { |item| serialize_product(item) }
    end

    private

    def serialize_product(item)
      {
        id: item["ProductCode"],
        description: item['ProductDescription'],
        bigcommerce_id: item['Guid']
      }
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end