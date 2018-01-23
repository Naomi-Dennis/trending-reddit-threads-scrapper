########################################################################################################
#PURPOSE: The main UI for the program
########################################################################################################
require "active_support"
require "readline"
class Display
  def welcome
    self.show_trending
  end

  def show_trending
    ########################################################################################################
    #PURPOSE: scrape www.reddit.com/r/trendingsubreddits page to find the subreddits that are trending for that day
    # Display the main menu
    ########################################################################################################
    system "clear"
    #convert the current date to a more read-friendly format
    date = Time.now.strftime("%A, %B %d#{ActiveSupport::Inflector.ordinal(Time.now.day)} %C%y")

    scrap = Scraper.new
    trending_list = scrap.simple_data[:subreddits]
    n = 1;
    puts "Trending Subreddits for #{date}"
    puts "-------------------------------"
    trending_list.each do | subreddit |
      puts "#{n}..............................#{subreddit}"
      n += 1
    end
    input = Readline.readline("Enter the subreddit number you'd like to explore or type 'exit' to quit:\n")
    input = input.strip
    puts "-------------------------------"
    if input.to_i < 1 || input.to_i > n
      if input.downcase == "exit"
        puts "Good-bye!"
      else
          self.show_trending
      end
    else
        self.view_subreddit(trending_list[input.to_i - 1])
    end
  end

  def view_subreddit(subreddit)
    ########################################################################################################
    #PURPOSE: Use the name of the thread found on /r/trendingsubreddits to find the appropriate subreddit
    #site to scrape.
    #Displays the subreddit's current users, subscribers, and front page topics.
    #The user can return to the main menu by pressing enter
    #If their ruby console allows, they can access the subreddit by clicking the link shown or by copying
    #it and pasting it in a browser.
    ########################################################################################################
    Scraper.scrape_subreddit(subreddit)
    thread = Reddit_Thread.find_by_name(subreddit)
    front_page_threads = thread.getTopicsByKarma
    current_topic = 0
    max_topics = front_page_threads.size
    per_page = 4
    puts "***************************"
    puts "LOADING SUBREDDIT DETAILS"
    puts "***************************"
    puts "#{subreddit}"
    puts "-------------------------------\n"
    puts "Users Online: #{thread.current_users}/#{thread.subscribers}"
    puts "Frontpage Threads\n"
    while current_topic < max_topics
      system "clear"
      puts "Viewing Frontpage Threads #{current_topic + 1} - #{current_topic + per_page} of #{subreddit}. Subscribers Online -- #{thread.current_users}/#{thread.subscribers}"
      puts "----------------------------"
      page_threads = front_page_threads.slice(current_topic, per_page)
      page_threads.each do | topic |
        puts "Thread: #{topic[:title]}"
        puts "Link: https://www.reddit.com#{topic[:link]}"
        puts "Upvotes: #{topic[:karma]}"
        puts "Comments: #{topic[:comments]}\n\n"
        current_topic += 1
      end
      puts "----------------------------"
      puts "Press [ Enter ] to view the next page or type 'exit' to return to the main menu..."
      input = Readline.readline()
      input = input.strip
      if input.downcase == "exit"
        break
      end
    end
     self.show_trending
  end

end
