require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = route_params
      query_hash = parse_www_encoded_form(req.query_string)
      body_hash = parse_www_encoded_form(req.body)

      @params.merge!(query_hash) unless query_hash.nil?
      @params.merge!(body_hash) unless body_hash.nil?
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return if www_encoded_form.nil?

      decoded = URI::decode_www_form(www_encoded_form)
      decoded.map! { |key, val| [parse_key(key), val] }

      params_hash = {}

      decoded.each do |keys, val|
        current = params_hash
        while keys.length > 1
          key = keys.shift
          current[key] ||= {}
          current = current[key]
        end
        current[keys.shift] = val
      end
      @params = params_hash
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
