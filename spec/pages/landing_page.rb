class LandingPage < SitePrism::Page
  set_url '/'
  element :username_field, "#username"
  element :email_field, "#email"
  element :password_field, "#password"
  element :confirm_password_field, "#confpassword"
  element :create_account_button, ".signupForm>button"
  element :error_message, "#error"
  element :sign_up_message, ".SignUpMessage>h1"


  def create_account(username, email, password, confirm_password)
    username_field.set(username)
    email_field.set(email)
    password_field.set(password)
    confirm_password_field.set(confirm_password)
    create_account_button.click
  end

  def validate_username(username)
    if username.length >2 and username.length < 12
        return true
    end
  end

  def is_number? string
    true if Float(string) rescue false
  end
end
