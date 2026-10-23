describe "Notes" do
  scenario "User edits a note", js: true do
    visit notes_path
    within('.panes-side') { first('.note-item a').click }
    click_link 'Edit'

    fill_in 'note[title]', with: 'Updated note title'
    click_button 'Save'

    expect(page).to have_css('.panes-content h2', text: 'Updated note title')
    expect(page).to have_css('.panes-side', text: 'Updated note title')
  end
end
