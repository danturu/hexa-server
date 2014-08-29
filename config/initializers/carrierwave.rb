CarrierWave.configure do |config|
  config.cache_dir  = Rails.root.join("tmp/uploads")
  config.asset_host = ENV["HEXA_STORAGE_URL"]
end
