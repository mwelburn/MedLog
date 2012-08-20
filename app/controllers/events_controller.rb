class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user, :only => [:index, :show]
  before_filter :load_event, :only => [:show, :update, :destroy]

  def index
    #TODO - only can see other people's events if they give access
    if !current_user?(@user)
      respond_to do |format|
        format.html { redirect_to error_path, :flash => { :failure => "No permission to view this user's events"} }
        format.json { render :json => { :errors => ["No permission to view this user's events"] }, :status => 422 }
      end
    else
      @events = @user.events.all
      respond_to do |format|
        format.html { redirect_to @user }
        format.json { render :json => @events }
      end
    end
  end

  def show
    #TODO - only can see other people's events if they give access
    if !current_user?(@user)
      render :json => { :errors => ["No permission to view this event"] }, :status => 422
    end

    if @event.nil?
      render :json => { :errors => ["Event does not exist."] }, :status => 422
    end

    respond_to do |format|
      #TODO - is the HTML version even needed?
      #format.html
      format.json { render :json => { :user => @user, :event => @events } }
    end
  end

  def update
    if !current_user?(@user)
      render :json => { :errors => ["No permission to update this event"] }, :status => 422
    end

    @event = @user.events.find_by_id(params[:id])

    if @event.nil?
      render :json => { :errors => ["Event does not exist"] }, :status => 422
    end

    req = ActiveSupport::JSON.decode(request.body)

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
    if !current_user?(@user)
      render :json => { :errors => ["No permission to create this user's events"] }, :status => 422
    end

    req = ActiveSupport::JSON.decode(request.body)
    @event = @user.events.build(req["event"])

    begin
      @event.save!
      render :json => @event
    rescue
      render :json => { :errors => @event.errors.full_messages }, :status => 422
    end
  end

  def destroy
    if !current_user?(@user)
      render :json => { :errors => ["No permission to delete this event"] }, :status => 422
    end

    @event = @user.events.find_by_id(params[:id])

    if @event.nil?
      render :json => { :errors => ["Event does not exist"] }, :status => 422
    end

    begin
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
        #TODO - allow an admin to see any user
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
        @event = @user.events.find(params[:id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "Event does not exist" } }
          #TODO - is this the right error code?
          format.json { render :json => {:errors => ["Event does not exist"] }, :status => 422 }
        end
      end
    end

    def can_see_event?(user)
      #TODO - sharing rules
      !current_user?(@user)
    end

    def can_see_user?(user)
      #TODO - sharing rules
      !current_user?(@user)
    end
end