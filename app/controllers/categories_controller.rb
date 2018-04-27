class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
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

  # POST /categories/new
  def new_peripheral
    parent_category = Category.find_by_id(params[:id])
    parent_category.has_peripheral = 1

    category = Category.find_by_id(params[:id]).dup
    category.name = category.name.titleize.strip + ' - Peripherals'

    if (!category.icon.include? 'material-icons') && !category.icon.empty?
      category.icon = category.icon.chomp('"></i>') + ' fa-6x"></i><i class="material-icons">P</i>'
    else
      category.icon = category.icon.chomp('</i>') + 'P</i>'
    end

    category.is_peripheral = 1
    category.has_peripheral = 0

    if category.save && parent_category.save
      redirect_to categories_path, notice: 'Peripheral category successfully created'
    end
  end

  # GET /categories/1/edit
  def edit; end

  # POST /categories
  def create
    @category = Category.new(category_params)

    # Checks whether the category already exists
    if Category.exists?(name: @category.name.titleize)
      redirect_to request.referrer, alert: 'Category already exists.'
    else
      if @category.name =~ /^(\w|\s|&|,|;|'){0,20}$/
        @category.name = @category.name.titleize.strip

        # Font awesome icon
        if (!@category.icon.include? 'material-icons') && !@category.icon.empty?
          @category.icon = @category.icon.chomp('"></i>') + ' fa-6x"></i>'
        end

        @category.is_peripheral = 0
        @category.has_peripheral = 0

        # Create a duplicate category for the peripherals
        if params[:want_peripheral].to_i == 1
          @category.has_peripheral = 1

          category = Category.new(category_params)
          category.name = category.name.titleize.strip + ' - Peripherals'

          if (!category.icon.include? 'material-icons') && !category.icon.empty?
            category.icon = @category.icon.chomp('"></i>') + ' fa-6x"></i><i class="material-icons">P</i>'
          else
            category.icon = @category.icon.chomp('</i>') + 'P</i>'
          end
          category.is_peripheral = 1
          category.has_peripheral = 0
          category.save
        end

        if @category.save
          redirect_to categories_path, notice: 'Category was successfully created.'
        end
      else
        redirect_to new_category_path, alert: 'Category name does not meet requirements.'
      end
    end
  end

  # PATCH/PUT /categories/1
  def update
    begin @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    rescue
      redirect_to request.referrer, alert: 'Category already exist.'
    end
  end

  # DELETE /categories/1
  def destroy
    items = Item.where('category_id = ?', @category.id)

    if items.blank?
      UserHomeCategory.where('category_id = ?', @category.id).destroy_all

      begin @category.destroy
        return redirect_to categories_url, notice: 'Category was successfully deleted.'
      end
    else
      redirect_to categories_path, alert: 'Cannot delete category because it is currently in use for an asset.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit!
  end
end
