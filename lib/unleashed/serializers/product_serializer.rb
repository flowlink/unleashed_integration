module ProductSerializer
  def serialize_for_post(product)
    {
      "ProductCode"        => product["id"].to_s,
      "ProductDescription" => product["description"],
      "DefaultSellPrice"   => product['price'],
      "Guid"               => @guid
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