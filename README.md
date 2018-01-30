# Trendingsubreddits

With this project, you are able to view the trending subreddits of the day. Links are provided to view the subreddit in a browser.

## Usage
**Run 'bundle install' before doing anything else!!**

run

	ruby bin/trending.rb

To scrape a subreddit:

	Scraper.scrape_subreddit("subreddit_name")

Example:

	Scraper.scrape_subreddit("gaming")
	## Returns a Subreddit Object with basic information about -- www.reddit.com/r/gaming subreddit

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Naomi-Dennis/trending-reddit-threads-scrapper

## License

The project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
