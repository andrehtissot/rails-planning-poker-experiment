class Participant < ActiveRecord::Base
  acts_as_paranoid
  has_many :competences
  has_many :round_participants
  has_many :rounds, through: :round_participants
  has_many :team_participants
  has_many :teams, through: :team_participants
  validates :name, presence: true
  validates :sex, presence: true
  validates :competences, presence: true
  validates :birthday, timeliness: { before: lambda{Date.current}, type: :date }

  def sex_verbose
    case sex
      when 1 then 'Masculino'
      when 2 then 'Feminino'
      else ''
    end
  end

  def birthday_verbose
  	self.birthday.strftime("%d/%m/%Y") rescue ''
  end
end
