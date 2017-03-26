require 'test_helper'

class CacheCleanupJobTest < ActiveJob::TestCase
  test 'cache rows are actually getting deleted' do
    product_searcher = ProductSearcher.new
    VCR.use_cassette("cache_cleanup_job_test/cache_rows_are_deleted", record: :once) do
      # Start out with 0
      assert_equal(0, SearchResultPage.all.count)
      product_searcher.search_product('iphone')
      assert_equal(1, SearchResultPage.all.count)
      
      # Updated the timestamp so it will be cleaned out of the cache
      search_result_page = SearchResultPage.first
      search_result_page.update_attribute(:updated_at, Time.now - ProductSearcher::CACHE_TTL - 5.minutes)
      
      CacheCleanupJob.perform_now
      assert_equal(0, SearchResultPage.all.count)
    end
  end
    
end
