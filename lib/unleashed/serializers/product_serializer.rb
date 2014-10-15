module ProductSerializer
  def serialize_for_post(product)
    guid = product['unleashed_id'] || SecureRandom.uuid

    {
      "ProductCode"        => product["id"].to_s,
      "ProductDescription" => product["description"],
      "Guid"               => guid
    }
  end

  def serialize_for_get(product)
    {
      id:             product["ProductCode"],
      channel:        'unleashed',
      description:    product['ProductDescription'],
      unleashed_id:   product['Guid'],
      price:          product['DefaultSellPrice']
    }
  end
end