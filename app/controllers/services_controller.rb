class ServicesController < ApplicationController

  before_filter :active_listing, only: [:create]
  before_filter :signed_in?, only: [:create, :update]

  def create
    @listing = current_user.listings.find(params[:listing_id])
    applicant = User.find(params[:applicant_id])
    if @listing.for_a_service?
      @listing.services.build( customer_id: @listing.user.id, provider_id: applicant.id, status: 'active' )
    elsif @listing.provides_a_service?
      @listing.services.build( customer_id: applicant.id, provider_id: @listing.user.id, status: 'active' )
    end
    if @listing.save
      message = "#{applicant.name} has been hired for this listing!"
      @listing.fill_position
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
      if params[:quit]
        service.quit
        redirect_to request.referer, notice: "You have quit. Someone else will be able to fill your position."
      elsif params[:submit]
        service.submit_for_approval
        redirect_to request.referer, notice: "Job complete! Waiting for customer approval."
      else
        redirect_to request.referer, notice: "Could not update the status of this service."
      end
    elsif current_user? service.customer
      service = Service.find_by_customer_id_and_listing_id( current_user.id , params[:listing_id] )
      if params[:approve]
        service.approve
        redirect_to request.referer, notice: "Job approved!"
      elsif params[:commit] == 'Rehire'
        service.rehire(params[:notes])
        redirect_to request.referer, notice: "Job not approved. #{service.associate.name} will be notified."
      elsif params[:commit] == 'Relist'
        service.relist
        redirect_to request.referer, notice: "Job not approved. This job has been relisted."
      else
        redirect_to request.referer, notice: "Could not update the status of this service."
      end
    else
      redirect_to request.referer, notice: "Could not update the status of this service."
    end
  end

end
