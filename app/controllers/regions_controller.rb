class RegionsController < ApplicationController
  def index
    render json: RivalRegion.all
  end

  def show
    entry = RivalRegion.find(params[:id])
    render json: entry
  end
end
