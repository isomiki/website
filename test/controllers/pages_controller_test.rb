require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get summary" do
    get pages_summary_url
    assert_response :success
  end

  test "should get projects" do
    get pages_projects_url
    assert_response :success
  end

  test "should get tools" do
    get pages_tools_url
    assert_response :success
  end

  test "should get contact" do
    get pages_contact_url
    assert_response :success
  end

  test "should get posts" do
    get pages_posts_url
    assert_response :success
  end

  test "should get crypto" do
    get pages_crypto_url
    assert_response :success
  end

  test "should get misc" do
    get pages_misc_url
    assert_response :success
  end
end
