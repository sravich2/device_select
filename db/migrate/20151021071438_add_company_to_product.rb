class AddCompanyToProduct < ActiveRecord::Migration
  def change
    add_column :products, :company, :string
  end
end
