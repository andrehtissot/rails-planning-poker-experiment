class Round < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :estimate
  has_many :round_participants
  validates :estimate, presence: true
  validates :number, presence: true
end
