Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FACEBOOK_PUBLIC_KEY"], ENV["FACEBOOK_SECRET_KEY"], image_size: "large",    secure_image_url: true
  provider :twitter,  ENV["TWITTER_PUBLIC_KEY"],  ENV["TWITTER_SECRET_KEY"],  image_size: "original", secure_image_url: true
end
