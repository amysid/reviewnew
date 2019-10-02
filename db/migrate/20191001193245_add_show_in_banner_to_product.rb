class AddShowInBannerToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :show_in_banner, :boolean, null: false, default: true
  end
end
