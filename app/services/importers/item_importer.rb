require 'csv'
require 'rubyXL'

module Importers
  class ItemImporter
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def import(current_user)
      workbook = RubyXL::Parser.parse(file)
      worksheet = workbook[0]
      worksheet.delete_row(0)
      worksheet.each do |row|
        t_condition = nil
        t_acquisition_date = nil
        t_purchase_price = nil
        t_manufacturer = nil
        t_model = nil
        t_parent_asset_serial = nil
        t_retired_date = nil
        t_po_number = nil
        t_comment = nil

        t_name = row[0].value
        t_serial = row[1].value
        t_category = row[2].value
        t_condition = row[3].value if !row[3].nil?
        t_acquisition_date = row[4].value if !row[4].nil?
        t_purchase_price = row[5].value if !row[5].nil?
        t_location = row[6].value
        t_manufacturer = row[7].value if !row[7].nil?
        t_model = row[8].value if !row[8].nil?
        t_parent_asset_serial = row[9].value if !row[9].nil?
        t_retired_date = row[10].value if !row[10].nil?
        t_po_number = row[11].value if !row[11].nil?
        t_comment = row[12].value if !row[12].nil?

        next if Item.exists?(:serial => t_name)
        next if !Category.exists?(:name => t_category)
        t_category = Category.where('name = ?', t_category).first.id
        t_acquisition_date = Date.parse(t_acquisition_date.to_s)
        if !t_parent_asset_serial.blank?
          next if !Item.exists?(:serial => t_parent_asset_serial.value)
        end
        t_user_id = current_user.id
        item = Item.new(name: t_name, serial: t_serial, category_id: t_category,
                        condition: t_condition, acquisition_date: t_acquisition_date,
                        purchase_price: t_purchase_price, location: t_location,
                        manufacturer: t_manufacturer, model: t_model,
                        parent_asset_serial: t_parent_asset_serial, retired_date: t_retired_date,
                        po_number: t_po_number, comment: t_comment, user_id: t_user_id)
        if item.save
        end
      end
    end
  end
end
