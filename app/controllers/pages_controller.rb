class PagesController < ApplicationController
  def home
  end

  def slow_image
    sleep 5
    redirect_to "/apple-touch-icon.png?rnd=#{rand}"
  end

  def slow_font
    sleep 5
    redirect_to "/Jomhuria-Regular.ttf?rnd=#{rand}"
  end

end
