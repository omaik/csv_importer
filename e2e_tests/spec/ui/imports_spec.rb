# frozen_string_literal: true

require 'spec_helper'

describe 'crud operations on pages' do
  let(:imports_page) { ImportsPage.new }
  let(:new_import_page) { NewImportPage.new }
  let(:edit_import_page) { EditImportPage.new }
  let(:import_attributes) { FactoryBot.attributes_for(:import) }

  let(:new_title) { "TitleNew#{Time.now.to_i}" }

  it 'performs CRUD operations on import' do
    imports_page.load
    expect(imports_page).to be_displayed

    imports_page.new_import_button.click
    expect(new_import_page).to be_displayed

    new_import_page.fill_form(import_attributes)
    expect(imports_page).to be_displayed

    created_row = imports_page.find_created_import_row(
      import_attributes[:title]
    )
    imports_page.edit_row(created_row)
    expect(edit_import_page).to be_displayed

    edit_import_page.fill_form(new_title)
    expect(imports_page).to be_displayed

    updated_row = imports_page.find_created_import_row(new_title)
    expect(updated_row).to be_present

    imports_page.delete_row(updated_row)

    expect { imports_page.find_created_import_row(new_title) }
      .to raise_error(Capybara::ElementNotFound)
  end

  it 'runs import' do
    imports_page.load
    expect(imports_page).to be_displayed

    imports_page.new_import_button.click
    expect(new_import_page).to be_displayed

    new_import_page.fill_form(import_attributes)
    expect(imports_page).to be_displayed

    created_row = imports_page.find_created_import_row(
      import_attributes[:title]
    )
    imports_page.start(created_row)

    completed_row = Timeout.timeout(Capybara.default_max_wait_time) do
      loop do
        page.evaluate_script('window.location.reload()')
        break imports_page.find_completed_import_row(import_attributes[:title])
      rescue Capybara::ElementNotFound
        puts 'Element not found, retrying'
      end
    end

    expect(completed_row).to be_present

    imports_page.delete_row(completed_row)
  end
end
