module Services
  describe Order do

    describe "#get" do
      it "should return array of orders" do
        client = described_class.new(sample_credentials)
        orders = client.get

        expect(orders.size).to eq 1
      end
    end
  end
end