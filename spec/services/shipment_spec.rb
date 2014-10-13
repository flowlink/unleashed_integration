module Services
  describe Shipment do

    describe "#get" do
      it "should return array of orders" do
        client = described_class.new(sample_credentials)
        shipments = client.get

        expect(shipments.size).to eq 1
      end
    end
  end
end