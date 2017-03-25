class SemanticsClient 
  
  def initialize
    @client = Semantics3::Products.new(ENV['SEMANTICS_KEY'], ENV['SEMANTICS_SECRET'])
  end
  
  
  def search_for_products(search_term, page)
    response = request_products(search_term, page)

    if response['code'] == 'OK' 
      parse_products_json(response)
    else 
      logger.warning("Unsuccessful response for #{search_term} on page #{page}.")
      []
    end
  end
  
  private
  def request_products(search_term, page)
    @client.products_field('search', search_term)
    @client.products_field('activeoffersonly', 1)
    @client.products_field('activesitesonly', 1)
    @client.get_products()
  end 
  
  def parse_products_json(json_hash)
    json_hash['results'].map do |product|
      product_hash = {}
      product_hash['name'] = product['name']
      description = product['description'] || ''
      # The API appears to cut off the description after 50 chars, so only store those.
      description = description[0..50] if (description&.length || 0) > 50
      product_hash['description'] = description
      if product['images'].count > 0
        # I haven't seen products with multiple images yet. For now, just take the first one.
        product_hash['image'] = product['images'].first
      end
      product_hash['price'] = product['price']
      product_hash['sellers'] = parse_sellers(product['sitedetails'])
      product_hash
    end
  end
  
  def parse_sellers(json_array) 
    json_array.map do |seller| 
      seller_hash = {}
      seller_hash['name'] = seller['name']
      seller_hash['url'] = seller['url']
      offer = seller['latestoffers'].first
      # Ignoring any other potential offers for the purpose of this exercise
      seller_hash['price'] = offer['price']
      seller_hash
    end
  end
end
