# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def ie6_message
    "
    <!--[if lt IE 7]>
    <div style='border: 1px solid #F7941D; background: #FEEFDA; text-align: center; clear: both; height: 75px; position: relative;'>
      <div style='position: absolute; right: 3px; top: 3px; font-family: courier new; font-weight: bold;'><a href='#' onclick='javascript:this.parentNode.parentNode.style.display=\"none\"; return false;'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-cornerx.jpg' style='border: none;' alt='Close this notice'/></a></div>
      <div style='width: 640px; margin: 0 auto; text-align: left; padding: 0; overflow: hidden; color: black;'>
        <div style='width: 75px; float: left;'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-warning.jpg' alt='Warning!'/></div>
        <div style='width: 275px; float: left; font-family: Arial, sans-serif;'>
          <div style='font-size: 14px; font-weight: bold; margin-top: 12px;'>You are using an outdated browser</div>
          <div style='font-size: 12px; margin-top: 6px; line-height: 12px;'>For a better experience using this site, please upgrade to a modern web browser.</div>
        </div>
        <div style='width: 75px; float: left;'><a href='http://www.firefox.com' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-firefox.jpg' style='border: none;' alt='Get Firefox 3.5'/></a></div>
        <div style='width: 75px; float: left;'><a href='http://www.browserforthebetter.com/download.html' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-ie8.jpg' style='border: none;' alt='Get Internet Explorer 8'/></a></div>
        <div style='width: 73px; float: left;'><a href='http://www.apple.com/safari/download/' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-safari.jpg' style='border: none;' alt='Get Safari 4'/></a></div>
        <div style='float: left;'><a href='http://www.google.com/chrome' target='_blank'><img src='http://www.ie6nomore.com/files/theme/ie6nomore-chrome.jpg' style='border: none;' alt='Get Google Chrome'/></a></div>
      </div>
    </div>
    <![endif]-->
    "
  end

  def third_party
    if RAILS_ENV == "production"
      google_analytics
    else
      nil
    end

  end

  def google_analytics
    "
    <script type=\"text/javascript\">
      var gaJsHost = ((\"https:\" == document.location.protocol) ? \"https://ssl.\" : \"http://www.\");
      document.write(unescape(\"%3Cscript src='\" + gaJsHost + \"google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E\"));
    </script>
    <script type=\"text/javascript\">
    try {
      var pageTracker = _gat._getTracker(\"UA-10332489-1\");
      pageTracker._setDomainName(\".moluko.com\");
      pageTracker._trackPageview();
    } catch(err) {}
    </script>
    "
  end

  def uservoice
    "
    <script type=\"text/javascript\">
      var uservoiceJsHost = (\"https:\" == document.location.protocol) ? \"https://uservoice.com\" : \"http://cdn.uservoice.com\";
      document.write(unescape(\"%3Cscript src='\" + uservoiceJsHost + \"/javascripts/widgets/tab.js' type='text/javascript'%3E%3C/script%3E\"))
    </script>
    <script type=\"text/javascript\">
      UserVoice.Tab.show({
        /* required */
        key: 'moluko',
        host: 'moluko.uservoice.com',
        forum: '29907',
        /* optional */
        alignment: 'left',
        background_color:'#ea8808',
        text_color: 'white',
        hover_color: '#06C',
        lang: 'en'
        })
    </script>
    "
  end

  def price_format(price)
    number_to_currency price, :unit => ""
  end
end
