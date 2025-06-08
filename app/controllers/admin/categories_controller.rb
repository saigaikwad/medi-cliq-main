class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]
  before_action :authenticate_admin_user!
  def index
    @categories = Category.order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category created successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
