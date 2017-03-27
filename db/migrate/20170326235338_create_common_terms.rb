class CreateCommonTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :common_terms do |t|
      t.string :search_term
      t.integer :pages

      t.timestamps
    end
  end
end
