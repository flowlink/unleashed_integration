module Services
  describe Shipment do

    describe "#get" do
      it "should return array of orders" do
        creds = sample_credentials.merge({ 'modified_since' => '2014-09-11' })
        client = described_class.new(creds)
        shipments = client.get

        expect(shipments.size).to eq 1
      end
    end
  end
end