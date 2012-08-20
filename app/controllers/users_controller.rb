class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user, :only => [:show]

  #TODO - only an admin should be able to leverage this method
#  def index
#    @title = "All Users"
#    @users = User.all
#  end

  def show
    #TODO - only admin should be access people besides themselves
    @events = @user.events.all
    respond_to do |format|
      format.html
      format.json { render :json => { :user => @user } }
    end
  end

  private
    def load_user
      begin
        @user = User.find(params[:id])

        #TODO - only an admin should be able to look at other people
        if !current_user?(@user)
          respond_to do |format|
            format.html { redirect_to error_path, :flash => { :failure => "No access to this user" } }
            #TODO - right error code?
            format.json { render :json => {:errors => ["No access to this user"] }, :status => 422 }
          end
        end
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "User does not exist" } }
          #TODO - is this the right error code?
          format.json { render :json => {:errors => ["User does not exist"] }, :status => 422 }
        end
      end
    end
end