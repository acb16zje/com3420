require 'csv'
require 'rubyXL'

module Importers
  class ItemImporter
    attr_reader :file
    delegate :url_helpers, to: 'Rails.application.routes'

    def import_items_path
      url_helpers.root_path(self)
    end

    def initialize(file)
      @file = file
    end

    def import(current_user)
      # To check whether uploaded file is an excel sheet
      if file[-5..-1] != ".xlsx"
        return [0,[]]
      end
      
      workbook = RubyXL::Parser.parse(file)
      worksheet = workbook[0]
      
      # Gets all the cells of the header into a string
      header = ""
      worksheet[0].cells.each do |head|
        header += head.value.strip + ","
      end
      # Checks whether the header is in the right order and format
      if header[0..-2] != "name,serial,category,condition,acquisition_date,purchase_price,location,manufacturer,model,parent_asset_serial,retired_date,po_number,comment"
        return [1, []]
      end
      worksheet.delete_row(0) #Delete row of headers so it does not interfere with item creation

      incorrect_rows = []
      
      worksheet.each_with_index do |row, index|
        exit = false
        t_condition = nil
        t_acquisition_date = nil
        t_purchase_price = nil
        t_manufacturer = nil
        t_model = nil
        t_parent_asset_serial = nil
        t_retired_date = nil
        t_po_number = nil
        t_comment = nil

        t_name = row[0].value.strip
        # Checking if the name cell is in the correct format
        if t_name.nil? || !(t_name.instance_of? String)
          incorrect_rows.append(["#{index}, 10"])
          exit = true
        end

        t_serial = row[1].value.strip
        # Checking if the serial cell is in the correct format
        if t_serial.nil? || !(t_serial.instance_of? String)
          incorrect_rows.append(["#{index}, 1"])
          exit = true
        # Checking if the serial has already been used in another item
        elsif Item.exists?(:serial => t_serial)
          incorrect_rows.append(["#{index}, 2"])
        end

        t_category = row[2].value.strip
        # Checking if the category cell is empty
        if t_category.nil?
          incorrect_rows.append(["#{index}, 3"])
          exit = true
        # Checking if the category exists within the database
        elsif !Category.exists?(:name => t_category)
          incorrect_rows.append(["#{index}, 4"])
          exit = true
        else
          t_category = Category.where('name = ?', t_category).first.id
        end

        def_conditions = ['Like New', 'Good', 'Adequate', 'Damaged', 'Missing', 'Retired']
        t_condition = row[3].value.strip.titleize if !row[3].nil?
        # Checking if the condition cell is in the correct format
        if t_condition.nil? || !(t_condition.instance_of? String) || !def_conditions.include?(t_condition)
          incorrect_rows.append(["#{index}, 5"])
          exit = true
        end

        t_acquisition_date = row[4].value.strip if !row[4].nil?
        # Checking if the acquisition_date cell is in the correct format
        if !t_acquisition_date.nil? && !(t_acquisition_date.instance_of? DateTime)
          incorrect_rows.append(["#{index}, 6"])
          exit = true
        else
          t_acquisition_date = Date.parse(t_acquisition_date.to_s)
        end

        t_purchase_price = row[5].value.strip if !row[5].nil?
        # Checking if the purchase_price cell is in the correct format
        if !t_purchase_price.nil? && (((t_purchase_price.instance_of? Float) && !(t_purchase_price.instance_of? Integer)) || ((!t_purchase_price.instance_of? Float) && (t_purchase_price.instance_of? Integer)))
          incorrect_rows.append(["#{index}, 7"])
          exit = true
        end

        t_location = row[6].strip.value
        # Checking if the location cell is in the correct format
        if t_location.nil? || !(t_location.instance_of? String)
          incorrect_rows.append(["#{index}, 8"])
          exit = true
        end

        t_manufacturer = row[7].strip.value if !row[7].nil?
        # Checking if the manufacturer cell is in the correct format
        if !t_manufacturer.nil? && !(t_manufacturer.instance_of? String)
          incorrect_rows.append(["#{index}, 9"])
          exit = true
        end

        t_model = row[8].strip.value if !row[8].nil?
        # Checking if the model cell is in the correct format
        if !t_model.nil? && !(t_model.instance_of? String)
          incorrect_rows.append(["#{index}, 10"])
          exit = true
        end

        t_parent_asset_serial = row[9].strip.value if !row[9].nil?
        # Checking if the parent_asset_serial exists in the database
        if !t_parent_asset_serial.nil? && !Item.exists?(:serial => t_parent_asset_serial)
          incorrect_rows.append(["#{index}, 11"])
          exit = true
        end

        t_retired_date = row[10].strip.value if !row[10].nil?
        # Checking if the retired_date cell is in the correct format and if retired_date is filled, condition must be set as Retired
        if !t_retired_date.nil? && !(t_retired_date.instance_of? DateTime) && t_condition != "Retired"
          incorrect_rows.append(["#{index}, 12"])
          exit = true
        elsif !t_retired_date.nil?
          t_retired_date = Date.parse(retired_date.to_s)
        end

        t_po_number = row[11].strip.value if !row[11].nil?
        # Checking if the po_number cell is in the correct format
        if !t_po_number.nil? && !(t_po_number.instance_of? String)
          incorrect_rows.append(["#{index}, 13"])
          exit = true
        end

        t_comment = row[12].strip.value if !row[12].nil?
        # Checking if the comment cell is in the correct format
        if !t_comment.nil? && !(t_comment.instance_of? String)
          incorrect_rows.append(["#{index}, 14"])
          exit = true
        end

        next if exit
        t_user_id = current_user.id

        item = Item.new(name: t_name, serial: t_serial, category_id: t_category,
                        condition: t_condition, acquisition_date: t_acquisition_date,
                        purchase_price: t_purchase_price, location: t_location,
                        manufacturer: t_manufacturer, model: t_model,
                        parent_asset_serial: t_parent_asset_serial, retired_date: t_retired_date,
                        po_number: t_po_number, comment: t_comment, user_id: t_user_id)
        item.save
      end

      return [2, incorrect_rows]
    end
  end
end
