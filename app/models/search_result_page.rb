class SearchResultPage < ApplicationRecord

  # Note that overall we are taking a String, parsing it with JSON, and then reserialize it here to
  # go back into the database.
  # Forking or replacing the Semantics gem would allow us to pull the string prior to parsing.
  # Additionally, JSON serialization can be slow compared to Marshal or MsgPack. I'm choosing to use it here
  # because there is no current need to optimize, and it allows for easy inspection of the data in the cache.  
  serialize :content, JSON
  
  validates :page, numericality: {only_integer: true, greater_than: 0}
  validates :search_term, length: {maximum: 128}
  before_validation :strip_whitespace
  
  def strip_whitespace
    self.search_term = search_term.strip
  end
  
end
