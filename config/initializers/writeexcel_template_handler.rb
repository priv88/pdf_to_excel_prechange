class ActionView::Template
	module Handlers
		class WriteExcelTemplateHandler
			def call(template)
			%{
				Tempfile.open('writeexcel').tap do |tmp|
				WriteExcel.new(tmp.path).tap do |workbook|
					#{template.source}
				end.close
				end.tap(&:rewind).read
			}
			end
		end
	end
	register_template_handler(:writeexcel, Handlers::WriteExcelTemplateHandler.new)
end