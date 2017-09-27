class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_create :change_host_status_to_true

  before_destroy :change_host_status_to_false

  def average_review_rating
    self.reviews.map{|review| review.rating}.sum.to_f/self.reviews.length
  end

  private
    def change_host_status_to_true
      user = User.find(self.host_id)
      user.host = true
      user.save
    end

    def change_host_status_to_false
      user = User.find(self.host_id)
      if user.listings.length == 1
        user.host = false
        user.save
      end
    end

end
