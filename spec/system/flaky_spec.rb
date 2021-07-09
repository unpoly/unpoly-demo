describe 'flaky' do

  scenario 'flaky', js: true do
    visit root_path

    puts evaluate_script('document.readyState')
    puts evaluate_script('getComputedStyle(document.body).backgroundColor')

    # expect(page).to have_css('.msg', text: 'new text', wait: 5)

    div = find('.msg')
    puts "Found .msg!"
    expect(div).to have_text('new text', wait: 6)
    puts "Spec done"

    # 1000.times do
    #   execute_script('console.error("interruption from test")')
    # end
    #
    # page.driver.browser.manage.logs.get(:browser).each do |msg|
    #   puts "BROWSER CONSOLE: #{msg}"
    # end

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
