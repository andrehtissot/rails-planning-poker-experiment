class Estimate < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :team
  belongs_to :requirement
  has_many :rounds
  validates :effort_estimate, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :justification, presence: true
end
