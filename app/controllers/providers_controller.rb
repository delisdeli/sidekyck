class ProvidersController < ApplicationController
  
  def destroy
    provider = Provider.find(params[:id])
    provider.destroy if provider.user.has_multiple_providers?
    redirect_to last_page
  end

end
