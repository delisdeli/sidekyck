class ApplicantsController < ApplicationController
  
  before_filter :set_listing

  def create
    @listing.applicants.build(user_id: current_user.id)
    if current_user.can_apply_for_listing?(@listing) and @listing.save
      flash[:green] = "You have applied for this listing!"
      @listing.user.send_notification( tunnel: "/listings/#{@listing.id}", body: "#{current_user.name} has applied for your listing!")
    else
      flash[:red] = "You could not apply to this listing."
    end
    redirect_to last_page
  end

  def destroy
    @application = current_user.applicants.find_by_id(params[:applicant_id])
    if @application
      @application.destroy
      flash[:blue] = "You have rescinded your application."
    else
      flash[:red] = "Application for this listing could not be found."
    end
      redirect_to last_page
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

end
