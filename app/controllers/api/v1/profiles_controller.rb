class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    respond_with current_resource_ownwer
  end

  def list
    respond_with User.where.not('id=?', current_resource_ownwer.id)
  end
end
