require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'csv'

STATES = %w{AK AL AR AS AZ CA CO CT DC DE FL GA GU HI IA ID IL IN KS KY LA MA MD ME MH MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA PR PW RI SC SD TN TX UT VA VI VT WA WI WV WY}

@company = Array.new
@state = Array.new
@email = Array.new


STATES.each do |state|

	url = "http://findapainter.com/custom-search/?option=com_customsearch&task=advancedResults&strState=#{state}"

	page = Nokogiri::HTML(open(url))

	page.css("div.results div.grid_15").each_with_index do |company, idx|
		unless idx == 0
			title = company.css("div.companyDescriptor").xpath('text()').text
			@company << title
			puts title.inspect

			@state << state
			puts state

			info = company.css("td").text.split(' ')
			@emailtag = nil
			info.each_with_index do |value, idx|

				if value == "Email:"
					@emailtag = info[idx + 1]
					@email << @emailtag
					puts @emailtag.inspect
				end
			end
			if @emailtag == nil
				@email << @emailtag
			end
		end
	end
end

CSV.open("find_a_painter_list.csv", "wb") do |row|
	row << ["State","Company Name", "Email"]
	(0..(@company.length - 1)).each do |index|
		row << [@state[index], @company[index], @email[index]]
	end
end
