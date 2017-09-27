class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :no_res_your_listing
  validate :list_avail_at_checkin
  validate :list_avail_at_checkout
  validate :checkin_b4_checkout
  validate :checkin_is_not_checkout

  def duration
    date1 = self.checkin
    date2 = self.checkout
    num_dates = (date1..date2).map{ |date| date }.length - 1
  end

  def total_price
    self.duration * self.listing.price
  end

  private

  def list_avail_at_checkin
    self.listing.reservations.each do |reservation|
      date1 = reservation.checkin
      date2 = reservation.checkout
      dates = (date1..date2).map{ |date| date }
      if dates.include?(self.checkin)
        self.errors[:base] << "Listing must be available to reserve"
      end
    end
  end

  def list_avail_at_checkout
    self.listing.reservations.each do |reservation|
      date1 = reservation.checkin
      date2 = reservation.checkout
      dates = (date1..date2).map{ |date| date }
      if dates.include?(self.checkout)
        self.errors[:base] << "Listing must be available to reserve"
      end
    end
  end

  def checkin_b4_checkout
    if self.checkin == nil || self.checkout == nil
      self.errors[:base] << "Checkin and checkout cant be nil"
    elsif self.checkout < self.checkin
      self.errors[:base] << "Checkin must be before checkout and neither can be nil"
    end
  end

  def checkin_is_not_checkout
    if self.checkin == nil || self.checkout == nil
      self.errors[:base] << "Checkin and checkout cant be nil"
    elsif self.checkin == self.checkout
      self.errors[:base] << "Checkin and checkout cant be the same"
    end
  end

  def no_res_your_listing
   if self.listing.host_id == self.guest_id
     self.errors[:base] << "A host can not reserve their own listing"
   end
  end

end
