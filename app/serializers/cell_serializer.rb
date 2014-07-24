class CellSerializer < ActiveModel::Serializer
  attributes :id, :x, :y, :metadata

  # since serializer shadows any attribute named object...

  has_one :cell_object, root: :object

  def cell_object
    object.object
  end
end