require 'rails_helper'

describe 'Visitor' do
  describe 'on the home page' do
    it 'can see a list of tutorials' do
      tutorial1 = create(:tutorial, title: 'Tutorial 1', description: 'Tutorial 1')
      tutorial2 = create(:tutorial, title: 'Tutorial 2', description: 'Tutorial 2')

      video1 = create(:video, tutorial_id: tutorial1.id)
      video2 = create(:video, tutorial_id: tutorial1.id)
      video3 = create(:video, tutorial_id: tutorial2.id)
      video4 = create(:video, tutorial_id: tutorial2.id)

      visit root_path

      expect(page).to have_css('.tutorial', count: 2)

      within(first('.tutorials')) do
        expect(page).to have_css('.tutorial')
        expect(page).to have_css('.tutorial-description')
        expect(page).to have_content(tutorial1.title)
        expect(page).to have_content(tutorial1.description)
      end
    end

    it "can not see tutorials with classroom set to true" do
      tutorial1 = create(:tutorial, title: 'Tutorial 1', description: 'Tutorial 1')
      tutorial2 = create(:tutorial, title: 'Tutorial 2', description: 'Tutorial 2', classroom: true)
      tutorial3 = create(:tutorial, title: 'Tutorial 3', description: 'Tutorial 3')

      create(:video, tutorial_id: tutorial1.id)
      create(:video, tutorial_id: tutorial1.id)
      create(:video, tutorial_id: tutorial2.id)
      create(:video, tutorial_id: tutorial2.id)
      create(:video, tutorial_id: tutorial3.id)
      create(:video, tutorial_id: tutorial3.id)

      visit '/'

      expect(page).to have_content(tutorial1.title)
      expect(page).to have_content(tutorial1.description)
      expect(page).to have_no_content(tutorial2.title)
      expect(page).to have_no_content(tutorial2.description)
      expect(page).to have_content(tutorial3.title)
      expect(page).to have_content(tutorial3.description)
    end

    it "sees a link to 'About' page" do
      visit '/'

      click_link('About')

      expect(current_path).to eql(about_path)
      expect(page).to have_content('Turing Tutorials')
    end
  end
end
