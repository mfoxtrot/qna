class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user_and_redirect

  def github; end

  def meetup; end

  private

  def find_user_and_redirect
    oauth_params = request.env['omniauth.auth']
    @user = User.find_for_oauth(oauth_params)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      provider = oauth_params.provider
      uid = oauth_params.uid
      redirect_to new_user_registration_path(provider: provider, uid: uid)
    end
  end
end
