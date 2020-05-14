class GithubV3API
  def initialize(api_key = nil, username = nil)
    @api_key = api_key
    @username = username
  end

  def repo_info
    parse_response(user_response('repos'))
  end

  def follower_info
    parse_response(user_response('followers'))
  end

  def followees_info
    parse_response(user_response('following'))
  end

  def user_info
    parse_response(users_response(@username))
  end

  private

  def connect
    Faraday.new('https://api.github.com') do |req|
      req.params['access_token'] = @api_key
    end
  end

  def user_response(endpoint)
    connect.get("/user/#{endpoint}")
  end

  def users_response(name)
    connect.get("/users/#{name}")
  end

  def parse_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
