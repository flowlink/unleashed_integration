module Services
  describe Inventory do

    describe "#get" do
      it "should return array of orders" do
        client = described_class.new(sample_credentials)
        inventory = client.get

        expect(inventory.size).to eq 3
      end
    end
  end
end