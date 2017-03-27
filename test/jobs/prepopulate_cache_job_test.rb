require 'test_helper'

class PrepopulateCacheJobTest < ActiveJob::TestCase

  test 'cache rows are prepopulated' do
    VCR.use_cassette("prepopulate_cache_job_test/cache_rows_are_prepopulated", record: :once) do
      # Start out with 0
      assert_equal(0, SearchResultPage.all.count)
      
      # There's an existing CommonTerm fixture with one record.
      # CommonTerm.create(search_term: 'iphone', pages: 2)
      PrepopulateCacheJob.perform_now
      assert_equal(2, SearchResultPage.all.count)      
    end
  end
end
