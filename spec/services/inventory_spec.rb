module Services
  describe Inventory do

    describe "#get" do
      it "should return array of inventory objects" do
        VCR.use_cassette("get_inventory") do
          creds = sample_credentials.merge({ 'modified_since' => '2014-10-8' })
          client = described_class.new(creds)
          inventory = client.get

          expect(inventory.size).to eq 5
        end
      end
    end

    describe "#create" do
      it "should create inventory" do
        VCR.use_cassette("create_inventory")  do

          client = described_class.new(sample_credentials)
          expect(SecureRandom).to receive(:uuid).twice.and_return('f96626e2-cde4-43dc-8f35-192b9b2c4ff9')
          inventory = client.create({ "id" => '9160', "location" => "Warehouse", "quantity" => 1, "product_id" => "SPREE-T-SHIRT641053" })

          expect(inventory[:id]).to eq "9160"
        end
      end
    end
  end
end