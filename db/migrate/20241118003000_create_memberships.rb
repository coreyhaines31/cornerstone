class CreateMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :memberships, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.references :user, foreign_key: true, type: :uuid
      t.references :invited_by, foreign_key: { to_table: :users }, type: :uuid

      t.string :email, null: false
      t.string :role, null: false, default: "member"
      t.datetime :accepted_at

      t.timestamps
    end

    add_index :memberships, [:user_id, :account_id], unique: true, where: "user_id IS NOT NULL"
  end
end
