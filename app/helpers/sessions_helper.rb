module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id #envoi un cookie temporaire pour garder connecté l'utilisateur, et est détruit lorsqu'il quitte
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
   !current_user.nil?
 end

 # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
