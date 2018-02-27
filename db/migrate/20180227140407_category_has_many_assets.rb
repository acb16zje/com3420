class CategoryHasManyAssets < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :assets, :categorys
  end
end
