class EditImportPage < SitePrism::Page
  set_url '/imports{/id}/edit'
  element :title, '#import_title'

  element :submit, 'input[type=submit]'

  def fill_form(title_text)
    title.set(title_text)
    submit.click
  end
end
