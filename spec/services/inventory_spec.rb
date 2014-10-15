module Services
  describe Inventory do

    describe "#get" do
      it "should return array of orders" do
        creds = sample_credentials.merge({ 'modified_since' => '2014-10-8' })
        client = described_class.new(creds)
        inventory = client.get

        expect(inventory.size).to eq 2
      end
    end

    describe "#create" do
      it "should create product" do
        client = described_class.new(sample_credentials)
        inventory = client.create({ "id" => '9160', "location" => "Warehouse", "reason" => "Adjustment", "quantity" => 1 })

        expect(inventory[:id]).to eq "9160"
      end
    end
  end
end