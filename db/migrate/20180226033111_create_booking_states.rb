class CreateBookingStates < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_states do |t|
      t.string :process_state

      t.timestamps
    end
  end
end
