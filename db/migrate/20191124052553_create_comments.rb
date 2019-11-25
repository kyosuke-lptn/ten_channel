class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :posting_thread, null: false, foreign_key: true

      t.timestamps
    end
    add_index :comments, [:content, :updated_at, :user_id]
  end
end
