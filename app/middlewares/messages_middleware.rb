class MessagesMiddleware
  KEEPALIVE_TIME = 15

  def initialize(app)
    @app     = app
    @clients = Messages::BiHash.new

    Thread.new do
      bind() rescue Thread.main.raise($!)
    end

    EM.error_handler do |ex|
      Rails.logger.error [ex.inspect, ex.backtrace] if ex.backtrace.join() =~ /#{__FILE__}/i
    end
  end

  def call(env)
    if Faye::WebSocket.websocket? env
      ws = Faye::WebSocket.new env, nil, ping: KEEPALIVE_TIME

      ws.on :open do |event|
        Rails.logger.info [event.type, ws.object_id]
      end

      ws.on :message do |event|
        Rails.logger.info [event.type, ws.object_id, event.data]

        parsed = parse event.data

        if ["ws:subscribe", "ws:unsubscribe"].include? parsed[:event]
          send parsed[:event].sub("ws:", ""), ws, parsed
        else
          ws.send sanitize("ws:error", reason: "403 Forbidden")
        end
      end

      ws.on :close do |event|
        Rails.logger.info [event.type, ws.object_id, event.code, event.reason]

        @clients.reverse_get(ws).each do |channel|
          unsubscribe ws, channel: channel
        end

        ws = nil
      end

      ws.rack_response
    else
      @app.call env
    end
  rescue Exception => ex
    Rails.logger.error [ex.inspect, ex.backtrace]; raise ex;
  end

protected

  def bind()
    redis = Redis.new url: Redis.current.client.options[:url]

    redis.subscribe("ws:channels") do |on|
      on.subscribe do |channel, subscriptions|
        puts "Messages middleware bound..."
      end

      on.message do |channel, message|
        parsed = parse message
        @clients.get(parsed[:channel]).each {|ws| ws.send sanitize(parsed) }
      end
    end
  end

  def subscribe(ws, data)
    Messages.auth(data[:channel], data[:token]) do |channel, subscriber|
      if subscriber.exists?
        @clients.store channel, ws

        subscribers = Messages.subscribers channel
        subscribers[ws.object_id.to_s] = sanitize subscriber.to_h

        data = {
          subscriber: subscriber.to_h, subscribers: subscribers.values.map {|subscriber| parse(subscriber) }
        }

        Messages.publish channel, "ws:subscribers:add", data
      else
        ws.send sanitize(event: "ws:error", reason: "401 Unauthorized")
      end
    end
  end

  def unsubscribe(ws, data)
    Messages.subscribers(data[:channel]) do |channel, subscribers|
      if subscribers.has_key? ws.object_id
        @clients.reverse_delete ws

        subscriber = parse subscribers.get(ws.object_id.to_s)
        subscribers.delete ws.object_id.to_s

        Messages.publish channel, "ws:subscribers:remove", subscriber
      else
        ws.send sanitize(event: "ws:error", reason: "404 Not Found")
      end
    end
  end

  def sanitize(data)
    data.to_json
  end

  def parse(data)
    JSON.parse(data).with_indifferent_access
  end
end
