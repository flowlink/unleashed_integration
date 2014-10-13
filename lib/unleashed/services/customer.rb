module Services
  class Customer < Base

    def get
      response = request('customers')
      response["Items"].map { |item| serialize_customer(item) }
    end

    def serialize_customer(item)
      {
        id: item["CustomerCode"]
      }
    end
  end
end