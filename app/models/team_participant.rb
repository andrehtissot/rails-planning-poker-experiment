class TeamParticipant < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :participant
  belongs_to :team
end
