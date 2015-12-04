class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :scrape_amazon, :scrape_engadget ]

  # GET /products
  # GET /products.json
  def index
    if params[:search]
      @products = Product.search(params[:search])
    else
      @products = Product.all
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show

  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def recommend
    other_users = User.all - [current_user]
    user_similarities = {}
    other_users.each do |u|
      if (current_user.liked_products | current_user.disliked_products | u.liked_products | u.disliked_products).count == 0
        user_similarities[u] = 0
      else
        user_similarities[u] = ((current_user.liked_products & u.liked_products).count +
            (current_user.disliked_products & u.disliked_products).count -
            (current_user.liked_products & u.disliked_products).count -
            (current_user.disliked_products & u.liked_products).count).to_f /
            (current_user.liked_products | current_user.disliked_products | u.liked_products | u.disliked_products).count
      end

    end

    product_like_probs = {}
    (Product.all - current_user.owned_products).each do |p|
      if p.likers.count + p.dislikers.count == 0
        product_like_probs[p] = 0
      else
        product_like_probs[p] = (user_similarities.slice(*p.likers).values.sum - user_similarities.slice(*p.dislikers).values.sum).to_f/(p.likers.count + p.dislikers.count)
      end
    end
    @recommendations = product_like_probs.sort_by { |k,v| -v }[0..2].collect { |a| a[0] }
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scrape_amazon
    @product.get_details_from_amazon
    redirect_to :action => 'index'
  end

  def scrape_engadget
    @product.get_details_from_engadget
    redirect_to :action => 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:company, :name, :screen_size, :memory, :processor, :battery, :camera, :img_url)
    end

end
