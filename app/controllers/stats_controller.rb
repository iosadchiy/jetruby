class StatsController < ApplicationController
  def index
    @api_stats = ApiStat.all
  end
end
