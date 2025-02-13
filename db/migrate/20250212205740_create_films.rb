class CreateFilms < ActiveRecord::Migration[7.1]
  def change
    create_table :films do |t|
      t.string :title
      t.integer :release_year
      t.string :language
      t.string :category
      t.decimal :rental_price

      t.timestamps
    end
  end
end
