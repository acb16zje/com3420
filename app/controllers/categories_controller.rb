class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/1
  def show
    redirect_to categories_path
  end

  # GET /categories/filter
  def filter
    @categories = Category.all
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    # Checks whether the user already exists
    if Category.exists?(name: @category.name) || Category.exists?(tag: @category.tag)
      redirect_to new_category_path, notice: 'Category or tag already exists.'
    else
      if @category.name =~ /^(\w|\s|&|,|;|'){0,20}$/
        if @category.tag =~ /^[a-zA-Z]{2,5}$/
          @category.name = @category.name.titleize
          @category.tag.upcase!

          if @category.save
            redirect_to categories_path, notice: 'Category was successfully created.'
          end
        else
          redirect_to new_category_path, notice: 'Category tag does not meet requirements.'
        end
      else
        redirect_to new_category_path, notice: 'Category name does not meet requirements.'
      end
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit(:name, :tag, :categoryicon)
  end
end
