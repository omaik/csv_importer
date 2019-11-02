# frozen_string_literal: true

class AddStatusToImports < ActiveRecord::Migration[6.0]
  def change
    add_column :imports, :status, :import_status, default: 'created'
    add_index :imports, :status
  end
end
