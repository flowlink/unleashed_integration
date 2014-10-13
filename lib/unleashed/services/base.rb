module Services
  class Base
    def initialize(config)
      @api_url  = config['api_url']
      @api_key  = config['api_key']
      @app_id   = config['app_id']
      @query_string = ''
    end

    def signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), @api_key, @query_string)).strip()
    end

    def request(endpoint)
      res = HTTParty.get("#{@api_url}/#{endpoint}", headers: { "Accept" => 'application/json', 'Content-Type' => 'application/json',
                         'api-auth-id' => @app_id, 'api-auth-signature' => signature })

      validate(res)
      res
    end

    def validate(res)
      if res.has_key?("Description")
        throw ApiError, res['Description']
      end
    end
  end
end

class ApiError < StandardError; end