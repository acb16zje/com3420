class AssetBelongsToCategory < ActiveRecord::Migration[5.1]
  def change
    add_reference :assets, :category, index: true
  end
end
