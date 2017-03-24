class SemanticsClient 
  
  def initialize
    @client = Semantics3::Products.new(ENV['SEMANTICS_KEY'], ENV['SEMANTICS_SECRET'])
  end
  
  def get_products(search_term)
    @client.products_field('search', search_term)
    @client.products_field('activeoffersonly', 1)
    @client.products_field('activesitesonly', 1)
    @client.get_products()['results'] || []
  end 
end
