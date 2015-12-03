class CriticReviewsController < ApplicationController
  before_action :set_critic_review, only: [:show, :edit, :update, :destroy]

  # GET /critic_reviews
  # GET /critic_reviews.json
  def index
    @critic_reviews = CriticReview.all
  end

  # GET /critic_reviews/1
  # GET /critic_reviews/1.json
  def show
    @html, @title, @author, @published = Product.generate_readable_html(CriticReview.find(params[:id]).url)
  end

  # GET /critic_reviews/new
  def new
    @critic_review = CriticReview.new
  end

  # GET /critic_reviews/1/edit
  def edit
  end

  # POST /critic_reviews
  # POST /critic_reviews.json
  def create
    @critic_review = CriticReview.new(critic_review_params)

    respond_to do |format|
      if @critic_review.save
        format.html { redirect_to @critic_review, notice: 'Critic review was successfully created.' }
        format.json { render :show, status: :created, location: @critic_review }
      else
        format.html { render :new }
        format.json { render json: @critic_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /critic_reviews/1
  # PATCH/PUT /critic_reviews/1.json
  def update
    respond_to do |format|
      if @critic_review.update(critic_review_params)
        format.html { redirect_to @critic_review, notice: 'Critic review was successfully updated.' }
        format.json { render :show, status: :ok, location: @critic_review }
      else
        format.html { render :edit }
        format.json { render json: @critic_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /critic_reviews/1
  # DELETE /critic_reviews/1.json
  def destroy
    @critic_review.destroy
    respond_to do |format|
      format.html { redirect_to critic_reviews_url, notice: 'Critic review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_critic_review
      @critic_review = CriticReview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def critic_review_params
      params[:critic_review]
    end
end
