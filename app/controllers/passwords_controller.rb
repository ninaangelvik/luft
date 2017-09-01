class PasswordsController < Devise::PasswordsController 
  
  def new
    flash[:error] = "Du har ikke adgang til denne siden"
    redirect_to new_user_session_path
  end

  def edit
    flash[:error] = "Du har ikke adgang til denne siden"
    redirect_to new_user_session_path
  end
end