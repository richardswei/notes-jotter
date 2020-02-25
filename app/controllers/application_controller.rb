class ApplicationController < ActionController::Base

  # redirect to dashboard after successful login
  def after_sign_in_path_for(resource)
    authenticated_root_path
  end

end
