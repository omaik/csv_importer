# frozen_string_literal: true

class ViewImportPage < SitePrism::Page
  set_url '/imports{/id}'

  element :start_button, :xpath, "//a[.='Start']"
  element :edit_button, :xpath, "//a[.='Edit']"
  element :delete_button, :xpath, "//a[.='Delete']"

  def delete_import
    delete_button.click
    accept_confirm
  end
end
