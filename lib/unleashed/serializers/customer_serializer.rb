module CustomerSerializer
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

  def serialize_for_post(customer)
    {
      "CustomerCode" => customer['id'],
      "CustomerName" => "#{customer['firstname']} #{customer['lastname']}",
      "Guid"         => @guid
    }
  end
end