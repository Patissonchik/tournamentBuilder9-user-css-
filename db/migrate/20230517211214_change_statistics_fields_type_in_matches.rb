class ChangeStatisticsFieldsTypeInMatches < ActiveRecord::Migration[7.0]
  def change
    change_column :matches, :statistics_fields, :text
  end
end
