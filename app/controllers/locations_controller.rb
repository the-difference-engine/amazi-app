class LocationsController < ApplicationController
  before_action :authenticate_admin!, except: [:show, :map]
  
  def show
    @location = Location.find(params[:id])
    @client = GooglePlaces::Client.new(ENV['GOOGLE_PLACES_API_KEY'])
    faddress = "#{@location.address}, #{@location.city}, #{@location.state}"
    @c = @client.spots(@location.latitude, @location.longitude, :formatted_address => faddress, :radius => 1)
  end

  def map
  end

  def index
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  def edit
    @location = Location.find(params[:id])
  end

  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to "/admin"
    else

    end
  end

  def update
    @location = Location.find(params[:id])
    @location.attributes = location_params
    if @location.save
      redirect_to "/admin"
    else

    end
  end

  def destroy
    @location = Location.find(params[:id])
    if @location.destroy
      redirect_to "/admin"
    else

    end
  end

  private

  def location_params
    params.require(:location).permit(:address, :city, :state, :zip, :location_subcategory_id, :water_provider_id, :latitude, :longitude)
  end
end
