# frozen_string_literal: true

class ViewImportPage < SitePrism::Page
  set_url '/imports{/id}'

  element :start_button, :xpath, "//a[.='Start']"
  element :edit_button, :xpath, "//a[.='Edit']"
  element :delete_button, :xpath, "//a[.='Delete']"
end
