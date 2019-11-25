class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.string :good_or_bad

      t.timestamps
    end
    add_index :likes, [:good_or_bad]
    add_index :likes, [:user_id, :comment_id], unique: true
  end
end
