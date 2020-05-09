class GithubV3API
  def initialize(api_key = nil)
    @api_key = api_key
  end

  def repo_info
    parse_response(response('repos'))
  end

  def follower_info
    parse_response(response('followers'))
  end

  def followees_info
    parse_response(response('following'))
  end

  private

  def connect
    Faraday.new('https://api.github.com') do |req|
      req.headers['Authorization'] = @api_key
    end
  end

  def response(endpoint)
    connect.get("/user/#{endpoint}")
  end

  def parse_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
