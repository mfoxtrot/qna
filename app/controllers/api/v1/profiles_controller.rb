class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resource_ownwer
  end

  def list
    respond_with User.where('id!=?', current_resource_ownwer.id)
  end

  private

  def current_resource_ownwer
    @current_resource_ownwer ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
