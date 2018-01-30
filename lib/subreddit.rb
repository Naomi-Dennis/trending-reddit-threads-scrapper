########################################################################################################
#PURPOSE: To organize the Reddit_Thread objects into a list where each object can be
#easily found.
#
########################################################################################################
# require "colorize"
class Subreddit
  attr_accessor :name, :users_online, :subscribers, :front_page_threads

  @@all = Array.new;

  def initialize(params)
    params.map do |key, value|
      self.send(("#{key}="), value)
    end
    @@all << self;
  end


  def getTopicsByKarma
    #returns threads by greatest to least karma value

  sorted =  @front_page_threads.sort do |a, b|
      if a[:karma] < b[:karma]
        1
      elsif a[:karma] > b[:karma]
        -1
      else
       a[:karma] <=> b[:karma]
      end
  end
  sorted
end

  def self.find_by_name(subreddit_name)
    @@all.detect do | thread |
      thread.name == subreddit_name
    end
  end

  def self.all
    @@all
  end



  def self.create(data)
    if Subreddit.find_by_name(data[:subreddit]).nil?
      new_subreddit = Subreddit.new(data)
    end
  end

end
