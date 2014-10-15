module Services
  class Product < Base
    include ProductSerializer

    def get
      create_query_string

      response = request('products')
      get_last_update(response)

      response["Items"].map { |item| serialize_for_get(item) }
    end

    def create(product)
      get_guid(product)

      post_request("Products/#{@guid}", serialize_for_post(product))

      { id: product["id"], unleashed_id: @guid }
    end

    private

    def get_guid(product)
      @guid ||=
      if product["unleashed_id"].present?
        product["unleashed_id"]
      elsif guid = find_product(product['id'])
        guid
      else
        SecureRandom.uuid
      end
    end

    def find_product(id)
      @query_string = "?productCode=#{id}"
      request('products')["Items"].first["Guid"]
    rescue => e
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end