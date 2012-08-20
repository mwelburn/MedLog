require 'spec_helper'

describe EventsController do
  render_views

  describe "access control" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event, :user => @user)
    end

    it "should deny access to 'index'" do
      get :index, :user_id => @user
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'create'" do
      post :create, :user_id => @user
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => @event, :user_id => @user
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'show'" do
      get :show, :id => @event, :user_id => @user
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'update'" do
      put :update, :id => @event, :user_id => @user, :event => { :name => "Updated Name" }
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
      @other_user = FactoryGirl.create(:user)
    end

    it "should redirect to user" do
      get :index, :user_id => @user
      response.should redirect_to(@user)
    end

    describe "failure" do

      it "should fail to access another user's events" do
        get :index, :user_id => @other_user
        response.should_not be_success
      end

      it "should redirect to an error page" do
        get :index, :user_id => @other_user
        response.should redirect_to(error_path)
      end
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
    end

    describe "success" do

      before(:each) do
        @attr = {
          :name => "Test Name",
          :event_date => Time.now,
          :event_type => "Test Type",
          :comment => "Test Comment"
        }
      end

      it "should create an event" do
        lambda do
          post :create, :user_id => @user, :event => @attr
        end.should change(Event, :count).by(1)
      end

      it "should have a flash message" do
        post :create, :user_id => @user, :event => @attr
        flash[:success].should =~ /event created/i
      end
    end

    describe "failure" do

      before(:each) do
        @attr = {
          :name => ""
        }
      end

      it "should not create a event" do
        lambda do
          post :create, :user_id => @user, :event => @attr
        end.should_not change(Event, :count)
      end

      it "should have a flash message" do
        post :create, :user_id => @user, :event => @attr
        flash[:success].should =~ /event failed/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = FactoryGirl.create(:user)
        @event = FactoryGirl.create(:event, :user => @user)
        invalid_user = FactoryGirl.create(:user)
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        delete :destroy, :id => @event, :user_id => @user
        response.should redirect_to(error_path)
      end

      it "should not destroy the event" do
        lambda do
          delete :destroy, :id => @event, :user_id => @user
        end.should_not change(Event, :count)
      end

      it "should have a flash message" do
        delete :destroy, :id => @event, :user_id => @user
        flash[:failure].should =~ /event does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        @event = FactoryGirl.create(:event, :user => @user)
      end

      it "should destroy the event" do
        lambda do
          delete :destroy, :id => @event, :user_id => @user
        end.should change(Event, :count).by(-1)
      end

      describe "failure" do

        it "should have a flash message" do
          pending
          #TODO - how do I make it fail with a legit event ID
          #delete :destroy, :id => @event, :user_id => @user
          #flash[:failure].should =~ /error deleting event/i
        end

        it "should not remove item from page" do
          pending
        end
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event, :user => @user)
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = FactoryGirl.create(:user)
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        get :show, :id => @event, :user_id => @user
        response.should redirect_to(error_path)
      end

      it "should have a flash message" do
        get :show, :id => @event, :user_id => @user
        flash[:failure].should =~ /event does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should be successful" do
          get :show, :id => @event
          response.should be_success
        end

        it "should find the right event" do
          get :show, :id => @event, :user_id => @user
          assigns(:event).should == @event
        end

        it "should have the right title" do
          get :show, :id => @event, :user_id => @user
          response.should have_selector("title", :content => @event.name)
        end

        it "should have a link to edit" do
          get :show, :id => @event, :user_id => @user
          response.should have_selector("a", :content => "Edit Event")
        end

        it "should have the event's name'" do
          get :show, :id => @event, :user_id => @user
          response.should have_selector("h1", :content => @event.name)
        end

        it "should include the event's comment" do
          get :show, :id => @event, :user_id => @user
          response.should have_selector("span", :content => @event.comment)
        end

        it "should include the event's date" do
          get :show, :id => @event, :user_id => @user
          response.should have_selector("span", :content => @event.date)
        end
      end

      describe "failure" do

        pending
      end
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event, :user => @user)
      @attr = {
          :name => "Updated Name",
          :event_date => Time.now,
          :event_type => "Updated Type",
          :comment => "Updated comment"
      }
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = FactoryGirl.create(:user)
        test_sign_in(invalid_user)
      end

      it "should not edit the event" do
        put :update, :id => @event, :user_id => @user, :event => @attr
        @event.reload
        @event.name.should_not == @attr[:name]
        @event.event_date.should_not == @attr[:event_date]
        @event.event_type.should_not == @attr[:event_type]
        @event.comment.should_not == @attr[:comment]
      end

      it "should have a flash message" do
        put :update, :id => @event, :user_id => @user, :event => @attr
        flash[:failure].should =~ /event does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should change the event's attributes" do
          put :update, :id => @event, :user_id => @user, :event => @attr
          @event.reload
          @event.name.should == @attr[:name]
          @event.event_date.should == @attr[:event_date]
          @event.event_type.should == @attr[:event_type]
          @event.comment.should == @attr[:comment]
        end

        it "should have a flash message" do
          put :update, :id => @event, :user_id => @user, :event => @attr
          flash[:success].should =~ /event updated/i
        end

        it "should only update attributes that are part of the request" do
          pending
        end
      end

      describe "failure" do

        before(:each) do
          @bad_attr = {
              :name => "",
              :event_date => Time.now,
              :event_type => "",
              :comment => ""
          }
        end

        it "should have a flash message" do
          put :update, :id => @event, :user_id => @user, :event => @bad_attr
          flash[:failure].should =~ /error updating event/i
        end

        it "should not edit the event" do
          put :update, :id => @event, :user_id => @user, :event => @bad_attr
          @event.reload
          @event.name.should_not == @bad_attr[:name]
          @event.event_date.should_not == @bad_attr[:event_date]
          @event.event_type.should_not == @bad_attr[:event_type]
          @event.comment.should_not == @bad_attr[:comment]
        end

        it "should respond with an error message" do
          put :update, :id => @event, :user_id => @user, :event => @bad_attr
          pending
        end
      end
    end
  end
end