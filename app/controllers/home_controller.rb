class HomeController < ApplicationController
  def index
  end

  def search
    @search_term = params[:search_term]
    @results = SemanticsClient.get_products(@search_term)
    render(:index)
  end
end
