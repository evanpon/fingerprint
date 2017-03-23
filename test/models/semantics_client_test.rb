require 'test_helper'

class SemanticsClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'can retrieve data from Semantics' do 
    search_results = SemanticsClient.get_products('iphone')
    assert_equal(search_results.count, 10, "Search results only had #{search_results.count} products")
  end
end
