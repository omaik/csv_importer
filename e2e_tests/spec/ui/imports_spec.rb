# frozen_string_literal: true

require 'spec_helper'

describe 'crud operations on pages' do
  let(:imports_page) { ImportsPage.new }
  let(:new_import_page) { NewImportPage.new }
  let(:edit_import_page) { EditImportPage.new }
  let(:view_import_page) { ViewImportPage.new }
  let(:import_attributes) { FactoryBot.attributes_for(:import) }

  let(:new_title) { "TitleNew#{Time.now.to_i}" }

  it 'performs CRUD operations on import' do
    imports_page.load
    expect(imports_page).to be_displayed

    imports_page.new_import_button.click
    expect(new_import_page).to be_displayed

    new_import_page.fill_form(import_attributes)
    expect(view_import_page).to be_displayed

    view_import_page.edit_button.click
    expect(edit_import_page).to be_displayed

    edit_import_page.fill_form(new_title)
    expect(view_import_page).to be_displayed
    expect(view_import_page).to have_content(new_title)


    view_import_page.delete_import
    expect(imports_page).to be_displayed
    expect(imports_page).to_not have_content(new_title)
  end

  it 'runs import' do
    imports_page.load
    expect(imports_page).to be_displayed

    imports_page.new_import_button.click
    expect(new_import_page).to be_displayed

    new_import_page.fill_form(import_attributes)
    expect(view_import_page).to be_displayed

    view_import_page.start_button.click

    Timeout.timeout(Capybara.default_max_wait_time) do
      loop do
        page.evaluate_script('window.location.reload()')
        break if view_import_page.has_content?('completed')
      end
    end

    view_import_page.delete_import
  end
end
