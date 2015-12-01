require 'test_helper'

class CriticReviewsControllerTest < ActionController::TestCase
  setup do
    @critic_review = critic_reviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:critic_reviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create critic_review" do
    assert_difference('CriticReview.count') do
      post :create, critic_review: {  }
    end

    assert_redirected_to critic_review_path(assigns(:critic_review))
  end

  test "should show critic_review" do
    get :show, id: @critic_review
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @critic_review
    assert_response :success
  end

  test "should update critic_review" do
    patch :update, id: @critic_review, critic_review: {  }
    assert_redirected_to critic_review_path(assigns(:critic_review))
  end

  test "should destroy critic_review" do
    assert_difference('CriticReview.count', -1) do
      delete :destroy, id: @critic_review
    end

    assert_redirected_to critic_reviews_path
  end
end
