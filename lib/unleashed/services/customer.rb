module Services
  class Customer < Base

    def get
      create_query_string

      response = request('customers')
      get_last_update(response)

      response["Items"].map { |item| serialize_customer(item) }
    end

    private

    def serialize_customer(item)
      {
        id: item["CustomerCode"]
      }
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end