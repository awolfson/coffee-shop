require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_h2_tag('Sign In') }
    it { should have_title_tag('Sign In') }
    it { should have_link("Sign In") }
    it { should_not have_link("Profile") }
    it { should_not have_link("Settings") }
    it { should_not have_link("Users") }
    it { should_not have_link("Sign Out") }
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
      it { should have_link('Users',       href: users_path) }
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

        describe "visiting the index page" do
          before { visit users_path }

          it { should have_notice_message("Please sign in") }
          it { should have_title_tag(full_title("Sign In")) }
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

          describe "when signing in again" do
            before do
              delete signout_path
              valid_signin user
            end

            it "should render the default (profile) page" do
              page.should have_title_tag(user.name)
            end
          end
        end
      end

    end

    describe "as a non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { valid_signin non_admin }

      describe "submitting a DELETE request to the destroy action" do
        before { delete user_path(user) }

        specify { response.should redirect_to(root_path) }
      end
    end

  end

  describe "as a signed-in user" do
    let(:user) { FactoryGirl.create(:user) }
    before { valid_signin user }

    describe "invoking the Users#new action should redirect to home page" do
      before { get new_user_path }

      it { should_not have_h2_tag("Sign Up") }
    end

    describe "invoking the Users#create action should redirect to home page" do
      before { post users_path }

      it { should_not have_success_message('Welcome') }
    end
  end
end
