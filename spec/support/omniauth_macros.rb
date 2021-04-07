module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] =
      OmniAuth::AuthHash.new({
                               provider: 'twitter',
                               uid: '123545',
                               info: {
                                 first_name: "Gaius",
                                 last_name: "Baltar",
                                 email: "test@example.com"
                               },
                               credentials: {
                                 token: "123456",
                                 expires_at: Time.now + 1.week
                               },
                               extra: {
                                 raw_info: {
                                   gender: 'male'
                                 }
                               }
                             })
  end
end
