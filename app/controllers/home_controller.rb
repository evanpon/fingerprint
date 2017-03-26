class HomeController < ApplicationController
  def index
  end

  def search
    page = params[:page].to_i
    page = 1 if page <= 0
    
    @search_result_page = ProductSearcher.new.search_product(params[:search_term], page)
    respond_to do |format|
      format.html {
        render(:index)        
      }
      format.js {
      }
    end
  end
end
