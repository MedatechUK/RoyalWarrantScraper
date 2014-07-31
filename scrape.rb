require_relative 'lib/royal_warrant_scraper.rb'

#we will use this to provide a common interface to pick the trade option
class String 
  def is_number? 
    true if Float(self) rescue false 
  end 
end 


rws = RoyalWarrantScraper.new 

rws.scrape()
puts rws.response
puts rws.response.class