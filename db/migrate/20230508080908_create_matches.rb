class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.string :name
      t.integer :players
      t.integer :statistics_fields
      t.belongs_to :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
