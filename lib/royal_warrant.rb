#Royal Warrant web scraper 

require 'nokogiri'
require 'net/http'


#we will use this to provide a common interface to pick the trade option
class String 
  def is_number? 
    true if Float(self) rescue false 
  end 
end 

class RoyalWarrantScraper 
  attr_reader :url, :params
  attr_accessor :response

  def initialize
    #frame wrapped by the official search page
    @url = "http://rwha.bwdata.co.uk/RWHAPublic/RWHA_Public_Search.php" 
    @params = []
    get_params 
  end

  def get_params
    @response = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(@url)).body)
    @response.css("select[name='trade']/option").each { |option| @params << option["value"] }    
  end 
end 


rws = RoyalWarrantScraper.new 

rws.get_params

puts rws.params




