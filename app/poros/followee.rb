class Followee
  attr_reader :name, :url, :github_uid

  def initialize(followee_info)
    @name = followee_info[:login]
    @url = followee_info[:html_url]
    @github_uid = followee_info[:id].to_s
  end
end
