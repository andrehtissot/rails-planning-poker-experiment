class EstimatesController < ApplicationController
  before_action :set_requirements_to_estimate
  before_action :set_team
  before_action :set_project
  before_action :set_requirement
  before_action :set_estimate
  before_action :set_round_participants, only: [:index, :create_round]
  before_action :log_access

  # GET /estimates
  def index
    @round = Round.new({estimate:@estimate})
    @round.round_participants = @round_participants
    @estimate_errors = flash[:estimate_errors]
    @estimate_justification = flash[:estimate_justification].present? && (@estimate.justification.nil? || @estimate.justification.empty?) ? flash[:estimate_justification] : nil
    @estimate_effort_estimate = flash[:estimate_effort_estimate].present? && @estimate.effort_estimate.nil? ? flash[:estimate_effort_estimate] : nil
    @estimate.errors.add(:effort_estimate, @estimate_errors.first) if @estimate_errors.present? && @estimate_errors.first.include?('Estimativa final')
    @estimate.errors.add(:justification, @estimate_errors.first) if @estimate_errors.present? && @estimate_errors.last.include?('Justificativa final')
    @is_all_requirements_estimated = is_all_requirements_estimated
  end

  # POST /estimates
  def create
    @estimate = Estimate.new(estimate_params)
    @estimate.team = @team
    respond_to do |format|
      if @estimate.save
        format.html { redirect_to estimates_path({requirement:@estimate.requirement}), notice: 'A estimativa foi salva com sucesso.' }
      else
        format.html { render :index }
      end
    end
  end

  # PATCH/PUT /estimates/1
  def update
    @estimate.team = @team
    respond_to do |format|
      if @estimate.update(estimate_params)
        format.html { redirect_to estimates_path({requirement:@estimate.requirement}), notice: 'A estimativa foi alterada com sucesso.' }
      else
        format.html { redirect_to estimates_path({requirement:@estimate.requirement}), :flash => {
          estimate_errors: @estimate.errors.full_messages, estimate_effort_estimate: @estimate.effort_estimate,
          estimate_justification: @estimate.justification }}
      end
    end
  end

  def create_round
    @round = Round.new(round_params)
    @round.number = @estimate.rounds.size + 1
    @round.round_participants = @round_participants
    @estimate = @round.estimate
    @requirement = @estimate.requirement
    if @round.save
      redirect_to estimates_path({requirement:@estimate.requirement})
    else
      render :index
    end
  end

  private
    def set_estimate
      @estimate = Estimate.where({team:@team, requirement:@requirement}).last
      unless @estimate
        @estimate = Estimate.new
        @estimate.team = @team
        @estimate.requirement = @requirement
        @estimate.save(validate: false)
      end
    end

    def estimate_params
      estimate_params = params.require(:estimate).permit(:team_id, :requirement_id, :effort_estimate, :justification)
      estimate_params[:effort_estimate].gsub!(',','.')
      estimate_params
    end

    def round_params
      params.require(:round).permit(:estimate_id)
    end

    def set_requirements_to_estimate
      @requirements_to_estimate = Requirement.where(for_experiment: true)
    end

    def set_requirement
      @requirement = params[:estimate].nil? || params[:estimate][:requirement_id].nil? ?
        Requirement.find(params[:requirement]) :
        Requirement.find(estimate_params[:requirement_id]) rescue nil
    end

    def set_team
      begin
        @team = Team.find(session[:team_id])
      rescue
        redirect_to teams_path
      end
    end

    def set_project
      @project = Requirement.where(for_experiment: true).first.project
    end

    def set_round_participants
      @round_participants = []
      if params[:round_participants].present?
        params.require(:round_participants).each do |param_round_participant|
          round_participant_params = param_round_participant.permit(:participant_id,:effort_estimate,:justification)
          round_participant_params[:effort_estimate] = round_participant_params[:effort_estimate].gsub(',','.')
          @round_participants << RoundParticipant.new(round_participant_params)
        end
      else
        @team.participants.each do |participant|
          @round_participants << RoundParticipant.new({participant:participant})
        end
      end
    end

    def is_all_requirements_estimated
      (0 == @requirements_to_estimate.count -
        Estimate.where({team:@team, requirement:@requirements_to_estimate}).where('effort_estimate IS NOT NULL AND effort_estimate > 0').count)
    end
end
