class Trending_Subreddit_Scraper < Scraper

  def initialize
    @simple_data = Array.new;
    @file = open('https://www.reddit.com/r/trendingsubreddits/', 'User-Agent' => 'tren_sub_cli_project_agent')
    @parsed_file = Nokogiri::HTML.parse(@file)
    @thread_data = @parsed_file.css('.thing')
    self.parse_trending_subreddits_data();
  end

  def parse_trending_subreddits_data
    today_data = @thread_data[0]
    @simple_data = { }
    title = today_data.css("a.title")[0].text
    date = title.split(": ")[0].split(" ").pop
    subreddits = title.split(": ")[1].split(", ")
    @simple_data[:subreddits] = subreddits
  end

end
