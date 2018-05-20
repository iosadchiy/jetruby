# == Schema Information
#
# Table name: api_stats
#
#  id         :bigint(8)        not null, primary key
#  create_avg :float
#  create_n   :bigint(8)
#  index_avg  :float
#  index_n    :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_api_stats_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class ApiStat < ApplicationRecord
  belongs_to :user

  def self.inject
    ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
      event = ActiveSupport::Notifications::Event.new *args
      if valid_request?(event.payload[:controller], event.payload[:action])
        process_request(event.payload[:headers]['Authorization'],
          event.payload[:action], event.duration)
      end
    end
  end

  def self.valid_request?(controller, action)
    controller == "Api::V1::AppointmentsController" && ["index", "create"].include?(action)
  end

  def self.process_request(auth_header, request, duration)
    if user = User.from_authorization_header(auth_header)
      transaction do
        user.api_stat.record!(request, duration)
      end
    end
  end

  after_initialize do
    self.index_n     ||= 0
    self.index_avg   ||= 0
    self.create_n    ||= 0
    self.create_avg  ||= 0
  end

  def record!(request, time)
    raise "request should be one of index, create" unless ['index', 'create'].include?(request)
    avg_field = request + '_avg'
    n_field = request + '_n'
    avg = send(avg_field)
    n = send(n_field)
    update!(avg_field => (avg*n+time)/(n+1), n_field => n+1)
  end
end
