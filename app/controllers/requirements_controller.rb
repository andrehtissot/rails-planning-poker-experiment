class RequirementsController < ApplicationController
  before_action :set_project_ids
  before_action :log_access
  before_action :set_team
  before_action :look_if_its_blocked

  def index
    @filters = {}
  end

  def search
    @filters = params.permit(:description, :project_id, :real_effort_min, :real_effort_max)
    @requirements = Requirement.where(for_experiment: false)
    @requirements = @requirements.where({project_id: @filters[:project_id]}) if @filters[:project_id].present?
    @requirements = @requirements.where("real_effort >= ?", @filters[:real_effort_min]) if @filters[:real_effort_min].present?
    @requirements = @requirements.where("real_effort <= ?", @filters[:real_effort_max]) if @filters[:real_effort_max].present?
    keywords_order = ''
    if @filters[:description].present?
      description = @filters[:description].clone
      keywords = description.scan(/("[^"]+")+/).collect {|keyword| keyword.first[1..-2]}
      keywords.reject!(&:empty?)
      keywords.each {|keyword| description.gsub!("\"#{keyword}\"",'') }
      description = description.gsub("'",'').gsub('"','')
      keywords.concat(description.scan(/([^ ]+)/).collect {|keyword| keyword.first})
      keywords.reject!(&:empty?)
      keywords_conditions =(keywords.collect {|keyword| "(requirements.description LIKE \"%#{keyword}%\" OR projects.objective LIKE \"%#{keyword}%\" OR projects.technologies LIKE \"%#{keyword}%\")"})
      @requirements = @requirements.where(keywords_conditions.join(' AND '))
      keywords_order = keywords.collect do |keyword|
        ['requirements.description', 'projects.objective', 'projects.technologies'].collect do |field|
          "((LENGTH(#{field}) - LENGTH(REPLACE(#{field}, '#{keyword}', ''))) / #{keyword.size})"
        end.join(' + ')
      end.join(' + ')
      keywords_order += ' DESC,'
    end
    @requirements = @requirements.joins(:project).order("#{keywords_order} projects.title ASC, relative_starting_point ASC")
  end

  def show
    redirect_to requirements_path if params.permit(:id)['id'] == 'search'
    @requirement = Requirement.where(params.permit(:id)).last
  end

  private
  def set_project_ids
    @project_ids = (Project.all.order(title: :asc).reject {|project| project.requirements.where(for_experiment: false).count == 0}).
      collect {|p| ["#{p.title} (#{p.size} homens-hora)",p.id]}
  end

  def set_team
    begin
      @team = Team.find(session[:team_id])
    rescue
      redirect_to teams_path
    end
  end

  def look_if_its_blocked
    redirect_to teams_path if BLOCK_REQUIREMENTS_INDEX
  end
end
