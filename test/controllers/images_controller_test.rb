require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test "should get upload" do
    get images_upload_url
    assert_response :success
  end

end
