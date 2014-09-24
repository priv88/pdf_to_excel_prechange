class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_ip_address

  WHITELIST = ['96.239.59.199','127.0.0.1','184.73.46.234']

  def check_ip_address
    # puts request.env["REMOTE_ADDR"]
    @ip = request.env["REMOTE_ADDR"]

    unless(WHITELIST.include? @ip)
      render :file => "#{Rails.public_path}/401.html", :status => :unauthorized, :notice => @ip
    end
    return
  end

end
