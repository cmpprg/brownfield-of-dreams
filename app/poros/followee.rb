class Followee
  attr_reader :name, :url

  def initialize(followee_info)
    @name = followee_info[:login]
    @url = followee_info[:html_url]
  end
end
