module Services
  class Customer < Base
    include CustomerSerializer

    def get
      create_query_string

      response = request('customers')
      get_last_update(response)

      response["Items"].map { |item| serialize_customer(item) }
    end

    def create(customer)
      get_guid(customer)

      post_request("Customers/#{@guid}", serialize_for_post(customer))

      { id: customer["id"], unleashed_id: @guid }
    end

    private

    def get_guid(customer)
      @guid ||=
      if customer["unleashed_id"].present?
        customer["unleashed_id"]
      elsif guid = find_customer(customer['email'])
        guid
      else
        SecureRandom.uuid
      end
    end

    def find_customer(id)
      @query_string = "?customerCode=#{id}"
      request('Customers')["Items"].first["Guid"]
    rescue => e
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end