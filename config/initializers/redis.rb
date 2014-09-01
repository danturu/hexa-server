
    trap "SIGTERM" do
      p "sdc"
    end

if ENV.has_key? "REDISCLOUD_URL"
  Redis.current = Redis.new url: ENV["REDISCLOUD_URL"]
else
  Redis.current = Redis.new
end
