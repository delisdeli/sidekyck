module ApplicationHelper

  def capitalize_first string
    string.slice(0,1).capitalize + string.slice(1..-1)
  end

end
