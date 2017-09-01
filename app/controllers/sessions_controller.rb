class SessionsController < Devise::SessionsController 

  def new
    flash[:error] = "Du har ikke adgang til denne siden."
    redirect_to root_path
  end
end