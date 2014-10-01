require 'csv'
require 'writeexcel'

require "rubygems"
require "nokogiri"
require "open-uri"
require "capybara"
# require "capybara-webkit"
require "httparty"
require "pp"
require 'pry-byebug'
require 'timeout'
require "writeexcel"
require "csv"


class Brightscope

attr_accessor :name, :content, :content_401k, :header, :session, :web_name, :search_bar, :industry, :skip, :use_sanitizer
BRIGHTSCOPE_URL = "http://www.brightscope.com"

  def initialize(session)
    @session = session
    @content = []
    @content_401k = []
    @skip = false
    #TODO add in option!
    @use_sanitizer = true
    # Capybara::Session.new(:selenium)
    # @name = name
  end

  def start_cache
    @session.visit BRIGHTSCOPE_URL
  end  #visit the website
  

  def locate_search_bar
    @search_bar = @session.all(:xpath,'//input[@id="company-search"]').empty? ? @session.find_by_id("general-search") : @session.find_by_id("company-search")
  end #identify search bar

  def input_and_select 
    @search_bar.set(@name)
     #sleep to wait for dropdown to populate, not good way to verify
    @search_bar.native.send_keys :arrow_down
    # @search_bar.native.send_keys :arrow_down
    sleep 5

    unless @session.all(:xpath, '//div[contains(@class, "sitewide-searchbar-dropdown")]').empty?
      @session.first(:xpath, '//div[contains(@class, "sitewide-searchbar-dropdown")]').click
    else
      @skip = true #activate skip to get to the next name, if nothing populates 
    end
  end #select the first from the dropdown.


  def set_identifiers #basic_form_page - pick up basic information
    unless @session.first(".cname").nil?
      web_name = @session.first(".cname").text 
      puts web_name
      industry = @session.all('.selected-details tbody tr:nth-child(2) td')[1].text
      puts industry
      address = @session.evaluate_script("document.getElementsByClassName('selected-detail-val')[0].innerHTML")

      # binding.pry
      unless address.include? "None"
        sanitized_address = sanitize_address(address)
        address_1 = sanitized_address[0]
        address_2 = sanitized_address[1]
        city = sanitized_address[2]
        state = sanitized_address[3]
        zip_code = sanitized_address[4]
        @content.push(web_name, industry, address_1, address_2, city, state, zip_code) 
      else
        @content.push(web_name, industry, "Address Not Available", "", "", "", "") 
      end
    end
    # binding.pry
    @content
    # address = @session.all('.selected-details tbody tr:nth-child(1) td').empty? ? "N/A" : @session.all('.selected-details tbody tr:nth-child(1) td')[1].text
    # puts address
  end

  def set_401k_identifiers #form 5500 info
    url = @session.current_url
    year = @session.find(:xpath, '//select[@id="select-form-5500-year"]//option[@selected="selected"]').text
    plan_year = @session.find(:xpath, '//table[@class="table-form-5500-section"]//td[contains(text(), "Plan Year")]/following-sibling::td[1]').text
    active_participants = @session.all(:xpath, '//table[@class="table-form-5500-section"]//td[contains(text(), "Active (Eligible) Participants")]/following-sibling::td[1]').empty? ? "N/A" : @session.find(:xpath, '//table[@class="table-form-5500-section"]//td[contains(text(), "Active (Eligible) Participants")]/following-sibling::td[1]').text 
    total_participants = @session.all(:xpath, '//table[@class="table-form-5500-section"]//td[./text()="Total"]/following-sibling::td[1]').empty? ? "N/A" : @session.find(:xpath, '//table[@class="table-form-5500-section"]//td[./text()="Total"]/following-sibling::td[1]').text

    # unless @session.find(:xpath, '//table[@class="table-form-5500-section"]//td[contains(text(), "Total number of participants as of")]/following-sibling::td[1]').nil?
    # LY_participants = @session.find(:xpath, '//table[@class="table-form-5500-section"]//td[contains(text(), "Total number of participants as of")]/following-sibling::td[1]').text
    participants_LY = @session.all(:xpath, '//table[@class="table-form-5500-section"]//td[contains(text(), "Total number of participants as of")]/following-sibling::td[1]').empty? ? "N/A" : @session.find(:xpath, '//table[@class="table-form-5500-section"]//td[contains(text(), "Total number of participants as of")]/following-sibling::td[1]').text
    # selected_year = @session.find(:xpath, '//select[@id="select-form-5500-year"]//option[@selected="selected"]').text
    @content_401k.push(year, plan_year, active_participants, total_participants, participants_LY, url)
    # web_name = @session.find('#company-name-val').text

    # year = @session.find('#select-form-5500-year').textno
    
    # address = @session.find(:xpath, '//table[@class="table-form-5500-section"]//td[./text()="Address")]/following-sibling::td[1]').text
    # sanitized_address = sanitize_address(address)
    # address_1 = sanitized_address[0]
    # state = sanitized_address[1]
    # zip_code = sanitized_address[2]
    return @content_401k    
  end



  def sanitize_address(address)

    regex_new_line = /[^\n]+/
    address_arr = address.scan(regex_new_line)
    address_arr.each do |line| 
      line.gsub!(/\s{2,}|\&nbsp\;|\<br\>|/,"")
    end
    address_arr.delete_if{|line| line==""}
  
    if address_arr.count > 2
      address_line_1 = address_arr[0]
      address_line_2 = address_arr[1]
    else
      address_line_1 = address_arr[0]
      address_line_2 = ""
    end

    # binding.pry
    regex = /\w{2}\s\d{5}(?:[-\s]\d{4})?$/ #looks for state and zipcode
    city = address_arr[-1].split(regex)[0].delete(",").strip #separates city from state and zipcode

    # regex_city = /St|St\.|Street|Floor|Fl\.|Fl|Flr|Flr\.|Ave\.|Avenue|Pl\.|Pl|Place|Suite\s\d{1,4}|Ste\s\d{1,4}|Drive|Dr\.|Dr|Rd|Rd\.|Road|Way|Parkway|Pwky|Trafficway|Blvd\s|Blvd|Boulevard|/
    # binding.pry
    keys = address_arr[-1].slice(regex).split(" ") #state and zipcode
    keys.unshift(address_line_1, address_line_2, city)
    return keys
        # binding.pry
  end

  def redirect_to_form5500
    form_link = @session.find(".sort li", :text => "Form 5500 Data")
    form_link.click
  end

  def clear_all_content
    @content.clear
    @content_401k.clear 
  end

  def clear_401k_content
    @content_401k.clear
  end

  def count_years #form 5500
    session.all(:xpath, '//select[@id="select-form-5500-year"]//option').count
  end

  def click_through_years
    session.find(:xpath, '//select[@id="select-form-5500-year"]').native.send_keys :arrow_down
    session.find('body').click #need to click on page to ensure redirect works.
  end

end
