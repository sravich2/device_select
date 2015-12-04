class ModifyCriticReview < ActiveRecord::Migration
  def change
    add_column :critic_reviews, :summary, :text
    add_column :critic_reviews, :title, :string
    add_column :critic_reviews, :author, :string
    add_column :critic_reviews, :published, :datetime
    remove_column :critic_reviews, :rating, :float
  end
end
