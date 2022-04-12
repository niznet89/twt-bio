require "test_helper"

class GithubsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get githubs_create_url
    assert_response :success
  end
end
