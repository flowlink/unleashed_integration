 module Services
  describe Order do

    describe "#get" do
      it "should return array of orders" do
        VCR.use_cassette("get_orders") do
          creds = sample_credentials.merge({ 'modified_since' => '2014-10-1' })
          client = described_class.new(creds)
          orders = client.get

          expect(orders.size).to eq 22
        end
      end
    end

    describe "#create" do
      it "should create order" do
        VCR.use_cassette("create_order") do
          client = described_class.new(sample_credentials)
          order  = { "id" => 44112233, "email" => "test@test.com",
                     "billing_address" => { "firstname" => "test" },
                     "totals" => {
                     "order"  => 390,
                     "tax"    => 10,
                     "items"  => 380
                     },
                    "line_items" => [
                      {
                        "product_id" => "9160",
                        "name" => "Spree T-Shirt",
                        "quantity" => 2,
                        "price" => 190
                      }
                    ]}

          expect(SecureRandom).to receive(:uuid).thrice.and_return('f96626e2-cde4-43dc-8f37-192b9b2c4ff0')
          order = client.create(order)

          expect(order.has_key?(:unleashed_id)).to eq true
        end
      end
    end
  end
end