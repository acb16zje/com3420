require 'irb'

class ItemPeripheralsController < ApplicationController
  before_action :set_item_peripheral, only: %i[show edit update destroy]
  load_and_authorize_resource

  def new
    @item = Item.find(params[:item_id])

    @items = Item.where.not(serial: @item.serial)

    Item.all.each do |i|
      if !i.peripheral_items.where(parent_item_id: @item.id).blank? || !i.parent_items.where(peripheral_item_id: @item.id).blank?
        @items -= [i]
      end
    end
  end

  def add_parents
    parents = params[:item][:add_parents]
    peripheral = params[:item_id]

    parents.each do |parent|
      unless parent.blank?
        pair = ItemPeripheral.create(parent_item_id: parent.to_i, peripheral_item_id: peripheral)
        pair.save
      end
    end

    redirect_to root_path, notice: "Parents added"
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
