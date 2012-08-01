module ApplicationHelper
  def title
    base_title = "Medical Tracker"
    if @title.nil?
      "#{base_title} | Keep track of vaccinations
    else
      "#{base_title} | #{@title}"
    end
  end
end
