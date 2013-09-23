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
        signup()
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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      valid_signin user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_h2_tag("Update Your Profile") }
      it { should have_title_tag("Edit User") }
      it { should have_link('Change Avatar', href: 'http://gravatar.com/emails') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save Changes"
      end

      it { should have_title_tag(new_name) }
      it { should have_success_message() }
      it { should have_link('Sign Out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "with invalid information" do
      before { click_button "Save Changes" }

      it { should have_content('error') }
    end
  end
end
