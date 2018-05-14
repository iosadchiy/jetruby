def build_auth
  OpenStruct.new(
    provider: "google_oauth2",
    uid: "112174922549832904403",
    info: OpenStruct.new(email: "test@example.com"),
    credentials: OpenStruct.new(token: "some_token", expires_at: 1.hour.since(Time.current))
  )
end
