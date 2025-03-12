module SignInHelper
  def sign_in(user)
    post session_path(email_address: user.email_address, password: user.password)
  end
end
