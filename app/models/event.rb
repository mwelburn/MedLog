class Event < ActiveRecord::Base
  before_save :default_values

  belongs_to :user

  attr_accessible :name, :eventDate, :eventType, :comment

  validates :user_id, :presence => true
  validates :name, :presence => true
  validates :eventDate, :presence => true

  default_scope :order => '"events"."eventDate" DESC, "events"."created_at" DESC'

  def as_json(options={})
    super(:only => [:id, :name, :eventDate, :eventType, :comment, :user_id])
  end

  private
    def default_values
      self.eventDate ||= Date.today
    end
end
