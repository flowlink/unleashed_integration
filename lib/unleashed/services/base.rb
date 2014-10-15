module Services
  class Base
    attr_reader :last_update

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
      @query_string.gsub('?', '')
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

    def post_request(endpoint, body)
      res = HTTParty.post("#{@api_url}/#{endpoint}#{@query_string}", body: body.to_json,
                         headers: { "Accept" => 'application/json', 'Content-Type' => 'application/json',
                         'api-auth-id' => @api_id, 'api-auth-signature' => signature })

      validate(res)
      res
    end

    def validate(res)
      if [400, 403, 404, 405, 500].include? res.code
        raise ApiError, res
      end
    end

    def get_last_update(response)
      @last_update = nil
      return if response['Items'].empty?
      date = response['Items'].first['LastModifiedOn']

      @last_update = parse_date(date)
    end

    def parse_date(date)
      Time.at(date.scan(/\d/).join.to_i / 1000).to_datetime.utc.to_s
    end
  end
end

class ApiError < StandardError; end