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
  end
end