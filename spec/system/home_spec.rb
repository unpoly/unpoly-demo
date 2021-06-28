describe "Home page" do
  scenario "User opens the home page and sees instructions", js: true do
    visit root_path
    expect(page).to have_text("Unpoly Demo")
    expect(page).to have_text("Click on everything!")
  end
end
