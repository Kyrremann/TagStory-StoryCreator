class AddSimpleVersionOfImagesToTag < ActiveRecord::Migration
  def change
    add_column :tags, :image_top, :string
    add_column :tags, :image_middle, :string
    add_column :tags, :image_bottom, :string
  end
end
