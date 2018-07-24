class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    respond_with current_resource_ownwer, serializer: ProfileSerializer, root: 'profile'
  end

  def list
    respond_with User.where.not('id=?', current_resource_ownwer.id), each_serializer: ProfileSerializer, root: 'profiles'
  end
end
