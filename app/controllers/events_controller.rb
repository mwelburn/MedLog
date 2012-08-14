class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user, :only => [:index, :show]
  before_filter :load_event, :only => [:show, :update, :destroy]

  def index
    #TODO - this should be admin only, but should it even exist?
    @events = @user.events.all
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render :json => @events }
    end
  end

  def show
    #TODO - is the HTML version even needed?
    @events = @user.events.all
    respond_to do |format|
      format.html
      format.json { render :json => { :user => @user, :event => @events } }
    end
  end

  def update
    req = ActiveSupport::JSON.decode(request.body)
    @event = current_user.events.find_by_id(params[:id])

    if @event.nil?
      render :json => { :errors => ["Event does not exist."] }, :status => 422
    end

    begin
      @event.name = req["event"]["name"] unless req["event"]["name"].nil?
      @event.event_date = req["event"]["event_date"] unless req["event"]["event_date"].nil?
      @event.event_type = req["event"]["event_type"] unless req["event"]["event_type"].nil?
      @event.comment = req["event"]["comment"] unless req["event"]["comment"].nil?

      @event.save!
      render :json => @event
    rescue
      render :json => { :errors => @event.errors.full_messages }, :status => 422
    end
  end


  def create
    #TODO - need to accept only json and return json
    req = ActiveSupport::JSON.decode(request.body)
    @event = current_user.events.build(req["event"])

    begin
      @event.save!
      render :json => @event
    rescue
      render :json => { :errors => @event.errors.full_messages }, :status => 422
    end
  end

  def destroy
    @event = current_user.events.find_by_id(params[:id])

    if @event.nil?
      render :json => { :errors => ["Event does not exist."] }, :status => 422
    end

    begin
      #TODO - delete or destroy?
      @event.destroy
      #TODO - what is the right status?
      render :json => { :status => 200 }
    rescue
      render :json => { :errors => @event.errors.full_messages }, :status => 422
    end
  end

  def search
    #TODO - implement
  end

  def types
    #TODO - Set up the default types that have images. Don't add those values again in the iterator
    @distinct_types = [];
    current_user.events.select("event_type").uniq.each do |event_type|
      @distinct_types << event_type
    end
    render :json => { :types => @distinct_types}
  end

  private
    def load_user
      begin
        @user = User.find(params[:user_id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "User does not exist"} }
          format.json { render :json => { :errors => ["User does not exist"] }, :status => 422 }
        end
      end
    end

    def load_event
      begin
        #TODO - allow an admin to see any event
        @event = current_user.events.find(params[:id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "Event does not exist" } }
          #TODO - is this the right error code?
          format.json { render :json => {:errors => ["Event does not exist"] }, :status => 422 }
        end
      end
    end
end