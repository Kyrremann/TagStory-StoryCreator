class CreateTablePublications < ActiveRecord::Migration
  def change
    create_table :publications do | t |
      t.belongs_to :story, index:true

      t.string :json, null: false
      t.integer :version, null: false

      t.timestamps null: false
    end
  end
end
