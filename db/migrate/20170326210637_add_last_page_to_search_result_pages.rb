class AddLastPageToSearchResultPages < ActiveRecord::Migration[5.0]
  def change
    change_table :search_result_pages do |t|
      t.boolean :last_page, default: false
    end
  end
end
