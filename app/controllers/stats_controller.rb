class StatsController < ApplicationController
  def index
    @api_stats = ApiStat.all.includes(:user)
  end
end
