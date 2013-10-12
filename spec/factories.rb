FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "sample_person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
    	admin "true"
    end
  end

  factory :micropost do
    content "Sweet new post"
    user
  end
end