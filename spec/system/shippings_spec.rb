describe "Shipping" do
  scenario "User changes the destination and sees an updated estimate", js: true do
    visit new_shipping_path
    expect(page).to have_css('#estimate', text: 'Europe')

    choose 'Asia'
    choose 'Japan'

    expect(page).to have_css('#estimate', text: 'World')
  end
end
