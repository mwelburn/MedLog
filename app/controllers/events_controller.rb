class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user, :only => [:index, :show]
  before_filter :load_event, :only => [:show, :update, :destroy]

  def index
    @events = @user.events.all
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render :json => @events }
    end
  end

  def show
    @events = @user.events.all
    respond_to do |format|
      format.html
      format.json { render :json => { :user => @user, :event => @events } }
    end
  end

  def update
    #TODO - only name should be required, the others can be blanked out provided empty string is provided
    #TODO - do we need to set these all explicitly for json?
    @event.name = params[:name] unless params[:name].nil?
    @event.date = params[:date] unless params[:date].nil?
    @event.comment = params[:comment] unless params[:comment].nil?

    #@event = current_user.problems.build(params[:event])

    begin
      @event.save!
      render :json => @event
    rescue
      render :json => { :errors => @event.errors.full_messages }, :status => 422
    end
  end


  def create
    #TODO - need to accept only json and return json
    @event = current_user.problems.build(params[:event])
  end

  def destroy
    begin
      #TODO - is this the right syntax?
      @event.destroy!
      render :json => @event
    rescue
      render :json => { :errors => @event.errors.full_messages }, :status => 422
    end
  end

  def search

  end

  private
    def load_user
      begin
        @user = User.find(params[:user_id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "User does not exist"} }
          format.json { render :json => { :errors => "User does not exist"}, :status => 422 }
        end
      end
    end

    def load_event
      begin
        #TODO - allow an admin to see any event
        @event = current_user.events.find(params[:id])
      rescue
        response_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "Event does not exist" } }
          #TODO - is this the right error code?
          format.json { render :json => {:errors => "Event does not exist" }, :status => 422 }
        end
      end
    end
end