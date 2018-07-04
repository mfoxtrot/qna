class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user_and_redirect, only: [:github]

  def github; end

  private

  def find_user_and_redirect
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    end
  end
end
