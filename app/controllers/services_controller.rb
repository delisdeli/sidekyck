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
      message = "#{applicant.name} has been hired for this listing!"
      @listing.fill_position
      applicant.send_notification( tunnel: "/listings/#{@listing.id}", body: "You've been hired for a listing!")
    else
      message = "Failed to hire #{applicant.name} for this listing."
    end

    redirect_to request.referer, notice: message
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
        redirect_to request.referer, notice: "You have quit. Someone else will be able to fill your position."
      elsif params[:submit]
        service.submit_for_approval
        redirect_to request.referer, notice: "Job complete! Waiting for customer approval."
        service.customer.send_notification( tunnel: "/listings/#{listing.id}", body: "#{current_user.name} has completed a task for you, let them know how they did!")
      else
        redirect_to request.referer, notice: "Could not update the status of this service."
      end
    elsif current_user? service.customer
      service = Service.find_by_customer_id_and_listing_id( current_user.id , params[:listing_id] )
      listing = service.listing
      if params[:approve]
        service.approve
        redirect_to request.referer, notice: "Job approved!"
        service.provider.send_notification( tunnel: "/listings/#{listing.id}", body: "Your job has been approved!")
      elsif params[:commit] == 'Rehire'
        service.rehire(params[:notes])
        redirect_to request.referer, notice: "Job not approved. #{service.associate.name} will be notified."
        service.provider.send_notification( tunnel: "/listings/#{listing.id}", body: "Your job has been rejected, see what still needs to be done.")
      elsif params[:commit] == 'Relist'
        service.relist
        redirect_to request.referer, notice: "Job not approved. This job has been relisted."
        service.provider.send_notification( tunnel: "/listings/#{listing.id}", body: "Your job has been rejected and relisted.")
      else
        redirect_to request.referer, notice: "Could not update the status of this service."
      end
    else
      redirect_to request.referer, notice: "Could not update the status of this service."
    end
  end

end
