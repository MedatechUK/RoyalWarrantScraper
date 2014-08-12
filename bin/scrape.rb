#!/usr/bin/env ruby 

require 'thor'
require 'csv'
require_relative '../lib/royal_warrant_scraper.rb'

#we will use this to provide a common interface to pick the trade option
class String 
  def is_integer? 
    true if Integer(self) rescue false 
  end 
end 


class RoyalWarrantCLI < Thor 

  # trade command - scrapes by trade (number or name)
  desc "trade NAME_OR_NUMBER", "Scrape company names with trade name or number per trade_list command"
  option :outfile, :type => :string

  def trade(trade)
    rws = RoyalWarrantScraper.new 
    out = options[:outfile] || "../output/test.csv" 
  
    if trade.is_integer? 
      rws.scrape_to_csv(out, trade: rws.trades[Integer(trade) - 1])      
    elsif rws.trades.include? trade
      rws.scrape_to_csv(out, trade: trade)
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
end


RoyalWarrantCLI.start(ARGV) if ARGV
