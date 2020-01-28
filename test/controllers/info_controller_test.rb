require 'test_helper'

class InfoControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get info_about_url
    assert_response :success
  end

  test "should get affiliate_program" do
    get info_affiliate_program_url
    assert_response :success
  end

  test "should get terms" do
    get info_terms_url
    assert_response :success
  end

  test "should get privacy" do
    get info_privacy_url
    assert_response :success
  end

end
