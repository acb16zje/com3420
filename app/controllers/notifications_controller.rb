require 'irb'

class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(recipient: current_user).last(5).reverse
  end

  def mark_as_read
    @notifications = Notification.where(recipient: current_user).unread
    @notifications.update_all(read_at: DateTime.now.strftime("%d %B %Y") + ' ' + DateTime.now.strftime("%I:%M %p"))
    render json: { success: true }
  end
end
