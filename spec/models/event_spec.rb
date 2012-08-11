require 'spec_helper'

describe Event do

  before(:each) do
    #since we are testing finger creation, users will not create fingers
    @user = FactoryGirl.create(:user)
    @attr = {
      :name => "Flu Shot",
      :date => Date.today,
      :comment => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    event = @user.events.new(@attr)
    event.name = "Flu Shot"
    event.date = Date.today
    event.comment = ""
    event.save!
  end

  describe "user associations" do

    before(:each) do
      @event = create(:event, :user => @user)
    end

    it "should have a user attribute" do
      @event.should respond_to(:user)
    end

    it "should have the right associated event" do
      @event.user_id.should == @user.id
      @event.user.should == @user
    end
  end

  describe "validation" do

    it "should require a user id" do
      event = Event.new(@attr)
      event.should_not be_valid
    end

    it "should allow a blank comment" do
      event = @user.events.build(@attr.merge({ :comment => "" }))
      event.should be_valid
    end

    it "should require a name" do
      event = @user.events.build(@attr)
      event.name = ""
      event.should_not be_valid
    end

    it "should require a date" do
      event = @user.events.create(@attr)
      event.date = ""
      event.should_not be_valid
    end
  end

  describe "order" do

    before(:each) do
      @event1 = FactoryGirl.create(:event, :user => @user, :created_at => 1.day.ago)
      @event2 = FactoryGirl.create(:event, :user => @user, :created_at => 1.minute.ago)
      @event3 = FactoryGirl.create(:event, :user => @user, :created_at => 1.hour.ago)
    end

    it "should return the newest first" do
      Event.all.should == [@event2, @event3, @event1]
    end
  end
end
