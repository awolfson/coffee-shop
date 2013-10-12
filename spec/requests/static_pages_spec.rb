require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h2', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
    it { should have_selector('a', text: full_title('')) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { "Start your coffee shop" }
    let(:page_title) { "" }

    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text: '| Home') }
    it { should have_selector('h3', text: 'or join one of these fine establishments') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Post of champions")
        FactoryGirl.create(:micropost, user: user, content: "Bad-ass postnugget")
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end

  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { "Help" }
    let(:page_title) { "Help" }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { "About Us" }
    let(:page_title) { "About" }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { "Contact Us" }
    let(:page_title) { "Contact" }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: full_title('')
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign Up')
  end
end