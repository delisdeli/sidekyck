class ListingsController < ApplicationController
  before_filter :set_listing, only: [:show, :edit, :update, :destroy]
  before_filter :signed_in_user, except: [:show, :index]

  # GET /listings
  def index
    
    if signed_in?
      @listings = Listing.where(status: 'active', audience: 'everyone') + current_user.friends_friend_listings
    else
      @listings = Listing.where(status: 'active', audience: 'everyone')
    end
  end

  # GET /listings/1
  def show
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  def create
    @listing = current_user.listings.build(listing_params)

    if current_user.save!
      redirect_to @listing, notice: 'Listing was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /listings/1
  def update
    if @listing.update(listing_params)
      redirect_to @listing, notice: 'Listing was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /listings/1
  def destroy
    @listing.destroy
    redirect_to root_url, notice: 'Listing was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def listing_params
      params.require(:listing).permit(:user_id, :price, :instructions, :title, :start_time, :end_time,
       :requirements, :status, :positions, :audience, :description)
    end
end
