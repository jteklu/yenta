class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :match_id
      t.string :state, default: "pending"
      t.datetime :matched_at

      t.timestamps
    end
  end
end
