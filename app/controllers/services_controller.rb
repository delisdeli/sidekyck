class ServicesController < ApplicationController

  before_filter :active_listing, only: [:create]
  before_filter :signed_in?, only: [:create, :update]

  def create
    @listing = current_user.listings.find(params[:listing_id])
    @listing.applicants.find_by_user_id(params[:applicant_id]).destroy
    applicant = User.find(params[:applicant_id])
    if @listing.for_a_service?
      @listing.services.build( customer_id: @listing.user.id, provider_id: applicant.id, status: 'active' )
    elsif @listing.provides_a_service?
      @listing.services.build( customer_id: applicant.id, provider_id: @listing.user.id, status: 'active' )
    end
    if @listing.save
      flash[:green] = "#{applicant.name} has been hired for this listing!"
      @listing.fill_position
      applicant.send_notification( tunnel: "/listings/#{@listing.id}", body: "You've been hired for a listing!")
    else
      flash[:red] = "Failed to hire #{applicant.name} for this listing."
    end

    redirect_to last_page
  end

  def show
  end

  def update
    service = Service.find(params[:id])
    if current_user? service.provider
      service = Service.find_by_provider_id_and_listing_id( current_user.id, params[:listing_id] )
      listing = service.listing
      if params[:quit]
        service.quit
        service.customer.send_notification( tunnel: "/listings/#{listing.id}", body: "#{current_user.name} quit.")
        flash[:blue] = "You have quit. Someone else will be able to fill your position."
        redirect_to last_page
      elsif params[:submit]
        service.submit_for_approval
        service.customer.send_notification( tunnel: "/listings/#{listing.id}", body: "#{current_user.name} has completed a task for you, let them know how they did!")
        flash[:green] = "Job complete! Waiting for customer approval."
        redirect_to last_page
      else
        flash[:red] = "Could not update the status of this service."
        redirect_to last_page
      end
    elsif current_user? service.customer
      service = Service.find_by_customer_id_and_listing_id( current_user.id , params[:listing_id] )
      listing = service.listing
      if params[:approve]
        service.approve
        service.provider.send_notification( tunnel: "/listings/#{listing.id}", body: "Your job has been approved!")
        flash[:green] = "Job approved!"
        redirect_to last_page
      elsif params[:commit] == 'Rehire'
        service.rehire(params[:notes])
        flash[:blue] = "Job not approved. #{service.associate.name} will be notified."
        service.provider.send_notification( tunnel: "/listings/#{listing.id}", body: "Your job has been rejected, see what still needs to be done.")
        redirect_to last_page
      elsif params[:commit] == 'Relist'
        service.relist
        flash[:blue] = "Job not approved. This job has been relisted."
        service.provider.send_notification( tunnel: "/listings/#{listing.id}", body: "Your job has been rejected and relisted.")
        redirect_to last_page
      else
        flash[:red] = "Could not update the status of this service."
        redirect_to last_page
      end
    else
      flash[:red] = "Could not update the status of this service."
      redirect_to last_page
    end
  end

end
