class BrightscopeController < ApplicationController

  def initiate

  end

  def find_bs_content
    # binding.pry
    csv_file = params[:csv_file].open #need to open the file in order to get the list of names
    url = CSV.read(csv_file)

    session = Capybara::Session.new(:selenium)
    main_window = Brightscope.new(session)
    main_window.start_cache
    main_window.use_sanitizer = false unless params[:use_sanitizer].nil?


    wb_name = "Brightscope" + ".xls"
    workbook = WriteExcel.new(wb_name)
    worksheet = workbook.add_worksheet
    header_row = ["PrivCo Name","Search Name", "Web Name", "Industry", "Address", "Address_2", "City", "State", "Zip Code", "Year", "Plan Year", "Active Participants", "Total Partipants", "LY Participants", "URL"]
    worksheet.write_row(0,0,header_row)
    index_url = 0
    index = 1
    row = []  
    url.each do |url|
      begin
      # binding.pry

      main_window.clear_all_content
      privco_name = url[index_url]
      file_name = url[index_url + 1]
      # binding.pry
      puts file_name
      # main_window.name = sanitize_name(file_name)
      main_window.name = main_window.use_sanitizer ? sanitize_name(file_name) : file_name
      # binding.pry
      puts main_window.name

      main_window.locate_search_bar

      main_window.input_and_select
      unless main_window.skip
        main_window.set_identifiers #basic form
        if main_window.content.count < 1
          worksheet.write_row(index,0,[privco_name, file_name,"Not found in Brightscope"])
          index += 1
          row.clear  
        else
          puts main_window.content
          main_window.redirect_to_form5500 #Form 5500
          sleep 2
          click_down = main_window.count_years #switch years
          puts click_down
          click_down.times do 
            sleep 1
            main_window.set_401k_identifiers
            row = [privco_name, file_name]
            create_row(main_window.content, main_window.content_401k, row)
            main_window.clear_401k_content
            main_window.click_through_years
            puts row
            worksheet.write_row(index,0,row)
            index += 1
            sleep rand(4..7)
          end
        end
      else
        worksheet.write_row(index,0,[privco_name, file_name,"Not found in Brightscope"])
        index += 1
        row.clear  
        main_window.skip = false
      end
      # binding.pry
      worksheet.write_row(index,0,[" "])
      index += 1
      sleep rand(3..9)
      rescue
        next
      end
    end
        # binding.pry
    workbook.close    
    redirect_to :brightscope, notice: "Success on #{Time.now.strftime("%m-%d-%y at %H:%M")} ! #{view_context.link_to('Download Excel', download_bs_excel_path)}"
  end

  def download_excel
    require 'open-uri'
    file_path = "#{Rails.root}/BrightScope.xls"
    send_file file_path, :filename => "BrightScope.xls", :disposition => 'attachment'
  end

  private

  def sanitize_name(name)
    regex = /GmbH$|S\.p\.A$|S\.p\.A\.$|Ltd$|Inc\.$|Incorporated|Inc$|Limited$|Co\.$|Corp$|Corp\.$|LLC$|L\.L\.C\.$|L\.L\.C$|\,|SA$|S\.A\.$|A\/S$|LP$|L\.P\.|L\.P|/
    mod_name = name.gsub(regex,"")
    mod_name.strip
  end

  def create_row(array_1, array_2, row)
    array_1.each {|item| row << item}
    array_2.each {|item| row << item}
  end



end
