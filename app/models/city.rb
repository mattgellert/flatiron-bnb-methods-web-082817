class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(earliest_date, latest_date)
    listings, not_possible_listings = [], []
    date1 = eval("Date.new(#{earliest_date.split("-").join(",")})")
    date2 = eval("Date.new(#{latest_date.split("-").join(",")})")
    dates = (date1..date2).map{ |date| date }
    self.listings.each {|listing|
      listings << listing if listing.reservations.empty?
      listing.reservations.each {|reservation|
        if !dates.include?(reservation.checkin) && !dates.include?(reservation.checkout)
          listings << listing
        else
          not_possible_listings << listing
        end
      }
    }
    listings.delete_if {|listing| not_possible_listings.include?(listing)}
  end

  def self.highest_ratio_res_to_listings
    num_lis = 0
    num_res = 0
    ratio = 0
    highest_ratio_city = nil
    self.all.each do |city|
      city.listings.each do |listing|
        num_res += listing.reservations.length
      end
      num_lis = city.listings.length
      if (num_res/num_lis) > ratio
        highest_ratio_city = city
        ratio = num_res/num_lis
      end
      num_res, num_list = 0, 0
    end
    highest_ratio_city
  end

  def self.most_res
    num_res = 0
    most_res = 0
    most_res_city = nil
    self.all.each do |city|
      city.listings.each do |listing|
        num_res += listing.reservations.length
      end
      if num_res > most_res
        most_res = num_res
        most_res_city = city
      end
      num_res = 0
    end
    most_res_city
  end
end
