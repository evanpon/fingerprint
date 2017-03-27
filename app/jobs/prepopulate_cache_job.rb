class PrepopulateCacheJob < ApplicationJob
  queue_as :default

  def perform(*args)
    product_searcher = ProductSearcher.new
    
    # Find them in batches. The default limit of 1000 is probably fine.
    CommonTerm.find_each do |common_term|
      common_term.pages.times do |page|
        # Note that if there is still a valid page in the cache, this 
        # will not override the page.
        product_searcher.search_product(common_term.search_term, page + 1)
      end
    end
  end
end
