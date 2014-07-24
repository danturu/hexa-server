class Api::V1::ObjectsController < Api::V1::BaseController
  def index
    planets = ActiveModel::ArraySerializer.new Planet.all, each_serializer: PlanetSerializer
    plots   = ActiveModel::ArraySerializer.new Plot.all,   each_serializer: PlotSerializer
    units   = ActiveModel::ArraySerializer.new Unit.all,   each_serializer: UnitSerializer

    render json: { planets: planets, plots: plots, units: units }
  end
end