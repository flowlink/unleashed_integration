module Services
  describe Customer do

    describe "#get" do
      it "should return array of products" do
        VCR.use_cassette('get_customers') do
          creds = sample_credentials.merge({ 'modified_since' => '2014-10-1' })
          client = described_class.new(creds)

          customers = client.get

          expect(customers.size).to eq 11
        end
      end
    end

    describe "#create" do
      it "should create customer" do
        VCR.use_cassette('create_customer') do
          client = described_class.new(sample_credentials)
          customer = client.create({ "id" => '999', "firstname" => "test", "email" => "test@t.com" })

          expect(customer.has_key?(:unleashed_id)).to eq true
        end
      end
    end
  end
end