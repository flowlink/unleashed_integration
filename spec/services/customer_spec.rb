module Services
  describe Customer do

    describe "#get" do
      it "should return array of products" do
        creds = sample_credentials.merge({ 'modified_since' => '2014-10-1' })
        client = described_class.new(creds)

        customers = client.get

        expect(customers.size).to eq 1
      end
    end

    describe "#create" do
      it "should create product" do
        client = described_class.new(sample_credentials)
        customer = client.create({ "id" => '999', "firstname" => "test" })

        expect(customer[:id]).to eq "999"
      end
    end
  end
end