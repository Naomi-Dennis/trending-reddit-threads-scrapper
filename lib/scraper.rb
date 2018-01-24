########################################################################################################
#PURPOSE: To scrape teh appropriate reddit webpages for the needed data.
#Is able to scrape the front page of any reddit webpage by just giving the subreddit name.
#The only exception nis the trendingsubreddits call, made in #initialize, as it is the root page for
#this program.
#
# Theh user agent is changed on each call to ensure the site doesn't get overwhelmed with numerous direct calls to its server.
########################################################################################################
require 'pry'
require 'open-uri'
require 'nokogiri'
require "net/http"
require "colorize"
class Scraper
  attr_accessor :file, :parsed_file, :simple_data

  def self.scrape_subreddit(subreddit_name)
    link = "https://www.reddit.com" + subreddit_name
    fresh_data = Nokogiri::HTML.parse( open(link, 'User-Agent' => 'tren_sub_cli_project_agent') )
    quick_data = fresh_data.css(".thing")

    subscribers = fresh_data.css(".subscribers").css(".number").text
    amt_online = fresh_data.css(".users-online").css(".number").text
    description = fresh_data.css(".md").text.to_s

    data = {}
    data[:name] = subreddit_name
    data[:users_online] = amt_online
    data[:subscribers] = subscribers
    index = 0;
    data[:front_page_threads] = quick_data.collect do | code |
      thread = { }
      thread[:title] = code.css("a.title").text
      thread[:link] = code["data-permalink"]
      thread[:karma] = code.css(".midcol.unvoted").css(".score")[0].text.to_i
      thread[:comments] = code.css(".first")[0].text.split(" ")[0].to_i
      index += 1
      thread
    end
    Subreddit.create(data)
  end

end
