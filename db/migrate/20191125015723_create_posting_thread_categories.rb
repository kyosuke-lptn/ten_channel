class CreatePostingThreadCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :posting_thread_categories do |t|
      t.references :posting_thread, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :posting_thread_categories, [:posting_thread_id, :category_id], unique: true, name: 'add_index_thread_and_category'
  end
end
