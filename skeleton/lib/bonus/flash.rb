module PhaseBonus
  class Flash
    # find the cookie for this app's flash messages
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        @cookie = JSON.parse(cookie.value) if cookie.name == "_rails_lite_app_flash"
      end
      @cookie ||= {}
    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_flash(res)
      res.cookies << WEBrick::Cookie.new(
        '_rails_lite_app_flash', @cookie.to_json
      )
    end
  end
end
