module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id #envoi un cookie temporaire pour garder connecté l'utilisateur, et est détruit lorsqu'il quitte
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id #genere cookie pour l'id
    cookies.permanent[:remember_token] = user.remember_token #genere cookie pour le token
  end

  # Returns the user corresponding to the remember token cookie.
 def current_user
     if (user_id = session[:user_id]) #verifie si l'utilisateur s'est connecté
       @current_user ||= User.find_by(id: user_id)
     elsif (user_id = cookies.signed[:user_id]) #vérifie si l'utilisateur a des cookies permettant l'authentification
       user = User.find_by(id: user_id) #compare les cookies à la BDD
       if user && user.authenticated?(cookies[:remember_token]) #si l'utilisateur existe en que l'authentification avec le token crypté de notre BDD
         log_in user
         @current_user = user
       end
     end
   end

  def logged_in?
   !current_user.nil?
 end

 # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

 # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
