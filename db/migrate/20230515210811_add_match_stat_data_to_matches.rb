class AddMatchStatDataToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :match_stat_data, :text
  end
end
