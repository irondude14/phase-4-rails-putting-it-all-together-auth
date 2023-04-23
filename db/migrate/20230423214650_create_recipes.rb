class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :instructions
      t.integer :minutes_to_complete
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
