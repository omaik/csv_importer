class NewImportPage < SitePrism::Page
  set_url '/imports/new'

  element :title, '#import_title'
  element :file, '#import_file'

  element :submit, 'input[type=submit]'

  def fill_form(import_attributes)
    title.set(import_attributes[:title])
    file.attach_file(import_attributes[:file])
    submit.click
  end
end
