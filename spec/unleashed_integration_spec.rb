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
      expect(json_response['parameters']['modified_since']).to eq '2014-10-13T05:19:57+00:00'

      expect(json_response['summary']).to eq 'Received 1 Products'
      expect(json_response['products'].size).to eq 1
    end
  end

  describe "/get_customers" do

    it "returns customers" do
      post '/get_customers', request.to_json, {}

      expect(json_response['parameters']['modified_since']).to eq '2014-10-14T00:45:48+00:00'
      expect(json_response['summary']).to eq 'Received 1 Customers'
      expect(json_response['customers'].size).to eq 1
    end
  end

  describe "/get_orders" do

    it "returns_orders" do
      post '/get_orders', request.to_json, {}

      expect(json_response['parameters']['modified_since']).to eq '2014-10-14T00:07:29+00:00'
      expect(json_response['summary']).to eq 'Received 2 Orders'
      expect(json_response['orders'].size).to eq 2
    end
  end

  describe "/get_inventory" do

    it "returns_inventory" do
      post '/get_inventory', request.to_json, {}

      expect(json_response['parameters']['modified_since']).to eq '2014-10-14T00:07:29+00:00'
      expect(json_response['summary']).to eq 'Received 2 Inventory'
      expect(json_response['inventories'].size).to eq 2
    end
  end

  describe "/get_shipments" do

    it "returns_shipments" do
      post '/get_shipments', request.to_json, {}

      expect(json_response["parameters"]["modified_since"]).to eq "2014-10-12T07:08:12+00:00"
      expect(json_response['summary']).to eq 'Received 1 Shipments'
      expect(json_response['shipments'].size).to eq 1
    end
  end

  describe "/add_product" do

    it "creates a product" do
      product = { product: { id: '1111', description: 'something' }}
      post '/add_product', request.merge(product).to_json, {}

      expect(json_response['products'].size).to eq 1
      expect(json_response['products'].first.has_key?('unleashed_id')).to eq true
    end
  end

  describe "/customer" do

    it "creates a customer" do
      customer = { customer: { id: '789', firstname: 'John' }}
      post '/add_customer', request.merge(customer).to_json, {}

      expect(json_response['customers'].size).to eq 1
      expect(json_response['customers'].first.has_key?('unleashed_id')).to eq true
    end
  end

end