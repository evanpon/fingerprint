class CommonTerm < ApplicationRecord
  validates :search_term, presence: true
  validates :pages, numericality: {only_integer: true, greater_than: 0}
  
  before_validation :strip_whitespace
  
  def strip_whitespace
    self.search_term = search_term.strip
    puts "search term now: #{search_term}."
  end
end
