class PdfReadersController < ApplicationController

	def welcome

	end

	def transform
		pdf_file = params[:pdf_file]
		
		page_start = params[:page_start]
		page_end = params[:page_end]

		pages = define_pages(page_start, page_end)
		# binding.pry
		pages.each do |page|
			file = Pdf2excel.new(pdf_file.path,page)
			binding.pry
			file.get_content
			binding.pry
			file.set_col_position
			binding.pry
			file.transform_content
			binding.pry
			file.transfer_to_excel
		end	
		redirect_to :welcome, notice: "Success"
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