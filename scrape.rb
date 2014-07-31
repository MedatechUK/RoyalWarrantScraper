require_relative 'lib/royal_warrant_scraper.rb'
require 'csv'

#we will use this to provide a common interface to pick the trade option
class String 
  def is_number? 
    true if Float(self) rescue false 
  end 
end 

def write_to_csv(file_path, entries)
  CSV.open(file_path, "w", 
           write_headers: true, 
           headers: ["name", "description", "phone", "fax", "email", "website"]
           ) do |csv|
    entries.each { |entry| csv << entry.to_a }
  end
end 

rws = RoyalWarrantScraper.new 



write_to_csv("test.csv", rws.scrape())
