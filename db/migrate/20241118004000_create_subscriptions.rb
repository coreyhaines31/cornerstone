class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :stripe_price_id
      t.string :status, default: "trialing", null: false
      t.datetime :current_period_end

      t.timestamps
    end
  end
end
