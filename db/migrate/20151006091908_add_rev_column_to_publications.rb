class AddRevColumnToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :rev, :string
  end
end
