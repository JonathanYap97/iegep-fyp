module NotificationHelper
  def alert
    content = ''
    flash.each do |key, value|
      content << "<div class='alert alert-#{key}'>#{value}</div>"
    end
    content.html_safe
  end
end
