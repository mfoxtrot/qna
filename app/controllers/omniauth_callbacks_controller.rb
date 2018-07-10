class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user_and_redirect

  def github; end

  def meetup; end

  private

  def find_user_and_redirect
    oauth_params = request.env['omniauth.auth']
    user = User.find_for_oauth(oauth_params)
    if user
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      session[:provider] = oauth_params.provider
      session[:uid] = oauth_params.uid.to_s
      redirect_to new_user_registration_path
    end
  end
end
