describe "Tasks" do
  scenario "User adds a task", js: true do
    visit tasks_path

    within('.task-form') do
      fill_in 'task[text]', with: 'Test the task list'
      click_button 'Save'
    end

    # Ignore the optimistic preview and wait for the server-rendered task
    expect(page).to have_css('.task-item:not(.-previewing)', text: 'Test the task list')
  end
end
