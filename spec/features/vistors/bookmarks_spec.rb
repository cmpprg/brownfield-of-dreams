require 'rails_helper'

RSpec.describe 'as a visitor when i click a bookmark link', type: :feature do
  it 'i see a flash message that i am not logged in and stay on that page' do
    create(:video)
    visit '/tutorials/1?video_id=1'
    click_link 'Bookmark'

    expect(current_path).to eql('/tutorials/1')
    expect(current_url).to include('/tutorials/1?video_id=1')
    expect(page).to have_content('User must login to bookmark videos.')
  end
end
