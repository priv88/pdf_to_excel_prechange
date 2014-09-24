class PdfReadersController < ApplicationController

	def initiate
	end

	def download_excel
		require 'open-uri'
		file_path = "#{Rails.root}/PDF2EXCEL.xls"
		send_file file_path, :filename => "PDF2EXCEL.xls", :disposition => 'attachment'	
	end


	def transform
		pdf_file = params[:pdf_file]
		page_start = params[:page_start]
		page_end = params[:page_end]
		page_end = page_start if page_end.nil?
		pages = define_pages(page_start, page_end)
		wb_name = "PDF2EXCEL" + ".xls"
		workbook = WriteExcel.new(wb_name)
		pages.each do |page|
			file = Pdf2excel.new(pdf_file.path,page)
			worksheet = workbook.add_worksheet
			file.get_content
			file.set_col_position
			file.transform_content
			index = 0
			file.mod_content.each do |info|
				worksheet.write_row(index, 0, info)
			index += 1
			end
		end	
		workbook.close
		redirect_to :pdf2excel, notice: "Success at #{Time.now.strftime("%m%d%Y %H%M")}! #{view_context.link_to('Download Excel', download_pdf_excel_path)}"
	end

	private
	
	def pdf_reader_params
		params.require(:pdf_reader).permit(:file, :page, :full_content, :info_content, :mod_content, :y_precision, :col_position, :max)
	end

	def define_pages(page_start, page_end)
		# binding.pry
		pages = []
		for page in page_start..page_end
			pages << page.to_i
		end
		return pages
	end

end