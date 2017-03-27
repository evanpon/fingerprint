require 'test_helper'

class ProductSearcherTest < ActiveSupport::TestCase

  test 'successfully create SearchResultPages when searching' do
    product_searcher = ProductSearcher.new
    VCR.use_cassette("product_searcher_test/search_for_iphone", record: :once) do
      # Start out with 0
      assert_equal(0, SearchResultPage.all.count)
      product_searcher.search_product('iphone')
      assert_equal(1, SearchResultPage.all.count)
      
      # We should not create another one
      product_searcher.search_product('iphone')
      assert_equal(1, SearchResultPage.all.count)
        
      search_result_page = SearchResultPage.first
      search_result_page.update_attribute(:updated_at, Time.now - ProductSearcher::CACHE_TTL - 5.minutes)
      
      # Now that the cache is old, we should have two rows
      product_searcher.search_product('iphone')
      assert_equal(2, SearchResultPage.all.count)
    end
  end
  
  test 'handle no Internet' do 
    product_searcher = ProductSearcher.new
    
    # Simulate internet being down for all requests.
    WebMock.stub_request(:any, /http.*/).to_raise(SocketError)
    results = product_searcher.search_product('computer', 1)
    assert_equal(0, results.content.count)
    # the error should not be cached
    assert_equal(0, SearchResultPage.all.count) 
    WebMock.reset!    
  end
  
  test 'can handle a really long search term' do 
    product_searcher = ProductSearcher.new
    search_term = 'computer chair ' * 10
    VCR.use_cassette("product_searcher_test/long_search_term", record: :once) do
      results = product_searcher.search_product(search_term, 1)
      assert_equal(10, results.content.count)
    end
  end

end
