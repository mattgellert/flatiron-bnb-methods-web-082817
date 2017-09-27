class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.reservations.map{|reservation| User.find(reservation.guest_id)}
  end

  def hosts
    self.trips.map{|trip| trip.listing.host}
  end

  def host_reviews
    self.reservations.map{|reservation| reservation.review}
  end

end
