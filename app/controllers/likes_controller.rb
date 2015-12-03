class LikesController < ApplicationController
  def create_like
    p_id = params[:product_id].to_i
    u_id = params[:user_id].to_i
    unless Like.where(:user_id => u_id, :product_id => p_id).exists?
      Like.create(:product_id => params[:product_id].to_i, :user_id => params[:user_id].to_i)
    end
  end

  def create_possession
    p_id = params[:product_id].to_i
    u_id = params[:user_id].to_i
    unless Possession.where(:user_id => u_id, :product_id => p_id).exists?
      Possession.create(:product_id => params[:product_id].to_i, :user_id => params[:user_id].to_i)
    end
  end
end
