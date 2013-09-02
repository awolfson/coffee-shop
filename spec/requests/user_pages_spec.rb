require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "Signup page" do
  	before { visit signup_path }

	it { should have_selector("h2",    text: "Sign Up") }
	it { should have_selector("title", text: full_title("Sign Up")) }
  end

  describe "signup" do
    before { visit signup_path}
    let(:submit) { "Create Account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button :submit }.not_to change(User, :count)
      end

      it "should render error messages" do
        page.should have_selector("div", id: "error_explanation")
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create a user" do
        expect { click_button :submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "profile page" do
	 let(:user) { FactoryGirl.create(:user) }
	 before { visit user_path(user) }

	it { should have_selector('h2',      text: user.name) }
  	it { should have_selector('title', text: user.name) }
  end	


end
