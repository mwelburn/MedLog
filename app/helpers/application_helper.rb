module ApplicationHelper
  def title
    base_title = "MedLog"
    if @title.nil?
      "#{base_title} | The simplest way to keep track of your medical events"
    else
      "#{base_title} | #{@title}"
    end
  end
end
