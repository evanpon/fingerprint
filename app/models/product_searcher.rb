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
    
    if result = pull_from_cache(search_term, page)
      JSON.parse(result.content)
    else 
      response = @semantics_client.get_products(search_term)
      # Rather than trying to update the timestamp on any existing but outdated cache rows,
      # just insert a new row. All the old rows will be reaped anyway, and this will be simpler.

      # Note that it's a bit silly to take a String, parse it with JSON, and then reserialize it back into the database.
      # Forking or replacing the Semantics gem would allow us to pull the string prior to parsing.
      # Additionally, JSON serialization can be slow compared to Marshal or MsgPack. I'm choosing to use it here
      # because there is no current need to optimize, and it allows for easy inspection of the data in the cache.
      serialized_content = JSON.generate(response)
      File.write(search_term, serialized_content)
      SearchResultPage.create(search_term: search_term, page: page, content: serialized_content)
      response
    end
  end
  
  def pull_from_cache(search_term, page=1)
    SearchResultPage.where(search_term: search_term, page: page, updated_at: (Time.now - CACHE_TTL..Time.now)).first
  end
end
