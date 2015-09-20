module SessionHelper

  def logged_in?
    not session[:id].nil?
  end
end
