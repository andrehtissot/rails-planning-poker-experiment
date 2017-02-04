require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get comparation_table" do
    get :comparation_table
    assert_response :success
  end

end
