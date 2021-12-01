class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def home
  end

  def slow_image
    sleep 2
    send_file Rails.root.join('public', 'apple-touch-icon.png').to_s, content_type: 'image/png', disposition: 'inline'
    # redirect_to "/apple-touch-icon.png?rnd=#{rand}"
  end

  def slow_font
    sleep 10
    send_file Rails.root.join('public', 'Jomhuria-Regular.ttf').to_s, content_type: 'font/ttf', disposition: 'inline'
    # redirect_to "/Jomhuria-Regular.ttf?rnd=#{rand}"
  end

  def slow_script
    sleep 2
    render body: <<~JS, content_type: 'text/javascript'
      console.log("hello from slow script 1")
      var scriptTag = document.createElement("script")
      scriptTag.src = '/slow_script2.js'
      document.body.appendChild(scriptTag)
    JS
  end

  def slow_script2
    sleep 2
    render body: <<~JS, content_type: 'text/javascript'
      console.log("hello from slow script 2")
      var scriptTag = document.createElement("script")
      scriptTag.src = '/slow_script3.js'
      document.body.appendChild(scriptTag)
    JS
  end

  def slow_script3
    sleep 2
    render body: <<~JS, content_type: 'text/javascript'
      console.log("hello from slow script 3")
      var styleLinkTag = document.createElement("link")
      styleLinkTag.rel = 'stylesheet'
      styleLinkTag.media = 'all'
      styleLinkTag.href = '/slow_style.css'
      document.body.appendChild(styleLinkTag)
    JS

    # render body: 'console.log("hello from script 2"); document.body.style.backgroundImage = "url(/slow_image.png)"', content_type: 'text/javascript'
  end

  def slow_script4
    sleep 2
    render body: <<~JS, content_type: 'text/javascript'
      console.log("hello from slow script 4")
      setTimeout(function() { console.log("one task after slow script 4") })

      document.addEventListener('DOMContentLoaded', () => console.log("DOMContentLoaded from slow script 4"))
    JS
  end

  def slow_script5
    sleep 6
    render body: <<~JS, content_type: 'text/javascript'
      console.log("hello from slow script 5")

      document.addEventListener('DOMContentLoaded', () => console.log("DOMContentLoaded from slow script 5"))
    JS
  end

  def fast_script
    render body: <<~JS, content_type: 'text/javascript'
      console.log("hello from fast script")
    JS
  end

  def slow_style
    sleep 2
    render body: <<~CSS, content_type: 'text/css'
      body {
        font-weight: bold !important;
        background-color: yellow !important;
        background-image: url(/slow_image.png);
      }
    CSS
  end


end
