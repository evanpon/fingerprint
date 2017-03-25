class HomeController < ApplicationController
  def index
  end

  def search
    @search_term = params[:search_term]
    @page = params[:page].to_i
    
    @products = ProductSearcher.new.search_product(@search_term, @page)
    respond_to do |format|
      format.html {
        render(:index)        
      }
      format.js {
      }
    end
  end
end
