module ListingsHelper

  def format_time datetime
    datetime.strftime("%A %m/%e/%y @ %I:%M %p")
  end

end
