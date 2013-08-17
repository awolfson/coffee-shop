require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "Signup page" do
  	before { visit signup_path }

	it { should have_selector("h2", text: "Sign Up") }
	it { should have_selector("title", text: full_title("Sign Up")) }
  end
end