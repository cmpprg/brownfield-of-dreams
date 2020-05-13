require 'rails_helper'

describe 'vister can create an account', :js do
  before(:each) do
    @email = 'jimbob@aol.com'
    @first_name = 'Jim'
    @last_name = 'Bob'
    @password = 'password'
    @password_confirmation = 'password'
  end

  it ' visits the home page' do
    visit '/'

    click_on 'Sign In'

    expect(current_path).to eq(login_path)

    click_on 'Sign up now.'

    expect(current_path).to eq(new_user_path)

    fill_in 'user[email]', with: @email
    fill_in 'user[first_name]', with: @first_name
    fill_in 'user[last_name]', with: @last_name
    fill_in 'user[password]', with: @password
    fill_in 'user[password_confirmation]', with: @password

    click_on'Create Account'

    expect(current_path).to eq(dashboard_path)
    user = User.last

    expect(page).to have_content("Logged in as #{user.first_name}")
    expect(page).to have_content("This account has not yet been activated. Please check your email.")
    expect(page).to have_content(@email)
    expect(page).to have_content(@first_name)
    expect(page).to have_content(@last_name)
    expect(page).to_not have_content('Sign In')
  end

  context "As a newly registered user" do
    context "when I click link in my email 'Visit here to activate your account.'" do
      it "I am take to a page that says 'Thank you! Your account is now activated.'" do
        # allow_any_instance_of(AccountActivationMailer).to receive(:inform).and_return("I sent the thing!")
        # visit new_user_path
        # fill_in 'user[email]', with: @email
        # fill_in 'user[first_name]', with: @first_name
        # fill_in 'user[last_name]', with: @last_name
        # fill_in 'user[password]', with: @password
        # fill_in 'user[password_confirmation]', with: @password
        #
        # click_on'Create Account'

        #unable to test properly, come back if there is time and figure this out.
        # potential need to create class that captures email through ActionMailer, then a class to read?
      end
    end

    it "after account activated display 'status: active' on the dashboard" do
      user = create(:user, activation_status: 'active')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit dashboard_path

      expect(page).to have_content("Status: Active")
    end
  end

end
