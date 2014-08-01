class RoyalWarrantEntry
  #defines an entry on the RoyalWarrant site 

  attr_accessor :name, :description, :phone, :fax, :email, :website

  def initialize(name, description, phone, fax, email, website)
    @name = name
    @description = description
    @phone = phone
    @fax = fax
    @email = email
    @website = website
  end

  def to_s
    "name: #{@name}\ndescription: #{@description}\nphone:
     #{@phone}\nfax: #{fax}\nemail: #{email}\nwebsite: #{website}"
  end

  def to_a
    [@name, @description, @phone, @fax, @email, @website]
  end
end 