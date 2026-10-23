describe "Companies" do
  scenario "User creates a company in an overlay", js: true do
    visit companies_path
    click_link 'New company'

    within('up-modal') do
      fill_in 'company[name]', with: 'Test Company Inc.'
      fill_in 'company[address]', with: "Main Street 1\n12345 Testville"
      click_button 'Save'
    end

    expect(page).to have_no_css('up-modal')
    expect(page).to have_css('#companies', text: 'Test Company Inc.')
  end
end
