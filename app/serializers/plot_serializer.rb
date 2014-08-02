class PlotSerializer < ActiveModel::Serializer
  attributes :id, :tag

  has_many :images
end
