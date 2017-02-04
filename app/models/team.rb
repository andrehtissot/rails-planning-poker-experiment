class Team < ActiveRecord::Base
  acts_as_paranoid
  has_many :team_participants
  has_many :participants, through: :team_participants
  validates :name, presence: true, uniqueness: true
end
