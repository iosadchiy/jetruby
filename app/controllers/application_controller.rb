class ApplicationController < ActionController::Base
  respond_to :html
  responders :flash, :http_cache, :collection
end
