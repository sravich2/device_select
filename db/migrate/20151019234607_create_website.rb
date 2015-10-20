class CreateWebsite < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :name
      t.string :url
    end
  end
end
