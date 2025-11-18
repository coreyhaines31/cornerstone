class CreateAuditEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_events, id: :uuid do |t|
      t.references :account, type: :uuid, foreign_key: true
      t.references :user, type: :uuid, foreign_key: true
      t.string :auditable_type
      t.uuid :auditable_id
      t.string :action, null: false
      t.jsonb :metadata, default: {}
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    add_index :audit_events, [:auditable_type, :auditable_id]
  end
end
