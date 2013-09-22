require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_h2_tag('Sign In') }
    it { should have_title_tag('Sign In') }
  end

  describe "signin" do
  	before { visit signin_path }
	  let(:submit) { "Sign In" }

    describe "with nonexistent user" do
      before { click_button :submit }

      it { should have_title_tag(full_title("Sign In")) }
      it { should have_div_tag("error_explanation") }
      it { should have_error_message("We can't find a record") }

      describe "after visiting another page" do
	      before { click_link "Home" }
	      it { should_not have_error_message() }
	    end
    end

    describe "with wrong password" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        invalid_signin(user)
      end

      it { should have_title_tag(full_title("Sign In")) }
      it { should have_div_tag("error_explanation") }
      it { should have_error_message("Wrong password") }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title_tag(user.name) }
      it { should have_link('Profile', 	   href: user_path(user)) }
      it { should have_link('Sign Out',    href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }
    end
  end
end
