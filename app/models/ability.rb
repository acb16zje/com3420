require 'irb'

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new

    # Admin
    if user.permission_id == 3
      can :manage, Item
      can :manage, Category
      can :manage, UserHomeCategory
      can :manage, User
      can :manage, Booking, user_id: user.id
      can :update, Booking
      can %i[set_booking_accepted set_booking_rejected set_booking_returned set_booking_cancelled], CombinedBooking
    end

    # Asset Manager
    if user.permission_id == 2
      can %i[edit update], Item, user_id: user.id
      can %i[read create], Item
      can :manage, Booking, user_id: user.id
      can :manage, Category
      can %i[show edit update manager], User, id: user.id
      can :manage, UserHomeCategory
      can %i[set_booking_accepted set_booking_rejected set_booking_returned set_booking_cancelled], CombinedBooking
    end

    # User
    if user.permission_id == 1
      can %i[read manager], Item
      can %i[read new create edit update set_booking_cancelled booking_returned set_booking_returned start_date end_date peripherals], Booking, user_id: user.id
      can %i[show edit update manager], User, id: user.id
      can :filter, Category
      can :manage, UserHomeCategory
      can %i[set_booking_returned set_booking_cancelled], CombinedBooking
    end
  end
end
