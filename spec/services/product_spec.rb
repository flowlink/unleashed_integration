module Services
  describe Product do

    describe "#get" do
      it "should return array of products" do
        client = described_class.new(sample_credentials)
        products = client.get

        expect(products.size).to eq 3
        expect(products.first[:id]).to eq 'ANIMAL'
      end
    end
  end
end