require 'irb'

class NotificationsController < ApplicationController
  def index
    @context = current_user.permission_id > 1 ? "AM" : "U"
    @notifications = Notification.where(recipient: current_user, context: @context).last(5).reverse
  end

  def mark_as_read
    @notifications = Notification.where(recipient: current_user).unread
    @notifications.update_all(read_at: DateTime.now.strftime('%d %B %Y %I:%M %p'))
    render json: { success: true }
  end
end
