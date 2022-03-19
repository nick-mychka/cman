class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :password_digest, null: false, default: ""
      t.string :nickname

      t.timestamps
    end
  end
end
