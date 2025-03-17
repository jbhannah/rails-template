require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid" do
    user = build(:user)
    assert user.valid?
  end
  # test "the truth" do
  #   assert true
  # end
end
