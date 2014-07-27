ActiveModel::Serializer.root      = false
ActiveModel::ArraySerializer.root = false

# Makes Mongoid and ActiveModel::Serializer play nicely.

Mongoid::Document.send :include, ActiveModel::SerializerSupport
Mongoid::Criteria.delegate :active_model_serializer, to: :to_a