class CreateMatchStats < ActiveRecord::Migration[7.0]
  def change
    create_table :match_stats do |t|
      t.references :match, null: false, foreign_key: true
      t.json :data

      t.timestamps
    end
  end
end
