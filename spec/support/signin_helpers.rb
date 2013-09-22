def full_signin
  fill_in "Name",         with: "Example User"
  fill_in "Email",        with: "user@example.com"
  fill_in "Password",     with: "foobar"
  fill_in "Confirmation", with: "foobar"
end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"
end

def invalid_signin(user)
  fill_in "Email",    with: user.email.upcase
  fill_in "Password", with: "wrong"
  click_button "Sign In"
end