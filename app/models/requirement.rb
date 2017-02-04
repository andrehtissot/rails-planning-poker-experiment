class Requirement < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :project
  has_many :estimates

  def ar estimate
    (self.real_effort - estimate).abs
  end
end
