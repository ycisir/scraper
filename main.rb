require 'httparty'
require 'json'


class WebScraper
	URL = 'https://gwapi.zee5.com/v1/epg?channels=0-9-aajtak,0-9-zeenews,0-9-indiatoday,0-9-255,0-9-9z5543514,0-9-257,0-9-251,0-9-zeebusiness,0-9-zee24taas,0-9-261&start=0&end=0&time_offset=%2B05%3A30&page_size=25&translation=en&country=IN'

	# Fetch the data using HTTParty from given URL
	def fetch_data
		response = HTTParty.get(URL)
		JSON.parse(response.body)
	end


	# Parse the data and store in programs array
	def parse_data(data)
		programs = []

		data['items'].each do |channel|
			channel_name = channel['title']
			next unless channel["items"]

      channel["items"].each do |program|
        programs << {
          channel: channel_name,
          title: program["title"],
          start_time: program["start_time"],
          end_time: program["end_time"]
        }
      end
		end

		programs
	end

	# Display the programs
	def display(programs)
    programs.each do |p|
      puts "Channel Name: #{p[:channel]}"
      puts "Program Start Time: #{p[:start_time]}"
      puts "Program Title: #{p[:title]}"
      puts "Program End Time: #{p[:end_time]}"
      puts "---" * 20
    end
  end

  # Save output into a json file
  def save(programs)
    File.open("output.json", "w") do |f|
      f.write(JSON.pretty_generate(programs))
    end
  end
end


scraper = WebScraper.new
data = scraper.fetch_data
programs = scraper.parse_data(data)
scraper.display(programs)
scraper.save(programs)