up.compiler('.tag-picker', function(element) {
  let tomSelect = new TomSelect(element, {
    maxItems: 5,
    refreshThrottle: 10,
    onItemAdd(_value, _$item) {
      tomSelect.setTextboxValue('');
      tomSelect.refreshOptions();
    },
    plugins: {
      remove_button: {
        title:'Remove tag',
      }
    },
  })
  return () => tomSelect.destroy()
})
