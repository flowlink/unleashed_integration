 module Services
  describe Order do

    describe "#get" do
      it "should return array of orders" do
        creds = sample_credentials.merge({ 'modified_since' => '2014-10-1' })
        client = described_class.new(creds)
        orders = client.get

        expect(orders.size).to eq 2
      end
    end

    describe "#create" do
      it "should create product" do
        client = described_class.new(sample_credentials)
        order = client.create({ "id" => rand(1000), "email" => "test@test.com", "billing_address" => { "firstname" => "test" } })
        binding.pry

        expect(order[:id]).to eq "9160"
      end
    end
  end
end