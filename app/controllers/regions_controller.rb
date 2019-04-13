class RegionsController < ApplicationController
  def index
    @regions = RivalRegion.all
    render json: @regions, each_serializer: RivalRegionSlimSerializer
  end

  def show
    entry = RivalRegion.find(params[:id])
    render json: entry, serializer: RivalRegionSerializer
  end
end
