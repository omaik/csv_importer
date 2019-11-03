class ImportsPage < SitePrism::Page
  set_url '/imports'

  element :new_import_button, '#new_import'

  element :created_table, '#created-imports'
  element :completed_table, '#completed-imports'

  def edit_row(row)
    row.find(:xpath, "td/a[.='Edit']").click
  end

  def delete_row(row)
    row.find(:xpath, "td/a[.='Delete']").click
    accept_confirm
  end

  def start(row)
    row.find(:xpath, "td/a[.='Start']").click
  end

  def find_created_import_row(text)
    created_table.find(:xpath, "tbody/tr[child::td[.='#{text}']]")
  end

  def find_completed_import_row(text)
    completed_table.find(:xpath, "tbody/tr[child::td[.='#{text}']]")
  end
end
