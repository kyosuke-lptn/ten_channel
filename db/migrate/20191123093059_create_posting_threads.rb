class CreatePostingThreads < ActiveRecord::Migration[6.0]
  def change
    create_table :posting_threads do |t|
      t.string :title, null: false
      t.text :description
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :posting_threads, :user_id, name: 'add_index_posting_threads_on_user'
  end
end
