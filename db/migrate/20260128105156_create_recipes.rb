class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :source_url
      t.text :memo
      t.text :ingredients

      t.timestamps
    end
  end
end
