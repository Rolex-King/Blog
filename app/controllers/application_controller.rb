class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
   protect_from_forgery with: :exception

   before_action :set_categories


  	protected

  	#Amenos que el usuario esté logueado y tenga permisos de editor
	def authenticate_editor!
		redirect_to root_path unless user_signed_in? && current_user.is_editor?
	end
  	
  	#Amenos que el usuario esté logueado y tenga permisos de admin
	def authenticate_admin!
		redirect_to root_path unless user_signed_in? && current_user.is_admin?
	end



  private

  def set_categories
  	@categories = Category.all
  end
  
end
