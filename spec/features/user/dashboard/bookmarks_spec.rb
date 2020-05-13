require 'rails_helper'

RSpec.describe 'user dashboard has bookmarks section', type: :feature do
  it 'bookmarks are organized by tutorial and ordered by position' do
    user = create(:user)
    user2 = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    tutorial1 = create(:tutorial, title: 'Tutorial 1')
    tutorial2 = create(:tutorial, title: 'Tutorial 2')
    tutorial3 = create(:tutorial, title: 'Tutorial 3')
    video1 = create(:video, title: 'Video 1', tutorial: tutorial1)
    video2 = create(:video, title: 'Video 2', tutorial: tutorial1, position: 1)
    video3 = create(:video, title: 'Video 3', tutorial: tutorial2)
    video4 = create(:video, title: 'Video 4', tutorial: tutorial3)
    video5 = create(:video, title: 'Video 5', tutorial: tutorial1, position: 2)
    video6 = create(:video, title: 'Video 6', tutorial: tutorial3, position: 1)
    user.videos << video2
    user.videos << video3
    user.videos << video5
    user2.videos << video1
    user.videos << video4
    user.videos << video6

    visit '/dashboard'

    within(".bookmarks") do
      expect(page.all(".video-link")[0].native.children.text).to eql('Video 2')
      expect(page.all(".video-link")[1].native.children.text).to eql('Video 5')
      expect(page.all(".video-link")[2].native.children.text).to eql('Video 3')
      expect(page.all(".video-link")[3].native.children.text).to eql('Video 4')
      expect(page.all(".video-link")[4].native.children.text).to eql('Video 6')
      expect(page).not_to have_link('Video 1')
    end

    click_link('Video 3')

    expect(current_path).to eql("/tutorials/#{tutorial2.id}")
  end
end
