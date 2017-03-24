class HomeController < ApplicationController
  def index
  end

  def search
    @results = SemanticsClient.get_products(params[:search_term])
    render(:index)
  end
end
