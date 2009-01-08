module ApplicationHelper

  def date_time_display(time)
    TZInfo::Timezone.get("UTC").utc_to_local(time).strftime('%m/%d/%Y %I:%M %p')
  end

  def date_display(time)
    TZInfo::Timezone.get("UTC").utc_to_local(time).strftime('%m/%d/%Y')
  end

  def time_display(time)
    TZInfo::Timezone.get("UTC").utc_to_local(time).strftime('%I:%M %p')
  end

end
