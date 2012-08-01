class Event < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :date, :comment

  validates :user_id, :presence

  default_scope :order => '"events"."date" DESC, "events"."name" ASC'

  def as_json(options={})
    super(:only => [:id, :name, :date, :comment, :user_id])
  end
end
