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
        id:           item['CustomerCode'],
        unleashed_id: item['Guid'],
        firstname:    item['CustomerName'].split(" ").first,
        lastname:     item['CustomerName'].split(" ").last,
        email:        item['Email'],
        shipping_address: get_address(item)
      }
    end

    def get_address(item)
      address = item['Addresses'].select { |addr| addr['AddressType'] == 'Postal' }.first
      return {} unless address.present?

      {
        address1: address['StreetAddress'],
        zipcode:  address['PostalCode'],
        city:     address['City'],
        state:    address['Region'],
        country:  address['Country'],
        phone:    item['PhoneNumber']
      }
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end