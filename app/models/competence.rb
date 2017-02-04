class Competence < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :participant
  validates_presence_of :title
  validates_presence_of :level

  def level_verbose
    case level
      when 1 then 'Básico'
      when 2 then 'Intermediário'
      when 3 then 'Avançado'
      else ''
    end
  end
end
