module Services
  class Base
    def initialize(config)
      @api_url  = config['api_url']
      @api_key  = config['api_key']
      @api_id   = config['api_id']
      @config   = config
      @query_string = ''
    end

    def signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @api_key, query_to_sign)).strip()
    end

    def query_to_sign
      @query_string.gsub(/[?&]/, '')
    end

    def modified_since
      DateTime.parse(@config['modified_since']).utc.strftime('%Y-%m-%dT%H:%M:%S')
    end

    def request(endpoint)
      res = HTTParty.get("#{@api_url}/#{endpoint}#{@query_string}",
                         headers: { "Accept" => 'application/json', 'Content-Type' => 'application/json',
                         'api-auth-id' => @api_id, 'api-auth-signature' => signature })

      validate(res)
      res
    end

    def validate(res)
      if res.has_key?("Description")
        raise ApiError, res['Description']
      end
    end
  end
end

class ApiError < StandardError; end