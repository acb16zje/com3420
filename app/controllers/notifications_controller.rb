require 'irb'

class NotificationsController < ApplicationController
  def index
    if current_user.permission_id == 1
      @notifications = Notification.where(recipient: current_user, context: 'U').last(5).reverse
    else
      @notifications = Notification.where(recipient: current_user).last(5).reverse
    end
  end

  def mark_as_read
    @notifications = Notification.where(recipient: current_user).unread
    @notifications.update_all(read_at: DateTime.now.strftime("%d %B %Y") + ' ' + DateTime.now.strftime("%I:%M %p"))
    render json: { success: true }
  end
end
