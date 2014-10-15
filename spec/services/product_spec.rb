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

    describe "#create" do
      it "should create product" do
        client = described_class.new(sample_credentials)
        product = client.create({ "id" => '9160', "description" => "something" })

        expect(product[:id]).to eq "9160"
      end
    end
  end
end