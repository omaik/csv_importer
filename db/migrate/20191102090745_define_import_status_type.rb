class DefineImportStatusType < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE import_status AS ENUM ('created', 'pending', 'started', 'completed');
    SQL
  end

  def down
    execute <<-SQL
      DROP TYPE import_status;
    SQL
  end
end
