class ProductSearcher 
  
  # The Semantics data can be updated multiple times in a single day. Without knowing who the end customer is,
  # and what we're trying to optimize for (speed? correctness?), it's hard to pick a truly effective TTL. For now,
  # 1 day is as good as any other.
  CACHE_TTL = 1.day
  
  def initialize
    @semantics_client = SemanticsClient.new
  end
  
  def search_product(search_term, page=1)
    # Make sure we have a valid page
    page = 1 if page.to_i < 1
    
    unless search_result_page = pull_from_cache(search_term, page)
      search_results = @semantics_client.search_for_products(search_term, page)
      search_result_page = SearchResultPage.new(search_term: search_term, page: page, content: search_results['products'],
                                                   last_page: search_results['last_page'])
      
      # Don't cache any unknown error results for now. For now, the likely cause is a failure to communicate with the API.
      unless search_results['error']
        # Rather than trying to update the timestamp on any existing but outdated cache rows,
        # just insert a new row. All the old rows will be reaped anyway, and this will be simpler.
        # If the save fails, don't raise an error - continue to show results if we have them, we will just
        # be missing a cache result for that term. This might happen if the search term is too long to be stored
        # in MySQL. 
        search_result_page.save
      end
    end
    search_result_page
  end
  
  def pull_from_cache(search_term, page=1)
    SearchResultPage.where(search_term: search_term, page: page, updated_at: (Time.now - CACHE_TTL..Time.now)).first
  end
end
