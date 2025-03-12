require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV["CAPYBARA_SERVER_PORT"]
    served_by host: "rails-app", port: ENV["CAPYBARA_SERVER_PORT"]

    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ], options: {
      browser: :remote,
      url: "http://#{ENV["SELENIUM_HOST"]}:4444"
    }
  else
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  end

  protected

  def sign_in(user)
    visit new_session_path
    fill_in :email_address, with: user.email_address
    fill_in :password, with: user.password
    click_button "Sign in"
    assert_selector "h1", text: "Tasks"
  end
end
