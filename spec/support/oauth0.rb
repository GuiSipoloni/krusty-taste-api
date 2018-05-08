def authenticated_header(user_id)
    token = Knock::AuthToken.new(payload: { sub: user_id }).token

    {
      "Authorization": "Bearer #{token}"
    }
  end