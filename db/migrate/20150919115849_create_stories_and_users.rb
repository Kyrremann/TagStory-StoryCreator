class CreateStoriesAndUsers < ActiveRecord::Migration
  def change
    create_table :stories do | t |
      t.string :title, null: false
      t.string :author, null: false
      t.string :description, null: false
      t.string :status, default: 'draft', null: false
      t.string :age_group, null: false
      t.string :language, null: false
      t.string :country, null: false
      t.string :city, null: false
      t.string :place, null: false
      t.string :estimated_time
      t.string :url
      t.string :version, default: 0, null: false

      t.datetime :first_published
      t.datetime :last_published
      t.boolean :published, default: false, null: false
      
      t.timestamps null: false
    end

    create_table :tags do | t |
      t.belongs_to :story, index:true

      t.string :title, null: false
      t.string :description, null: false
      t.string :question
      t.string :travel_button
      t.string :tag_type, null: false
      t.string :game_mode, default: 'none', null: false
      t.boolean :endpoint, default: false, null: false
      t.boolean :skippable, default: true, null: false

      t.timestamps null: false
    end

    create_table :travel_options do | t |
      t.belongs_to :tag, index:true

      t.string :title, null: false
      t.string :answer
      t.string :help_text
      t.integer :next_tag, null: false
      t.string :method, default: 'text', null: false
      t.integer :map_zoom_level, default: 18
      t.integer :gps_radius, default: 15
      t.integer :gps_latitude
      t.integer :gps_longitude

      t.timestamps null: false
    end

    create_table :game_options do | t |
      t.belongs_to :tag, index:true

      t.string :type, null: false

      t.timestamps null: false
    end

    create_table :images do | t |
      t.integer :belongs_to, null: false
      t.string :url, null: false
      t.integer :owner, null: false

      t.timestamps null:false
    end

    create_table :users do | t |
      t.string :username, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :image
      t.string :uid

      t.timestamps null: false
    end

    create_table :authorgroups do | t |
      t.belongs_to :story, index: true
      t.belongs_to :user, index: true

      t.string :permission, default: 'edit', null: false
      t.boolean :owner, default: false, null: false

      t.timestamps null: false
    end
  end
end
