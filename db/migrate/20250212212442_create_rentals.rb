class CreateRentals < ActiveRecord::Migration[7.1]
  def change
    create_table :rentals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :film, null: false, foreign_key: true
      t.datetime :rental_date
      t.datetime :return_date

      t.timestamps
    end
  end
end
