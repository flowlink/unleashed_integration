describe UnleashedIntegration do
   let(:request) do
    {
      request_id: '1234567',
      parameters: sample_credentials.merge!({ "modified_since" => '2014-10-12'})
    }
  end

  def json_response
    JSON.parse(last_response.body)
  end

  describe "/get_products" do

    it "returns products" do
      post '/get_products', request.to_json, {}

      expect(json_response['summary']).to eq 'Received 1 Products'
      expect(json_response['products'].size).to eq 1
    end
  end

  describe "/get_customers" do

    it "returns customers" do
      post '/get_customers', request.to_json, {}

      expect(json_response['summary']).to eq 'Received 1 Customers'
      expect(json_response['customers'].size).to eq 1
    end
  end

  describe "/get_orders" do

    it "returns_orders" do
      post '/get_orders', request.to_json, {}

      expect(json_response['summary']).to eq 'Received 1 Orders'
      expect(json_response['orders'].size).to eq 1
    end
  end

  describe "/get_inventory" do

    it "returns_inventory" do
      post '/get_inventory', request.to_json, {}

      expect(json_response['summary']).to eq 'Received 2 Inventory'
      expect(json_response['inventories'].size).to eq 2
    end
  end

  describe "/get_shipments" do

    it "returns_shipments" do
      post '/get_shipments', request.to_json, {}

      expect(json_response['summary']).to eq 'Received 1 Shipments'
      expect(json_response['shipments'].size).to eq 1
    end
  end
end