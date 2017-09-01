class RegistrationsController < Devise::RegistrationsController 
  
  def new
    redirect_to root_path
  end
end