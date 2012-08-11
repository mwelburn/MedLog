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
          response.should be_success
          body = JSON.parse(response.body)
          body.should include('errors')
          errors = body['errors']
          errors.should have(1).items
          #TODO - keep testing
          pending
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
          response.should have_selector('title', :content => "All events")
        end

        it "should have an element for each user's event" do
          get :show, :user_id => @user
          @user.events.each do |event|
            response.should have_selector('li', :content => event.name)
          end
        end

        #this test requires the event's not have the same name
        it "should not contain other user's events" do
          get :show, :user_id => @user
          @other_user.events.each do |event|
            response.should_not have_selector('li', :content => event.name)
          end
        end

        #TODO - find a pagination gem that works in 3.1
        it "should respond to scrolling down the page" do
          pending
      #      get :show, :user_id => @user
      #      response.should have_selector('div.pagination')
      #      response.should have_selector('span.disabled', :content => "Previous")
      #      response.should have_selector('a', :href => "/events?page=2",
      #                                         :content => "2")
      #      response.should have_selector('a', :href => "/events?page=2",
      #                                         :content => "Next")
        end

        it "should have delete links" do
          get :show, :user_id => @user
          @user.events.each do |event|
            response.should have_selector('a', :href => event_path(event),
                                               :content => "delete")
          end
        end

        it "should have a link to create a new event" do
          get :show, :user_id => @user
          response.should have_selector('a', :href => new_event_path,
                                             :content => "New Event?")
        end
      end

      describe "failure" do

        it "should display an error page" do
          pending
        end
      end
    end
  end
end