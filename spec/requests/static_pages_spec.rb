require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_h2_tag(heading) }
    it { should have_title_tag(full_title(page_title)) }
    it { should have_selector('a', text: full_title('')) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { "Start your coffee shop" }
    let(:page_title) { "" }

    it_should_behave_like "all static pages"
    it { should_not have_title_tag('| Home') }
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

      it "should have the correct number of microposts" do
        page.should have_content("2 microposts")
      end

      describe "for a single micropost" do
        before { click_link "delete" }

        it { should have_content("1 micropost") }
      end

      describe "pagination" do
        before(:all) { 80.times { FactoryGirl.create(:micropost, user: user, content: "post") } }
        after(:all)  { Micropost.delete_all }

        it { should have_selector('div.pagination') }

        it "should list all microposts" do
          Micropost.paginate(page: 1).each do |micropost|
            page.should have_content(micropost.content)
          end
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
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