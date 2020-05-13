require 'rails_helper'

RSpec.describe UserVideo, type: :model do
  it { should belong_to :user }
  it { should belong_to :video }

  describe 'model methods' do
    it "get bookmarks returns grouped and ordered videos" do
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

      expected1 = [video2, video5]
      expected2 = [video3]
      expected3 = [video4, video6]

      expect(UserVideo.get_bookmarks(user)['Tutorial 1'][0].video_title).to eql('Video 2')
      expect(UserVideo.get_bookmarks(user)['Tutorial 1'][1].video_title).to eql('Video 5')
      expect(UserVideo.get_bookmarks(user)['Tutorial 2'][0].video_title).to eql('Video 3')
      expect(UserVideo.get_bookmarks(user)['Tutorial 3'][0].video_title).to eql('Video 4')
      expect(UserVideo.get_bookmarks(user)['Tutorial 3'][1].video_title).to eql('Video 6')
    end
  end
end
