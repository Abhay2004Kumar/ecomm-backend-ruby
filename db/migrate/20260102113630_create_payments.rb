class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.string :stripe_payment_intent_id
      t.decimal :amount
      t.string :status

      t.timestamps
    end
  end
end
