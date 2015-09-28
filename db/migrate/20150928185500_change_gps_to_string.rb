class ChangeGpsToString < ActiveRecord::Migration
  def change
    change_column :travel_options, :gps_latitude, :string
    change_column :travel_options, :gps_longitude, :string
  end
end
