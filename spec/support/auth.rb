def build_auth(user=nil)
  user ||= create(:user)
  OmniAuth::AuthHash.new({
    provider: "google_oauth2",
    uid: user.uid,
    info: {
      email: user.email},
      credentials: {token: user.oauth_token,
      expires_at: user.oauth_expires_at
    }
  })
end

def stub_omniauth(user=nil)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = build_auth(user)
end

def sign_in(user=nil)
  stub_omniauth(user)
  visit "/auth/google_oauth2"
  expect(page).to have_content("Sign out")
end
