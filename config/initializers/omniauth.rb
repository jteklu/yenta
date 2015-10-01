Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], {:scope => 'user_about_me, user_birthday, user_location, email'}
	provider :facebook, "512874345543841", "f4501f23466a7a3487238ecb28bb23cc", {:scope => 'user_about_me, user_birthday, user_location, email'}

end

