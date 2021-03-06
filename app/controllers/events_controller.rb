require 'cgi'
require 'chronic'

class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def details
    @event = Event.find_by id: params[:id]
  end

  def show
   respond_to do |format|
     @event = Event.find_by id: params[:id]
     format.html
     format.pdf do
       render pdf: "file_name"   # Excluding ".pdf" extension.
     end
   end
 end



  def new
    @event = Event.new
  end

  def create
    @event = Event.new
    @event.description = params[:event][:description]
    @event.buyer = params[:event][:buyer]
    @event.contact_person = params[:event][:contact_person]
    @event.phone = params[:event][:phone]
    @event.email = params[:event][:email]
    @event.website = params[:event][:website]
    date_parse = params[:event][:date]
    @event.date = date_parse
    @event.time_of_performance = params[:event][:time_of_performance]
    @event.location = params[:event][:location]
    @event.performance_type = params[:event][:performance_type]
    @event.performance_length = params[:event][:performance_length]
    @event.other_type = params[:event][:other_type]
    @event.ticket_price = params[:event][:ticket_price]
    @event.expected_attendance = params[:event][:xpected_attendance]
    @event.indoor_outdoor = params[:event][:indoor_outdoor]
    @event.performance_price = params[:event][:performance_price]

    event_location = @event.location

    results = JSON.parse(Http.get("http://locationiq.org/v1/search.php?key=5854c01d06bf4833124d&format=json&q=#{CGI::escape(event_location)}").body)

    if results.any?
      @event.latitude = results.first["lat"]
      @event.longitude  = results.first["lon"]
    end

     if @event.save
       email = @event.email
       DownPaymentMailer.collect_down_payment(email, @event).deliver_now
       redirect_to root_path, notice: "New Event Added"
     else
       flash.now[:alert] = "There was a problem with your form info"
       render :new
     end
  end

  def edit
    @event = Event.find_by id: params[:id]
  end

  def update
    @event = Event.find_by id: params[:id]
    @event = Event.new
    @event.description = params[:event][:description]
    @event.buyer = params[:event][:buyer]
    @event.contact_person = params[:event][:contact_person]
    @event.phone = params[:event][:phone]
    @event.email = params[:event][:email]
    @event.website = params[:event][:website]
    date_parse = params[:event][:date]
    @event.date = date_parse
    @event.time_of_performance = params[:event][:time_of_performance]
    @event.location = params[:event][:location]
    @event.performance_type = params[:event][:performance_type]
    @event.performance_length = params[:event][:performance_length]
    @event.other_type = params[:event][:other_type]
    @event.ticket_price = params[:event][:ticket_price]
    @event.expected_attendance = params[:event][:xpected_attendance]
    @event.indoor_outdoor = params[:event][:indoor_outdoor]
    @event.performance_price = params[:event][:performance_price]
      if @event.save
        redirect_to details_path(id: @event.id), notice: "This event has been updated"
      else
        render :edit
      end
  end


def delete
  @event = Event.find_by id: params[:id]
  @event.destroy
  redirect_to root_path, notice: "Your event has been deleted"
end



  def send_invoice
    @event = Event.find_by id: params[:event_id]
    email = params[:email]

    DownPaymentMailer.collect_down_payment(email, @event).deliver_now
  end


end
