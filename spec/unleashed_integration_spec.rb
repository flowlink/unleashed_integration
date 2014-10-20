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
      VCR.use_cassette("get_products") do
        request[:parameters]["modified_since"] = '2014-10-13'
        post '/get_products', request.to_json, {}

        expect(json_response['parameters']['modified_since']).to eq '2014-10-14T10:41:58+00:00'

        expect(json_response['summary']).to eq 'Received 4 Products'
        expect(json_response['products'].size).to eq 4
      end
    end
  end

  describe "/get_customers" do

    it "returns customers" do
      VCR.use_cassette("get_customers") do
        request[:parameters]["modified_since"] = '2014-10-1'
        post '/get_customers', request.to_json, {}

        expect(json_response['parameters']['modified_since']).to eq '2014-10-14T05:00:16+00:00'
        expect(json_response['summary']).to eq 'Received 11 Customers'
        expect(json_response['customers'].size).to eq 11
      end
    end
  end

  describe "/get_orders" do

    it "returns_orders" do
      VCR.use_cassette("get_orders") do
        request[:parameters]["modified_since"] = '2014-10-1'
        post '/get_orders', request.to_json, {}

        expect(json_response['parameters']['modified_since']).to eq "2014-10-19T23:52:54+00:00"
        expect(json_response['summary']).to eq 'Received 22 Orders'
        expect(json_response['orders'].size).to eq 22
      end
    end
  end

  describe "/get_inventory" do

    it "returns_inventory" do
      VCR.use_cassette("get_inventory") do
        request[:parameters]["modified_since"] = "2014-10-8"
        post '/get_inventory', request.to_json, {}

        expect(json_response['parameters']['modified_since']).to eq "2014-10-14T10:42:02+00:00"
        expect(json_response['summary']).to eq 'Received 5 Inventory'
        expect(json_response['inventories'].size).to eq 5
      end
    end
  end

  describe "/get_shipments" do

    it "returns_shipments" do
      VCR.use_cassette("get_shipments") do
        request[:parameters]["modified_since"] = '2014-09-11'
        post '/get_shipments', request.to_json, {}

        expect(json_response["parameters"]["modified_since"]).to eq "2014-10-12T07:08:12+00:00"
        expect(json_response['summary']).to eq 'Received 1 Shipments'
        expect(json_response['shipments'].size).to eq 1
      end
    end
  end

  describe "/add_product" do

    it "creates a product" do
      VCR.use_cassette("create_product") do
        product = { product: { "id" => '9160', "description" => "something" }}
        post '/add_product', request.merge(product).to_json, {}

        expect(json_response['products'].size).to eq 1
        expect(json_response['products'].first.has_key?('unleashed_id')).to eq true
      end
    end
  end

  describe "/customer" do

    it "creates a customer" do
      VCR.use_cassette("create_customer") do
        customer = { customer: { "id" => '999', "firstname" => "test", "email" => "test@t.com" }}
        post '/add_customer', request.merge(customer).to_json, {}

        expect(json_response['customers'].size).to eq 1
        expect(json_response['customers'].first.has_key?('unleashed_id')).to eq true
      end
    end
  end

  describe "/set_inventory" do
    it "creates a customer" do
      VCR.use_cassette("create_inventory") do
        expect(SecureRandom).to receive(:uuid).twice.and_return('f96626e2-cde4-43dc-8f35-192b9b2c4ff0')
        inventory = { inventory: { "id" => '9160', "location" => "Warehouse", "reason" => "Adjustment", "quantity" => 1 }}
        post '/set_inventory', request.merge(inventory).to_json, {}

        expect(json_response['inventories'].size).to eq 1
        expect(json_response['inventories'].first.has_key?('unleashed_id')).to eq true
      end
    end
  end
end