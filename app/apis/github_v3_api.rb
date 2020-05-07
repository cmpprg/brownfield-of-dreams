class GithubV3API
  def initialize(api_key = nil)
    @api_key = api_key
  end

  def connect
    Faraday.new('https://api.github.com') do |req|
      req.headers['Authorization'] = @api_key
    end
  end

  def repo_response
    connect.get('/user/repos')
  end

  def parse_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def repo_info
    response_body = parse_response(repo_response)
    response_body.map do |repo|
      { name: repo[:name],
        url: repo[:html_url] }
    end
  end
end
