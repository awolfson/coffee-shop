require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Welcome to the coffee shop, come on in!'" do
      visit '/static_pages/home'
      page.should have_selector('h1', 
      									:text => 'Welcome to the coffee shop, come on in!')
    end

    it "should have the title 'Home'" do
		  visit '/static_pages/home'
		  page.should have_selector('title',
		                    :text => "CoffeeShop | Home")
		end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
		  visit '/static_pages/help'
		  page.should have_selector('title',
		                    :text => "CoffeeShop | Help")
		end
  end

  describe "About page" do

    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About Us')
    end

    it "should have the title 'About Us'" do
		  visit '/static_pages/about'
		  page.should have_selector('title',
		                    :text => "CoffeeShop | About")
		end
  end

  describe "Contact page" do

    it "should have the content 'Contact Us'" do
      visit '/static_pages/contact'
      page.should have_selector('h1', :text => 'Contact Us')
    end

    it "should have the title 'Contact'" do
      visit '/static_pages/contact'
      page.should have_selector('title',
                        :text => "CoffeeShop | Contact")
    end
  end
end