require 'csv'
require 'thor'
require_relative 'royal_warrant_scraper.rb'

#we will use this to provide a common interface to pick the trade option
class String 
  def is_integer? 
    true if Integer(self) rescue false 
  end 
end 


class RoyalWarrantCLI < Thor 
  default_task :interactive

  # trade command - scrapes by trade (number or name)
  desc "trade NAME_OR_NUMBER", "Scrape company names with trade name or number per trade_list command"
  option :outfile, :type => :string

  def trade(trade)
    rws = RoyalWarrantScraper.new     
    trade = rws.trades[Integer(trade) - 1] if trade.is_integer?


    out = options[:outfile] || "output/#{trade}.csv"

    if rws.trades.include? trade
      rws.scrape_to_csv(out, trade: trade)
      puts "Scraped to: output/#{trade}.csv"
    else
      puts "Malformed input, try scrape help"
    end 
  end


  #trade list command - pulls down trades & outputs.

  desc "trade_list", "Scrape available trades to perform a company scrape against." 

  def trade_list
    rws = RoyalWarrantScraper.new 
    rws.trades.each_with_index { |trade, index| puts "#{index + 1}: #{trade}"}
  end 


  #default task - run the scraper interactively

  desc "interactive", "Default method - runs scraper interactively if no args given", hide: true

  def interactive
    say "No arguments received. Default output path will be used (output/{trade}.csv)."
    say "Retrieving trades... Please choose from the following:"

    rws = RoyalWarrantScraper.new 
    trade_list
    say "Enter a trade or its corresponding number to scrape."

    trade(ask("trade: "))

  end 

end