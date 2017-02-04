class Project < ActiveRecord::Base
  acts_as_paranoid
  has_many :requirements
end
