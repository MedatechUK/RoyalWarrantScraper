#Royal Warrant web scraper 

require 'nokogiri'
require 'net/http'
require_relative 'royal_warrant_entry.rb'

class RoyalWarrantScraper 
  #class for scraping RoyalWarrantEntries from Royal Warrant site
  attr_reader :url, :params, :response

  def initialize
    #frame wrapped by the official search page
    @url = "http://rwha.bwdata.co.uk/RWHAPublic/RWHA_Public_Search.php" 
    @trades = []
    get_trades 
  end

  def scrape(q="", grantor="-All-", trade="-All-", region="-All-")
    trade = @trades[2]
    puts q, grantor, trade, region
    
    

    @response = Nokogiri::HTML(Net::HTTP.post_form(URI.parse(@url),
                                                  {"q"       => q, 
                                                   "grantor" => grantor,
                                                   "trade"   => trade,
                                                   "region"  => region})
                                                  .body)
    @response.css("div")[1]
  end

  private 
  def get_trades
    @response = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(@url)).body)
    @response.css("select[name='trade']/option").each { |option| @trades << option["value"] }    
  end 
end 




