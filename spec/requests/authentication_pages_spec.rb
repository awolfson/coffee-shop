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
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign Out',    href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }

          it { should have_notice_message("Please sign in") }
          it { should have_title_tag(full_title("Sign In")) }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }

          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "as a wrong user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { valid_signin user }

        describe "in the Users controller" do
          describe "visiting the edit page" do
            before { visit edit_user_path(wrong_user) }

            it { should have_title_tag(full_title("")) }
            it { should_not have_title_tag(full_title("Edit User")) }
          end

          describe "submitting a PUT request to the update action" do
            before { put user_path(wrong_user) }

            specify { response.should redirect_to(root_path) }
          end
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign In"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_title_tag(full_title("Edit User"))
          end
        end
      end
    end
  end
end
