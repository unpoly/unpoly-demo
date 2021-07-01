describe 'flaky' do

  scenario 'flaky', js: true do
    visit root_path

    1000.times do
      execute_script('console.error("interruption from test")')
    end

    page.driver.browser.manage.logs.get(:browser).each do |msg|
      puts "BROWSER CONSOLE: #{msg}"
    end

    # puts "==================="
    #
    # page.find('h2').click
    # page.driver.browser.manage.logs.get(:browser).each do |msg|
    #   puts "BROWSER CONSOLE: #{msg}"
    # end
    #
    # puts "---"
    #
    # click_link 'Projects'
    # # puts page.current_url
    # #    puts evaluate_script('document.readyState')
    #
    # puts page.has_css?('h2', text: 'All projects')
    # puts page.current_url
    #
    # expect(page).to have_content('quarxel')
    #
    # expect(true).to eq(true)
  end

end