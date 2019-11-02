class AddCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.date :date_of_birth
      t.references :import

      t.timestamps
    end

    add_index :customers, :email, unique: true
  end
end
