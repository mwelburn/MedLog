require 'spec_helper'

describe UsersController do
  render_views

  describe "access control" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event, :user => @user)
    end

    it "should deny access to 'show'" do
      get :show, :id => @event, :user_id => @user
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = FactoryGirl.create(:user)
        test_sign_in(invalid_user)
      end

      describe "html" do

        it "should deny access" do
          get :show, :id => @user, :format => :html
          response.should redirect_to(error_path)
        end
      end

      describe "json" do

        it "should deny access" do
          get :show, :id => @user, :format => :json
          response.should_not be_success
          expected_body = { "errors" => [ "User does not exist" ] }
          JSON.parse(response.body).should == expected_body
        end
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)

        30.times do
          FactoryGirl.create(:event, :user => @user)
        end

        @other_user = FactoryGirl.create(:user)
        @other_event = FactoryGirl.create(:event, :user => @other_user, :name => "Other event")
      end

      describe "success" do

        it "should have the right title" do
          get :show, :user_id => @user
          response.should have_selector('title', :content => "My Events")
        end

        it "should have an element for each user's event" do
          get :show, :user_id => @user
          pending
        end

        #this test requires the event's not have the same name
        it "should not contain other user's events" do
          get :show, :user_id => @user
          pending
        end

        it "should respond to  infinity scrolling" do
          get :show, :user_id => @user
          pending
        end

        it "should have delete links" do
          get :show, :user_id => @user
          pending
        end

        it "should have edit links" do
          get :show, :user_id => @user
          pending
        end

        it "should have a link to create a new event" do
          get :show, :user_id => @user
          response.should have_selector('a', :href => new_event_path,
                                             :content => "New Event?")
        end

        it "should show a picture of the type of event" do
          get :show, :user_id => @user
          pending
        end
      end

      describe "failure" do

        it "should not allow access to another user" do
          get :show, :user_id => @other_user
          pending
        end

        it "should redirect to an error page" do
          get :show, :user_id => @other_user
          pending
        end
      end
    end
  end
end