require "test_helper"

class GuiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gui_index_url
    assert_response :success
  end
end
