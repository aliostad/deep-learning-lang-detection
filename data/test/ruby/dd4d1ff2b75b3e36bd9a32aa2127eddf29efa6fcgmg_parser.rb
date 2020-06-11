# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


require 'nokogiri'
require 'open-uri'
require 'timeout'


# Game.delete_all

GAME_REQUEST_BASE_URL = 'http://www.greenmangaming.com/search/?genres=action&page=3&o=saving'


result = Nokogiri::HTML(open(GAME_REQUEST_BASE_URL))
product_list= result.css("ul.product-list")
product_list_links = product_list.css("li a").map { |a| 
	a['href'] if a['href'].match("/games/")
	}.compact.uniq

product_list_links.each do |href|

	#grab the sale page for the game
	sale_link = 'http://www.greenmangaming.com' + href
	sale_page = Nokogiri::HTML(open(sale_link))

	#obtain the game title
	game_title = sale_page.css('h1.prod_det')
	game_title = /.*<h1 class="prod_det">(.*)<\/h1>.*/.match(game_title.to_s)
	puts game_title[1]
	puts "\n"


	#obtain description
	description_paragraphs = sale_page.css("section.description p")
	description = ""
	description_paragraphs.each do |paragraph|
		if !(paragraph.to_s.include? "<em>") && !(paragraph.to_s.include? "Features:")


			if(!paragraph.to_s.include? "<strong>")
				paragraph_text = (paragraph.to_s)[3...paragraph.to_s.length - 4]

			else
				paragraph_text = (paragraph.to_s)[11...paragraph.to_s.length - 13]
			end


			description += paragraph_text + "\n"

		end
	end

	#obtain normal price, current price
	current_price = sale_page.css("strong.curPrice")
	current_price = /.*<strong class="curPrice">(.*)<\/strong>.*/.match(current_price.to_s)
	puts current_price[1]

	normal_price = 0;


	if sale_page.to_s.include? "<span class=\"lt\">"
		normal_price = sale_page.css("span.lt")
		normal_price = /.*<span class="lt">(.*)<\/span>.*/.match(normal_price.to_s)
		puts normal_price[1]
	else
		puts "This game ain't on sale!"
	end


	game_info = sale_page.css("div.game_details")
	game_info_string = game_info.to_s


	#extract genres

	genre_chunk_start = game_info_string.index("<td>Genres:</td>")

	genre_chunk = game_info_string[genre_chunk_start...game_info_string.length]

	genre_chunk_end = genre_chunk.index("</tr>")

	genre_chunk = genre_chunk[0...genre_chunk_end]

	genres = genre_chunk.split("</a>")

	genres.each do |genre|
		start_index = genre.index('">')
		if start_index != nil
			genre = genre[start_index+2...genre.length]
			genre = genre.strip
			puts genre
		end
	end

	#publisher

	publisher_chunk_start = game_info_string.index("<td>Publisher:</td>")
	publisher_chunk = game_info_string[publisher_chunk_start...game_info_string.length]
	publisher_chunk_end = publisher_chunk.index("</tr>")
	publisher_chunk = publisher_chunk[0...publisher_chunk_end]
	start_index = publisher_chunk.index('">')
	end_index = publisher_chunk.index("</a>")
	publisher = publisher_chunk[start_index+2...end_index]
	puts publisher

	#developer
	developer_chunk_start = game_info_string.index("<td>Developer:</td>")
	developer_chunk = game_info_string[developer_chunk_start...game_info_string.length]
	developer_chunk_end = developer_chunk.index("</tr>")
	developer_chunk = developer_chunk[0...developer_chunk_end]
	start_index = developer_chunk.index('">')
	end_index = developer_chunk.index("</a>")
	developer = developer_chunk[start_index+2...end_index]
	puts developer
	
	#obtain release date
	released_chunk_start = game_info_string.index("<td>Released:</td>")
	released_chunk = game_info_string[released_chunk_start...game_info_string.length]
	released_chunk_end = released_chunk.index("</tr>")
	released_chunk = released_chunk[0...released_chunk_end]
	released = released_chunk.split('</td>')[1]
	released = released.strip
	released = released[4...released.length]
	puts released



	puts "\n"

end







# <td>Genres:</td>
#               <td>
#                 <a href="/genres/action/">
#                   Action
#                 </a>
#                   ,
#                   <a href="/genres/adventure/" onclick="_gaq.push(['_trackEvent', 'Genres', 'Browse', 'Adventure']);">
#                     Adventure
#                   </a>
#               </td>
#             </tr>
# <tr>





# class CreateGames < ActiveRecord::Migration
#   def change
#     create_table :games do |t|
#       t.string :title
#       t.string :platform
#       t.string :release_date
#       t.string :description
#       t.string :esrb_rating
#       t.string :players
#       t.string :coop
#       t.string :publisher
#       t.string :developer
#       t.string :genres
#       t.string :metacritic_rating
#       t.string :image_url

#       t.timestamps
#     end
#   end
# end