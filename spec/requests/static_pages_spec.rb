require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the title 'Home'" do
      visit '/static_pages/home'
      page.should have_selector('title',
                        :text => "CoffeeShop | Home")
    end

    it "should have the content 'CoffeeShop'" do
      visit '/static_pages/home'
      page.should have_selector('h1', 
      									:text => 'CoffeeShop')
    end

    it "should have the content 'Start your coffee shop'" do
      visit '/static_pages/home'
      page.should have_selector('h2', 
                        :text => 'Start your coffee shop')
    end

    it "should have the content 'or join one of these fine establishments'" do
      visit '/static_pages/home'
      page.should have_selector('h3', 
                        :text => 'or join one of these fine establishments')
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