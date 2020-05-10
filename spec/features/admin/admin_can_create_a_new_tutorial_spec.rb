require "rails_helper"

RSpec.describe 'As an admin on the new tutorials page', type: :feature do
  before(:each) do
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it "I can create a tutorial by entering the info in a form" do
    visit '/admin/tutorials/new'

    fill_in 'tutorial[title]', with: 'title of tutorial'
    fill_in 'tutorial[description]', with: 'description of tutorial'
    fill_in 'tutorial[thumbnail]', with: 'https://i.ytimg.com/vi/qMkRHW9zE1c/hqdefault.jpg'
    click_button 'Save'

    tutorial = Tutorial.last

    expect(current_path).to eql(tutorial_path(tutorial))

    expect(page).to have_content('Successfully created tutorial.')
    expect(tutorial.title).to eql('title of tutorial')
    expect(tutorial.description).to eql('description of tutorial')
    expect(tutorial.thumbnail).to eql('https://i.ytimg.com/vi/qMkRHW9zE1c/hqdefault.jpg')
  end

  it "If I leave out any info a sad flash appears and I stay on form." do
    visit '/admin/tutorials/new'

    fill_in 'tutorial[title]', with: ''
    fill_in 'tutorial[description]', with: 'description of tutorial'
    fill_in 'tutorial[thumbnail]', with: ''
    click_button 'Save'

    expect(page).to have_content('Title can\'t be blank and Thumbnail can\'t be blank')
    expect(current_path).to eql('/admin/tutorials')

    expect(page).to have_content('description of tutorial')
  end
end

# When I visit '/admin/tutorials/new'
# And I fill in 'title' with a meaningful name
# And I fill in 'description' with a some content
# And I fill in 'thumbnail' with a valid YouTube thumbnail
# And I click on 'Save'
# Then I should be on '/tutorials/{NEW_TUTORIAL_ID}'
# And I should see a flash message that says "Successfully created tutorial.
