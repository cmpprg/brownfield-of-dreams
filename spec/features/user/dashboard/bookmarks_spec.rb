require 'rails_helper'

RSpec.describe 'user dashboard has bookmarks section', type: :feature do
  it 'bookmarks are organized by tutorial and ordered by position' do
    tutorial1 = create(:tutorial, title: 'Tutorial 1')
    tutorial2 = create(:tutorial, title: 'Tutorial 2')
    tutorial3 = create(:tutorial, title: 'Tutorial 3')
    video1 = create(:video, title: 'Video 1', tutorial: tutorial1)
    video2 = create(:video, title: 'Video 2', tutorial: tutorial1, position: 1)
    video3 = create(:video, title: 'Video 3', tutorial: tutorial1, position: 2)
    video4 = create(:video, title: 'Video 4', tutorial: tutorial2)
    video5 = create(:video, title: 'Video 5', tutorial: tutorial3)
    video6 = create(:video, title: 'Video 6', tutorial: tutorial3, position: 1)
    user = create(:user)
    user.videos << video3
    user.videos << video6
    user.videos << video5
    user.videos << video4
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    binding.pry
  end
end
