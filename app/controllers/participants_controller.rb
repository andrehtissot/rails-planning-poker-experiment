class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy, :add_to_list, :confirm_add_to_list, :remove_from_list]
  before_action :set_team
  before_action :set_selected_participants
  before_action :set_competences, only: [:create, :update]
  before_action :expires_now
  before_action :log_access

  # GET /participants
  # GET /participants.json
  def index
    @participants = Participant.all.to_a.delete_if {|participant| @selected_participants.include? participant}
  end

  # GET /participants/new
  def new
    @participant = Participant.new sex: 1, competences: [
      Competence.new({title:'Estimativa de Software',level:1}),
      Competence.new({title:'Java',level:1}),
      Competence.new({title:'Sistemas Operacionais',level:1})]
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants
  # POST /participants.json
  def create
    @participant = Participant.new(participant_params)
    @participant.competences = @competence
    respond_to do |format|
      if @participant.save
        TeamParticipant.create(participant: @participant, team: @team)
        format.html { redirect_to participants_url }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participants/1
  # PATCH/PUT /participants/1.json
  def update
    @participant_bkp = Participant.new(@participant.attributes)
    respond_to do |format|
      if @participant.update(participant_params)
        @participant.competences.delete_all
        @competence.each {|competence| competence.participant = @participant; competence.save}
        @participant_bkp.id = nil
        @participant_bkp.original_participant_id = @participant.id
        @participant_bkp.save(validate: false)
        @participant_bkp.delete
        format.html { redirect_to add_to_list_participant_url(@participant), notice: 'Participant was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant }
      else
        format.html { render :edit }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    @participant.destroy
    respond_to do |format|
      format.html { redirect_to participants_url, notice: 'Participant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_to_list
    render :add_to_list
  end

  def confirm_add_to_list
    unless @selected_participants.include? @participant
      TeamParticipant.create(participant: @participant, team: @team)
    end
    redirect_to participants_url
  end

  def remove_from_list
    if @selected_participants.include? @participant
      TeamParticipant.find_by(participant_id: @participant.id, team: @team).delete
    end
    redirect_to participants_url
  end

  private
    def set_team
      begin
        @team = Team.find(session[:team_id])
      rescue
        redirect_to teams_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_participant
      @participant = Participant.find(params[:id])
    end

    def set_competences
      competence = params.require(:competence)
      @competence = []
      competence['title'].each do |title_idx|
        @competence << Competence.new(title: title_idx.last,
          level: (competence['level'][title_idx.first] rescue nil)) unless title_idx.last.empty?
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def participant_params
      params.require(:participant).permit(:name, :birthday, :function, :sex)
    end

    def set_selected_participants
      @selected_participants = session[:team_id] ?
        @team.team_participants.collect(&:participant) : []
    end
end
