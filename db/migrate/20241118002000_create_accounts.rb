class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :subscription_status, default: "trialing", null: false
      t.string :stripe_customer_id
      t.jsonb  :settings, default: {}

      t.timestamps
    end

    add_index :accounts, :slug, unique: true
  end
end
