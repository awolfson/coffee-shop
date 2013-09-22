require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "Signup page" do
  	before { visit signup_path }

	it { should have_h2_tag("Sign Up") }
	it { should have_title_tag(full_title("Sign Up")) }
  end

  describe "signup" do
    before { visit signup_path}
    let(:submit) { "Create Account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button :submit }.not_to change(User, :count)
      end

      describe "should display error messages" do
        before { click_button :submit }

        it { should have_title_tag(full_title("Sign Up")) }
        it { should have_div_tag("error_explanation") }
        it { should have_error_message("error") }
      end
    end

    describe "with valid information" do
      before do
        full_signin()
      end

      it "should create a user" do
        expect { click_button :submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button :submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_title_tag(user.name) }
        it { should have_success_message('Welcome') }
        it { should have_link('Sign Out') }
      end

      describe "followed by signout" do
        before do
          click_button :submit
          click_link "Sign Out"
        end

        it { should have_link('Sign In') }
      end
    end
  end

  describe "profile page" do
	 let(:user) { FactoryGirl.create(:user) }
	 before { visit user_path(user) }

	it { should have_h2_tag(user.name) }
  	it { should have_title_tag(user.name) }
  end	


end
