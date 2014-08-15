#Royal Warrant web scraper

require 'nokogiri'
require 'net/http'
require_relative 'royal_warrant_entry.rb'

class RoyalWarrantScraper
  #class for scraping RoyalWarrantEntries from Royal Warrant site
  attr_reader :url, :params, :trades

  def initialize
    #frame wrapped by the official search page
    @url = "http://rwha.bwdata.co.uk/RWHAPublic/RWHA_Public_Search.php"
    @trades = []
    get_trades
  end

  def scrape(q:       "", 
             grantor: "-All-", 
             trade:   "-All-", 
             region:  "-All-")

    response = Net::HTTP.post_form(
                          URI.parse(@url),
                            {"q"       => q,
                             "grantor" => grantor,
                             "trade"   => trade,
                             "region"  => region})
                              .body.encode(
                                    "UTF-8", 
                                    invalid: :replace, 
                                    undef: :replace, 
                                    replace: "")

    html = Nokogiri::HTML(response)

    #look for the div with results text, grab the proceeding table element
    search_results = 
      html.xpath("//div[text() = 'Results of your search:']")[0].next_element

    royal_warrant_holders = []

    search_results.xpath("tr").each do |tr|
      next if tr.css("h2").size == 0
      name = tr.css("h2").text
      description = tr.css("div")[0].xpath("text()").to_s.strip!.gsub!("\n", 
                                                                  "<break>")
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

  def scrape_to_csv(file_path, 
                    q:       "",
                    grantor: "-All-", 
                    trade:   "-All-", 
                    region:  "-All-"
                    )

    write_to_csv(file_path, scrape(q:       q, 
                                   grantor: grantor, 
                                   trade:   trade, 
                                   region:  region))
  end


  private
  def get_trades
    response = Nokogiri::HTML(Net::HTTP.get_response(URI.parse(@url)).body)
    response.css("select[name='trade']/option").each { 
                                        |option| @trades << option["value"] }
  end

  def write_to_csv(file_path, entries)
    CSV.open(file_path, "w",
             write_headers: true,
             headers: ["name", 
                       "description", 
                       "phone", 
                       "fax", 
                       "email", 
                       "website"]
             ) do |csv|
      entries.each { |entry| csv << entry.to_a }
    end
  end

end

