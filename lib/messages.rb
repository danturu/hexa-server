module Messages
  def self.sign(channel, subscriber)
    fragments = [channel, subscriber.fetch(:id).to_s, rand.to_s].join(":")

    Digest::SHA1.hexdigest(fragments).tap do |token|
      key = [:ws, :tokens, channel, token].join(":")
      Redis::HashKey.new(key, expiration: 30.seconds).fill(subscriber.to_h)
    end
  end

  def self.auth(channel, token)
    Redis::HashKey.new([:ws, :tokens, channel, token].join(":")).tap do |subscriber|
      yield channel, subscriber if block_given?
    end
  end

  def self.publish(channel, event, data)
    options = { channel: channel, event: event, data: data }.to_json
    Redis.current.publish "ws:channels", options
  end

  def self.subscribers(channel)
    Redis::HashKey.new([:ws, :subscribers, channel].join(":")).tap do |subscribers|
      yield channel, subscribers if block_given?
    end
  end

  class BiHash
    def initialize
      @forward = Hash.new {|h, k| h[k] = Set.new }
      @reverse = Hash.new {|h, k| h[k] = Set.new }
    end

    def store(k, v)
      @forward[key(k)] << v
      @reverse[key(v)] << k
    end

    def get(k)
      @forward[key(k)]
    end

    def reverse_get(v)
      @reverse[key(v)]
    end

    def delete(k)
      get(k).each {|v| @reverse[key(v)].delete(k) }
    end

    def reverse_delete(v)
      reverse_get(v).each {|k| @forward[key(k)].delete(v) }
    end

  protected

    def key(k)
      if k.is_a?(String) or k.is_a?(Symbol)
        k
      else
        k.object_id.to_s
      end
    end
  end
end
