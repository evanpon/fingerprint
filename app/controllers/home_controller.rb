class HomeController < ApplicationController
  def index
  end

  def search
    @search_term = params[:search_term]
    @page = params[:page].to_i
    
    @results = ProductSearcher.new.search_product(@search_term, @page)
    render(:index)
  end
end
