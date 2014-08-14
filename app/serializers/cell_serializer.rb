class CellSerializer < ActiveModel::Serializer
  attributes :id, :x, :y, :metadata, :object_id

  # since serializer shadows any attribute named object...

  def object_id
    object.object_id
  end
end