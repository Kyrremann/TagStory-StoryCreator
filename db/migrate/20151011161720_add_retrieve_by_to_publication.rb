class AddRetrieveByToPublication < ActiveRecord::Migration
  def change
    add_column :publications, :retrieved_by_409, :boolean, default: false
  end
end
