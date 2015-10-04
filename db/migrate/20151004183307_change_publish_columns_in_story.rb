class ChangePublishColumnsInStory < ActiveRecord::Migration
  def change
    remove_column :stories, :first_published
    remove_column :stories, :last_published

    add_column :stories, :first_published_id, :integer
    add_column :stories, :last_published_id, :integer
  end
end
