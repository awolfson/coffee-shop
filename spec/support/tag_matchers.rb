RSpec::Matchers.define :have_h2_tag do |text|
  match do |page|
    page.should have_selector('h2', text: text)
  end
end

RSpec::Matchers.define :have_h3_tag do |text|
  match do |page|
    page.should have_selector('h3', text: text)
  end
end

RSpec::Matchers.define :have_title_tag do |text|
  match do |page|
    page.should have_selector('title', text: text)
  end
end

RSpec::Matchers.define :have_div_tag do |id|
  match do |page|
    page.should have_selector('div', id: id)
  end
end

RSpec::Matchers.define :have_li_tag do |text|
  match do |page|
    page.should have_selector('li', text: text)
  end
end