module Services
  describe Customer do

    describe "#get" do
      it "should return array of products" do
        client = described_class.new(sample_credentials)
        customers = client.get

        expect(customers.size).to eq 3
        expect(customers.first[:id]).to eq 'ACE001'
      end
    end
  end
end