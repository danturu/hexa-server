Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FACEBOOK_PUBLIC_KEY"], ENV["FACEBOOK_SECRET_KEY"], scope: "email, user_friends", image_size: "large", secure_image_url: true
end
