module Services
  describe Product do

    describe "#get" do
      it "should return array of products" do

        creds = sample_credentials.merge({ 'modified_since' => '2014-10-13' })
        client = described_class.new(creds)
        products = client.get

        expect(products.size).to eq 1
        expect(products.first[:id]).to eq '123'
      end
    end
  end
end