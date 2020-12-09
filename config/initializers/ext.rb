Dir.glob(Rails.root.join('lib/ext/**/*.rb')).sort.each do |filename|
  require filename
end
