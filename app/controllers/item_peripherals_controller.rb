require 'irb'

class ItemPeripheralsController < ApplicationController
  before_action :set_item_peripheral, only: %i[show edit update destroy]
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @item = Item.find(params[:item_id])

    @items = Item.where("(serial <> ?)", @item.serial)
    Item.all.each do |i|
      if !i.peripheral_items.where("parent_item_id = ?",@item.id).blank? || !i.parent_items.where("peripheral_item_id = ?",@item.id).blank?
        @items = @items - [i]
      end
    end

  end

  def add_parents
    parents = params[:item][:add_parents]
    peripheral = params[:item_id]
    puts 'HIHIIIIIIIIIIIIIHIHIHIH'
    parents.each do |parent|
      if !(parent.blank?)
        pair = ItemPeripheral.create(parent_item_id: parent.to_i,peripheral_item_id: peripheral)
        puts pair.parent_item_id
        puts pair.peripheral_item_id
        pair.save
      end
    end
    redirect_to root_path, notice: "Parents added"
    puts 'HIHIIIIIIIIIIIIIHIHIHIH'
  end

  private

  def set_item_peripheral
    @item_peripheral = ItemPeripheral.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_peripheral_params
    params.require(:item_peripheral).except(:bunny).permit!
  end
end
