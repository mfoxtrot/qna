class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  private

  def current_resource_ownwer
    @current_resource_ownwer ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  alias current_user current_resource_ownwer
end
