require 'rails_helper'

feature "An admin can delete a tutorial" do
  scenario "and it should no longer exist" do
    admin = create(:admin)
    create_list(:tutorial, 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/dashboard"

    expect(page).to have_css('.admin-tutorial-card', count: 2)

    within(first('.admin-tutorial-card')) do
      click_link 'Delete'
    end

    expect(page).to have_css('.admin-tutorial-card', count: 1)
  end

  it "and it should also delete associated videos" do
    admin = create(:admin)
    tutorial1 = create(:tutorial)
    tutorial2 = create(:tutorial)
    create_list(:video, 3, tutorial: tutorial1)
    create_list(:video, 3, tutorial: tutorial2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/dashboard"

    expect(Video.where(tutorial_id: tutorial1.id).count).to eql(3)
    expect(Video.where(tutorial_id: tutorial2.id).count).to eql(3)

    within("#tutorial-#{tutorial1.id}") do
      click_link "Delete"
    end

    expect(page).to have_no_css("#tutorial-#{tutorial1.id}")
    expect(page).to have_css("#tutorial-#{tutorial2.id}")

    expect(Video.where(tutorial_id: tutorial1.id).empty?).to eql(true)
    expect(Video.where(tutorial_id: tutorial2.id).empty?).to eql(false)
  end

end
