require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get answers_create_url
    assert_response :success
  end

end
