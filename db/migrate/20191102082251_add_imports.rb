class AddImports < ActiveRecord::Migration[6.0]
  def change
    create_table :imports do |t|
      t.string :title
      t.integer :processed
      t.integer :errors_count
      t.integer :total_count
      t.timestamp :started_at
      t.timestamp :completed_at
      t.timestamps
    end

    add_index :imports, :completed_at
  end
end
