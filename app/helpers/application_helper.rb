module ApplicationHelper

  def date_time_display(time)
    TZInfo::Timezone.get("UTC").utc_to_local(time).strftime('%m/%d/%Y %I:%M %p')
  end

  def activity_description(activity)
    state = case activity.message
      when /must be received/
        "Submitted"
      when /Registration form received/
        "Received"
      when /Registration form rejected/
        "Rejected"
      when /Registration form validated/
        "Validated"
    end
    content_tag(:h5, state) + "\n" + content_tag(:p, truncate(activity.message, 80))
  end
end
