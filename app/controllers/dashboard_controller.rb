require 'cgi'
class DashboardController < ApplicationController

  before_action  do
      if @current_account.nil?
        redirect_to welcome_path
      end
    end

  def home
    @events = Event.all
  end

end
