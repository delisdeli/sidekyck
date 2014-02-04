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
    if params[:reject]
      @rejected = true
    end
    @listing = Listing.find(params[:id])
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
    if current_user.save
      flash[:green] = 'Listing was successfully created.'
      redirect_to @listing
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /listings/1
  def update
    if params[:deactivate]
      @listing.status = 'inactive'
      @listing.save!
      flash[:green] = 'You have successfully deactivated the listing.'
      redirect_to @listing
    else
      if @listing.update(listing_params)
        flash[:green] = 'Listing was successfully updated.'
        redirect_to @listing
      else
        render action: 'edit'
      end
    end
  end

  # DELETE /listings/1
  def destroy
    unless @listing.has_services?
      @listing.destroy
      flash[:green] = 'Listing was successfully destroyed.'
      redirect_to root_url
    else
      flash[:red] = 'Cannot delete a listing after a user has been hired.'
      redirect_to last_page
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def listing_params
      params.require(:listing).permit(:user_id, :price, :instructions, :title, :start_time, :end_time,
       :requirements, :status, :positions, :audience, :description, :category)
    end
end
