describe "Projects" do
  scenario "User creates a project in an overlay", js: true do
    visit projects_path
    click_link 'New project'

    within('up-modal') do
      fill_in 'project[name]', with: 'Test Project'
      find('#company-field').all('option')[1].select_option
      fill_in 'project[budget]', with: '5000'
      click_button 'Save'
    end

    expect(page).to have_no_css('up-modal')
    expect(page).to have_css('#projects', text: 'Test Project')
  end
end
