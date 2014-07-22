ActiveModel::Serializer.setup do |config|
  config.root      = false
  config.namespace = true
end

# Makes Mongoid and ActiveModel::Serializer play nicely.

Mongoid::Document.send :include, ActiveModel::SerializerSupport
Mongoid::Criteria.delegate :active_model_serializer, to: :to_a