class Event < ActiveRecord::Base
  before_save :default_values

  belongs_to :user

  attr_accessible :name, :event_date, :event_type, :comment

  validates :user_id, :presence => true
  validates :event_type, :presence => true
  validates :name, :presence => true
  validates :event_date, :presence => true

  def as_json(options={})
    super(:only => [:id, :name, :event_date, :event_type, :comment, :user_id])
  end

  private
    def default_values
      self.event_date ||= Date.today
    end
end
