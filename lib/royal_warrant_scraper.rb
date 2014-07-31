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
  
    @response = Nokogiri::HTML(Net::HTTP.post_form(URI.parse(@url),
                                                  {"q"       => q, 
                                                   "grantor" => grantor,
                                                   "trade"   => trade,
                                                   "region"  => region})
                                                  .body)

    #look for the div with results text, grab the proceeding table element
    search_results = @response.xpath("//div[text() = 'Results of your search:']")[0].next_element
    
    royal_warrant_holders = [] 
    
    search_results.xpath("tr").each do |tr|
      next if tr.css("h2").size == 0 
      name = tr.css("h2").text
      description = tr.css("div")[0].xpath("text()").to_s.strip!
      phone = tr.xpath(".//td[text() = 'Phone:']")[0].next_element.text
      fax = tr.xpath(".//td[text() = 'Fax:']")[0].next_element.text
      email = tr.xpath(".//td[text() = 'Email:']")[0].next_element.text
      website = tr.xpath(".//td[text() = 'Website:']")[0].next_element.text


      royal_warrant_holders << RoyalWarrantEntry.new(name, 
                                                     description, 
                                                     phone, 
                                                     fax, 
                                                     email, 
                                                     website)

    end

    royal_warrant_holders
  end

  private 
  def get_trades
    @response = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(@url)).body)
    @response.css("select[name='trade']/option").each { |option| @trades << option["value"] }    
  end 
end 




