class RoundsController < ApplicationController
  before_action :set_requirements_to_estimate
  before_action :set_team
  before_action :set_requirement
  before_action :set_estimate
  before_action :set_round_participants
  before_action :log_access

  def new
    @round = Round.new({estimate:@estimate})
    @round.round_participants = @round_participants
  end

  def create
    @round = Round.new(round_params)
    @round.number = @estimate.rounds.size + 1
    @round.round_participants = @round_participants
    if @round.save
      render text: '<script>window.close()</script>'
    else
      render :new
    end
  end

  private
    def set_estimate
      @estimate = Estimate.where({team:@team, requirement:@requirement}).last
      @estimate = Estimate.create({team:@team, requirement:@requirement}) unless @estimate
    end

    def round_params
      params.require(:round).permit(:estimate_id)
    end

    def set_requirements_to_estimate
      @requirements_to_estimate = Requirement.where(for_experiment: true)
    end

    def set_requirement
      @requirement = params[:requirement].present? ?
        Requirement.find(params[:requirement]) :
        Requirement.find(params[:requirement_id]) rescue nil
    end

    def set_round_participants
      @round_participants = []
      if params[:round_participants].present?
        params.require(:round_participants).each do |param_round_participant|
          @round_participants << RoundParticipant.new(param_round_participant.permit(:participant_id,:effort_estimate,:justification))
        end
      else
        @team.participants.each do |participant|
          @round_participants << RoundParticipant.new({participant:participant})
        end
      end
    end

    def set_team
      begin
        @team = Team.find(session[:team_id])
      rescue
        redirect_to teams_path
      end
    end
end
