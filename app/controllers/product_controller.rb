class ProductController < ApplicationController

  def index
    # サーバー 一覧表示, DBより最新の4件をトップページに表示
    @products = Product.order(created_at: :desc).limit(4)
  end

  def new
    @product = Product.new
    @product.build_delivery
    # @delivery = Derivery.new
  end

  def create
    @product = Product.create!(create_params)# POINT
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
    @products = Product.order(created_at: :desc).limit(6)
    @other_user_products = Product.where(user_id: @product.user_id).order("id DESC").limit(6)
    @other_bland_products = Product.where(balnd_id: @product.bland_id).order("id DESC").limit(6)
  end

  def edit
  end

  def update
    if @product.user_id == current_user.id
      @product.update(item_params)
      flash[:notice] = "商品情報を編集しました"
      redirect_to item_confirmation_items_path(@item)
    else
      flash[:notice] = "権限がありません"
      redirect_to edit_item_path
    end

  end

  def destroy
    product = Product.where(user_id: current_user.id).first
    product.destroy
    redirect_to root_path
  end

  def users_product
    @product = Product.where(user_id: current_user.id).first
  end

  def product_status
  end


  private

  def set_item
    @product = Product.find(params[:id])
  end

  def create_params
    # images以外の値についてのストロングパラメータの設定
    params.require(:product).permit(:name,:text,:status,:price,:bland_id,delivery_attributes:[:id,:price,:region,:date,:product_id],category_attributes:[:id, :parent]).merge(user_id: current_user.id)
    # return product_params
  end
  def delivery_params
    params.require(:delivery).permit(:price,:region,:date)
  end
  def image_params
    #imageのストロングパラメータの設定.js側でimagesをrequireすれば画像のみを引き出せるように設定する。
    params.require(:product).permit( {:user_ids => []})
  end
end
