require 'test_helper'

class CommonTermsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @common_term = common_terms(:one)
  end

  test "should get index" do
    get common_terms_url
    assert_response :success
  end

  test "should get new" do
    get new_common_term_url
    assert_response :success
  end

  test "should create common_term" do
    assert_difference('CommonTerm.count') do
      post common_terms_url, params: { common_term: { pages: @common_term.pages, search_term: @common_term.search_term } }
    end

    assert_redirected_to common_term_url(CommonTerm.last)
  end

  test "should show common_term" do
    get common_term_url(@common_term)
    assert_response :success
  end

  test "should get edit" do
    get edit_common_term_url(@common_term)
    assert_response :success
  end

  test "should update common_term" do
    patch common_term_url(@common_term), params: { common_term: { pages: @common_term.pages, search_term: @common_term.search_term } }
    assert_redirected_to common_term_url(@common_term)
  end

  test "should destroy common_term" do
    assert_difference('CommonTerm.count', -1) do
      delete common_term_url(@common_term)
    end

    assert_redirected_to common_terms_url
  end
end
