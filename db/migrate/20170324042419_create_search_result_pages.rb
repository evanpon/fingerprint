class CreateSearchResultPages < ActiveRecord::Migration[5.0]
  def change
    create_table :search_result_pages do |t|
      t.string :search_term, limit: 128, null: false
      t.integer :page, default: 1, null: false
      t.text :content
      t.timestamps
    end

    add_index(:search_result_pages, [:search_term, :page, :updated_at])
    add_index(:search_result_pages, :updated_at)
  end
end
