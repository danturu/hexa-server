Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FACEBOOK_PUBLIC_KEY"], ENV["FACEBOOK_SECRET_KEY"]
  provider :twitter,  ENV["TWITTER_PUBLIC_KEY"],  ENV["TWITTER_SECRET_KEY"]
end