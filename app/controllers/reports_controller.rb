class ReportsController < EstimatesController
  before_action :look_if_its_blocked

  def comparation_table
    @estimates = @requirements_to_estimate.collect do |requirement|
      requirement.estimates.where({team:@team}).where('effort_estimate IS NOT NULL AND effort_estimate > 0').last
    end
    @is_all_requirements_estimated = is_all_requirements_estimated
  end

  def look_if_its_blocked
    redirect_to estimates_path if BLOCK_RESULTS_INDEX || !is_all_requirements_estimated
  end
end
