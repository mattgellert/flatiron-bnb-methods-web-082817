class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, presence: true

  validate :has_res_been_accepted_and_checked_out

  private

  def has_res_been_accepted_and_checked_out
    if self.reservation.nil? || self.reservation.status != "accepted" || self.reservation.checkout >= Date.today
      self.errors[:base] << "There must be a reservation to write a review"
    end
  end

end
