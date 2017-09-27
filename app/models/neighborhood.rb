class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(first_date, last_date)
    listings, not_possible_listings = [], []
    date1 = eval("Date.new(#{first_date.split("-").join(",")})")
    date2 = eval("Date.new(#{last_date.split("-").join(",")})")
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
    num_list = 0
    ratio = 0
    highest_ratio_nabe = nil

    self.all.each do |neighborhood|
      num_res = 0
      num_list = neighborhood.listings.length
      neighborhood.listings.each do |listing|
        num_res += listing.reservations.length
      end
      if num_list !=0 && (num_res/num_list) > ratio
        ratio = num_res/num_list
        highest_ratio_nabe = neighborhood
      end
    end
    highest_ratio_nabe
  end

  def self.most_res
    most_res = 0
    most_res_nabe = nil
    self.all.each do |neighborhood|
      num_res = 0
      neighborhood.listings.each do |listing|
        num_res += listing.reservations.length
      end
      if num_res > most_res
        most_res = num_res
        most_res_nabe = neighborhood
      end
    end
    most_res_nabe
  end


end
