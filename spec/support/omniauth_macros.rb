module OmniAuthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '01234567890',
      'info' => {
        'email' => 'johndow@example.com'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })

    OmniAuth.config.mock_auth[:meetup] = OmniAuth::AuthHash.new({
      'provider' => 'meetup',
      'uid' => '112233445566',
      'info' => {
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end
end
