#I "bin/Debug"
#r "../packages/HtmlAgilityPack.1.4.3/lib/HtmlAgilityPack.dll"
#load "Text.fs"

open EmailParser.Utils.Text

let stringWithSmartQuotes = "”é£”"
asciify stringWithSmartQuotes

#load "Html.fs"
open EmailParser.Utils.Html
let html = """

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:og="http://opengraph.org/schema/"> <head>
        
<meta property="og:title" content="New York City - StartupDigest - Tally App, CMX Summit, Hack &amp; Tell - June 9th - June 16th"/>
<meta property="fb:page_id" content="43929265776" />        
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width">
    <title></title>
    <style type="text/css">
  body {
    margin: 0;
    padding: 0;
    font-family: 'Times New Roman', Times, serif;
  }

  img{
    border: 0 none;
    height: auto;
    line-height: 100%;
    outline: none;
    text-decoration: none;
  }

  a img {
    border:0 none;
  }

  table, td{
    border-collapse:collapse;
  }

  #body-table {
    height: 100% !important;
    margin: 0;
    padding: 0;
    width: 100% !important;
    font-family: 'Times New Roman', Times, serif;
  }
  
  a {
    color: #0072f1;
    text-decoration: none;
    margin: 0;
    padding: 0;
  }
  
  .cover a {
    font-style: italic;
  }

</style>
          <script type="text/javascript">
            var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
            document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
            </script>
            <script type="text/javascript">
            try {
                var _gaq = _gaq || [];
                _gaq.push(["_setAccount", "UA-329148-88"]);
                _gaq.push(["_setDomainName", ".campaign-archive.com"]);
                _gaq.push(["_trackPageview"]);
                _gaq.push(["_setAllowLinker", true]);
            } catch(err) {console.log(err);}</script>
                    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script> <script src="http://us1.campaign-archive1.com/js/mailchimp/fancyzoom.mc.js"></script>  <script type="text/javascript">
    function incrementFacebookLikeCount() {
        var current = parseInt($('#campaign-fb-like-btn span').html());
        $('#campaign-fb-like-btn span').fadeOut().html(++current).fadeIn();
    }

    function getUrlParams(str) {
        var vars = {}, hash;
        if (!str) return vars;
        var hashes = str.slice(str.indexOf('?') + 1).split('&');
        for(var i = 0; i < hashes.length; i++) {
            hash = hashes[i].split('=');
            vars[hash[0]] = hash[1];
        }
        return vars;
    }
    
    function setupSocialSharingStuffs() {
        var numSocialElems = $('a[rel=socialproxy]').length;
        var numSocialInitialized = 0;
        var urlParams = getUrlParams(window.document.location.href);
        var paramsToCopy = {'e':true, 'eo':true};
        $('a[rel=socialproxy]').each(function() {
            var href = $(this).attr('href');
            var newHref = decodeURIComponent(href.match(/socialproxy=(.*)/)[1]);
            // for facebook insanity to work well, it needs to all be run against just campaign-archive
            newHref = newHref.replace(/campaign-archive(\d)/gi, 'campaign-archive');
            var newHrefParams = getUrlParams(newHref);
            for(var param in urlParams) {
                if ((param in paramsToCopy) && !(param in newHrefParams)) {
                    newHref += '&' + param + '=' + urlParams[param];
                }
            }
            $(this).attr('href', newHref);
            if (href.indexOf('facebook-comment') !== -1) {
                $(this).fancyZoom({"zoom_id": "social-proxy", "width":620, "height":450, "iframe_height": 450});
            } else {
                $(this).fancyZoom({"zoom_id": "social-proxy", "width":500, "height":200, "iframe_height": 500});
            }
            numSocialInitialized++;
                    });
    }
    if (window.top!=window.self){
        $(function() {
          var iframeOffset = $("#archive", window.parent.document).offset();
          $("a").each(function () {
              var link = $(this);
              var href = link.attr("href");
              if (href && href[0] == "#") {
                  var name = href.substring(1);
                  $(this).click(function () {
                      var nameElement = $("[name='" + name + "']");
                      var idElement = $("#" + name);
                      var element = null;
                      if (nameElement.length > 0) {
                          element = nameElement;
                      } else if (idElement.length > 0) {
                          element = idElement;
                      }
         
                      if (element) {
                          var offset = element.offset();
                          var height = element.height();
                          //3 is totally arbitrary, but seems to work best.
                          window.parent.scrollTo(offset.left, (offset.top + iframeOffset.top - (height*3)) );
                      }
         
                      return false;
                  });
              }
          });
        });
    }
</script>  <script type="text/javascript">
            $(document).ready(function() {
                setupSocialSharingStuffs();
            });
        </script> <style type="text/css">
            /* Facebook/Google+ Modals */
            #social-proxy { background:#fff; -webkit-box-shadow: 4px 4px 8px 2px rgba(0,0,0,.2); box-shadow: 4px 4px 8px 2px rgba(0,0,0,.2); padding-bottom:35px; z-index:1000; }
            #social-proxy_close { display:block; position:absolute; top:0; right:0; height:30px; width:32px; background:transparent url(http://cdn-images.mailchimp.com/awesomebar-sprite.png) 0 -200px; text-indent:-9999px; outline:none; font-size:1px; }
            #social-proxy_close:hover { background-position:0 -240px; }
            body { padding-bottom:50px !important; }
        </style> </head>
    
    <body style="background-color: #f4f4f4;">
    <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" style="margin-top: 40px;" id="body-table">
      <tr>
        <td align="center" valign="top">
          <table border="0" cellpadding="0" cellspacing="0" width="600" id="container" style="background-color: #ffffff; border: 1px solid #dbd6d7;">
            <tr>
                <td align="center" valign="top">
                  <table border="0" cellpadding="0" cellspacing="0" width="600" height="75">
  <tr>
    <td style="height: 55px; background-color: #182937;">
      <a href="https://www.startupdigest.com/" style="margin: 0 0 0 20px;">
        <img src="http://startupdigest-production.s3.amazonaws.com/mailchimp/version/4/logo.png" alt="StartupDigest" style="margin-top: 5px;">
      </a>
        <img src="http://startupdigest-production.s3.amazonaws.com/mailchimp/version/4/powered-by.png" alt="StartupDigest" style="margin: 5px 20px 0 0; float: right;">
    </td>
    <td style="height: 55px; background-color: #182937; text-align: right;">
      <!-- "Powered By" logo goes here -->
    </td>
  </tr>
</table>

                  <table border="0" cellpadding="0" cellspacing="0" width="600">
  <tr>
    <td align="left" valign="baseline" style="padding: 30px 0 0 20px;">
      <h1 style="font-family: Tahoma, Geneva, sans-serif; letter-spacing: 1px; font-weight: 900; font-size: 32px; line-height: 1.2em; color: #000000; margin-bottom: 0;">
        New York City
      </h1>
    </td>
    <td align="right" valign="baseline" style="padding: 45px 20px 0 0;">
      <span style="font-family: Tahoma, Geneva, sans-serif; font-weight: 900; font-size: 12px; line-height: 1.2em; color: #000000;">
        June 09, 2014
      </span>
    </td>
  </tr>

  <tr>
    <td colspan="2" style="padding: 0 20px 45px 20px;">
      <hr style="border: none; display: block; height: 2px; background-color: #d7d7d7;">
        <p class="cover" style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: normal; line-height: 26px; margin: 0;">
          <div><div><div><b>Spread The Word:&nbsp;</b>Like the Startup Digest? Share with others <a href="http://ctt.ec/0k7iq" target="_blank" rel="nofollow">here</a><b><br><br>Community Management Summit:&nbsp;</b>Interested in developing your community management strategy? Hear from Scot Heifferment (Meetup), Cindy Au (Kickstarter), Erik Martin (Reddit), Scott Belsky (Behance) and others at the CMX Summit<br><b><br></b></div></div></div><b>Featured Startup:&nbsp;</b><a href="https://itunes.apple.com/us/app/tally-whats-popular-now/id868935366" target="_blank" rel="">Tally</a>. Tally is&nbsp;a new way to share and discover whatever's popular, funny and interesting on the internet. It's like an awesome, endless feed of crowd-sourced content. There's no need to follow anyone, and the community determines what's best:&nbsp;<a href="https://itunes.apple.com/us/app/tally-whats-popular-now/id868935366" target="_blank" rel="">Tally</a><b><br><br>Get In The Digest</b><br>Have events to suggest? Post events to our system at&nbsp;<a href="http://startupweekend.us1.list-manage2.com/track/click?u=92be899ef5a892c60b4a6cd97&amp;id=3b8c2a3e77&amp;e=dfee1fc4a8" target="_blank" rel="">http://startupdigest.com/suggest</a>&nbsp;.&nbsp;<br><br>Want your startup featured? Submit your info here&nbsp;<a href="http://bit.ly/startupsubmit" target="_blank" rel="nofollow">http://bit.ly/startupsubmit</a><br>
        </p>
    </td>
  </tr>
</table>


                    <table border="0" cellpadding="0" cellspacing="0" width="600">
    <tr>
      <td colspan="2" style="padding: 0 20px 0 20px;">
        <h5 style="font-family: Tahoma, Geneva, sans-serif; line-height: 1.2em; color: #000000; font-weight: bold; font-size: 14px; margin: 0 0 12px 0;">
          New York City StartupDigest is curated by:
        </h5>
      </td>
    </tr>
      <tr>
        <td width="65" style="vertical-align: top; padding: 10px 20px 15px 20px;" valign="top">
          <img src="https://s3.amazonaws.com/startupdigest-production/users/avatars/000/066/357/thumbnail/frank_nyc.png?1376429587" alt="Frank Denbow">
        </td>
        <td style="padding: 10px 20px 15px 0;">
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: normal; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
            <b style="color: #000000;">
              Frank Denbow
            </b>
             - StartupJob.me - Get Your Resume Out to 50+ Top Startups: http://startupjob.me
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif, sans-serif; color: #000000; font-size: 14px; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
            Contact Frank Denbow at  <a href="mailto:frank.denbow@thestartupdigest.com" style="font-family: Tahoma, Geneva, sans-serif;">frank.denbow@thestartupdigest.com</a>
          </p>
        </td>
      </tr>
      <tr>
        <td width="65" style="vertical-align: top; padding: 10px 20px 15px 20px;" valign="top">
          <img src="https://s3.amazonaws.com/startupdigest-production/users/avatars/000/088/296/thumbnail/carleen_nyc.jpeg?1395025190" alt="Carleen Pan">
        </td>
        <td style="padding: 10px 20px 15px 0;">
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: normal; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
            <b style="color: #000000;">
              Carleen Pan
            </b>
            
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif, sans-serif; color: #000000; font-size: 14px; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
            Contact Carleen Pan at  <a href="mailto:carleen@thestartupdigest.com" style="font-family: Tahoma, Geneva, sans-serif;">carleen@thestartupdigest.com</a>
          </p>
        </td>
      </tr>
      <tr>
        <td width="65" style="vertical-align: top; padding: 10px 20px 15px 20px;" valign="top">
          <img src="https://s3.amazonaws.com/startupdigest-production/users/avatars/000/066/358/thumbnail/satjot_nyc.jpg?1376433653" alt="Satjot Sawhney">
        </td>
        <td style="padding: 10px 20px 15px 0;">
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: normal; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
            <b style="color: #000000;">
              Satjot Sawhney
            </b>
             - Founder, TapFame.com
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif, sans-serif; color: #000000; font-size: 14px; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
            Contact Satjot Sawhney at  <a href="mailto:satjot@thestartupdigest.com" style="font-family: Tahoma, Geneva, sans-serif;">satjot@thestartupdigest.com</a>
          </p>
        </td>
      </tr>
  </table>

                    <table border="0" cellpadding="0" cellspacing="0" width="600">
    <tr>
      <td style="padding: 0 20px 0 20px">
        <div style="border: 1px solid #cccccc; padding: 20px; margin: 35px 0 50px 0;">
            
<strong> Enjoy an exclusive StartupDigest benefit from our sponsor:</strong>
<table><tbody><tr><td width="130"><a href="http://launchbit.com/taz/9871-5206-40e4668758"><img src="http://launchbit.com/taz-i/5206-rjmetrics-text.jpg"></a></td><td><span style="font-size:14px;"><a href="http://launchbit.com/taz/9871-5206-40e4668758">2014 Benchmark Report</a> Learn the ecommerce metrics that matter. <img src="http://launchbit.com/taz-pixel/9871-5206-40e4668758"></span></td></tr></tbody></table>
<br>
<p><a href="http://www.launchbit.com/sp/16838-10710/">Click here to offer an exclusive benefit to this digest</a></p>
        </div>
      </td>
    </tr>
  </table>

                      <table border="0" cellpadding="0" cellspacing="0" width="600" style="margin: 10px 0 0 0;">
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              MON
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              09
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.eventbrite.com/e/pitch-night-all-things-media-tech-tickets-11795818611" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Pitch Night - All things MEDIA TECH!</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 9th  6:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              Have an idea? Show it off!
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              MON
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              09
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.meetup.com/ctoschool/events/182177662/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">GitHub remote-worker culture and tools (free)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 9th  6:30pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              In the ever-more-competitive market for talented developers and designers, it is a strategic advantage to expand your candidate pool to those far beyond the vicinity of your headquarters. In this talk, I'll share some of the things that have helped GitHub be a successful primarily-remote-worker company
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              Pivotal Labs 625 6th Avenue, 2nd Floor, New York, NY | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              MON
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              09
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.meetup.com/iOSoho/events/176669462/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">iOSoho: Tiling and zooming ASCII Art (Artsy) &amp; Mastering APIs Offline (JOOR)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 9th  7:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              Tiling and zooming is a solved problem on the web with numerous libraries and systems. However, things aren't quite as mature on iOS. In this talk we'll examine the tiling and zooming implementation in ARTiledImageView and take a quick look at how we can practically use this in a range of applications, from indoor and outdoor mapping to, more usefully, spreading our love for ASCII art.<br><br>This talk will describe the challenges faced in supporting 'offline usage' for a media-rich, Wi-Fi-scarce, and data heavy app.&nbsp;&nbsp;&nbsp;
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              MON
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              09
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://wallstreettosiliconalley5.eventbrite.com" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">From Wall Street to Silicon Alley ($12)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 9th  7:30pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              A roundtable discussion with former investment bankers who made the leap into the world of startups
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              Cooley LLP, 1114 Avenue of the Americas, 46th Fl, NY | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              TUE
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              10
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.eventbrite.com/e/engineering-the-customer-experience-roadshow-new-york-tickets-10975982459" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;"> Engineering the Customer Experience Roadshow </a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 10th  1:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              Goal is to help developers and companies engineer great customer experiences in this new software-defined world.
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              TUE
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              10
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.eventbrite.com/e/startup-boost-vc-lawyer-startup-ceo-and-designer-square-table-discussion-tickets-11783407489?aff=es2&amp;rank=2" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Startup Boost: VC, lawyer, startup CEO, and designer square table discussion ($9-$25)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 10th  6:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              EntrepreneurshipEcosystemNYC is pleased to announce a square table discussion. What is a square table discussion? For those of you who have experienced it before, you know. For those of you who have not, join us and find out.

When: June 10, 2014 @ 6pm – 8:30pm
What: Appetizers and an interactive discussion of various financial, legal, technical and business issues facing startups.
Where: Mercy College located at 66 W 35th Street Ste 704, NY NY 10001
Who: Limited to 36 of us
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              Mercy College 66 W. 35th Street  Ste 704 New York, NY 10001 | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              TUE
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              10
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.meetup.com/Big-Ten-New-York-Tech-Meetup/events/185416222/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Big Apple Badgers &amp; Big Ten New York Tech meetup happy hour with Dan Geiger, Bonobos recruiter (Free)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 10th  6:30pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              A networking happy hour with Dan Geiger, technical recruiter for Bonobos and University of Wisconsin alum, co-hosted by the Big Apple Badgers and the Big Ten New York Tech meetup. Dan will speak for a bit on his experience, then stick around as we get together for a good old fashioned happy hour!
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              Sweetwater Social - 643 Broadway, New York NY | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              TUE
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              10
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.eventbrite.com/e/brooklyns-first-elevator-pitch-competition-tickets-11843539345" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;"> Brooklyn&#x27;s First... Elevator Pitch Competition!</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 10th  6:30pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              If you're in Brooklyn tech, you should come!
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              TUE
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              10
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.meetup.com/hack-and-tell/events/186768992/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Hack And Tell</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 10th  7:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              The format of course stays the same: 5 minutes to show off your hack, and 5 minutes for the audience to applaud, cry, laugh, inquiry, snore, chew, stand, sit, dance, grow, interact, etc. But, of course, we hope that the audience provides lots of great feedback and asks interesting questions (probably while sitting, though dancing audience members are certainly free to participate as well)!<br>Show us what you've got! But, remember, no startup pitches, no work related projects[1], and no deckware! See you at Meetup!&nbsp;RSVPs open 5 days before, so June 5th, at noon
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              TUE
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              10
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="startupessentialsny.eventbrite.com" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Startup Essentials: Joe Meyer, former CEO of HopStop ($15)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 10th  7:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              Startup Essentials welcomes Joe Meyer, former CEO of HopStop (acquired by Apple), who was previously VP of Business Development at Quigo (acquired by AOL) and GM at eBay. Joe was named Entrepreneur of the Year in 2012 by Crain's New York Business, and was #9 on Business Insider's 2013 "Silicon Alley 100" list. Joe is also co-founder and head of curation of a new non-profit career networking initiative called ExecThread.org. Use promo code "StartupDigest" for a 50% discount off all tickets.
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              WeWork SoHo West 175 Varick St. Fl/ 8 New York, NY 10014 | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              WED
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              11
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.smallbizbreakfast.com/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Sell a Lifestyle, Not a Brand  (Free)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 11th  7:45am
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              Start your morning off right with great advice for entrepreneurs, a steaming cup of coffee and a hot breakfast. Hosted by the Small Biz Guru, Ramon Ray and Wix.com.
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              Wix Lounge -- 235 W 23rd Street Floor 8 | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              WED
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              11
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="https://www.eventbrite.com/web-integration?eid=11848937491" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Ask an Attorney (Free)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 11th  6:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              Do you need an expert's opinion on issues relating to your startup? It's your lucky day! Elance is bringing together a team of legal experts to answer your questions! You can submit your questions to jgelbart@elancemobilizer.com. At the event, the audience will decide which questions our esteemed panelist will answer. 

But that's not all...Food will be provided by Elance and every attendee will receive a $100 credit to hire an expert on Elance! Woohooo!
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              WeWork - Nomad - 79 Madison Ave  New York, NY 10016 | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              WED
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              11
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="www.thriveatalley.com" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Arianna Huffington Comes to AlleyNYC ($25)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 11th  6:30pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              We are honored to announce that entrepreneur and media mogul Arianna Huffington will be joining us for a talk and book signing. Space is super limited sp grab your spot NOW. Use promo code 'digest' for 20% off.
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              AlleyNYC | 500 7th Ave, NY, NY | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              WED
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              11
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://meetu.ps/2kXd7d" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">1st Marionette.js (Backbone.js) Meetup (free)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 11th  7:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              Backbone.Wreqr: The under-appreciated messaging system that's built in. Learn powerful design patterns that leverage it to forward the goal of building more structured, organized applications. 

Marionette Behaviors: Behaviors are Marionette's response to view mixins, but without the headache associated with view clobbering, to create everything from tooltips to form validation.

The PARM stack: PARM is a build stack that lets you focus on your idea and less on the implementation details. It represents a shift in the way to build apps. One in which speed and continual delivery is stressed. One that looks at the pieces as swappable chunks.
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              Etsy Labs | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              WED
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              11
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.meetup.com/betanyc/events/185696772/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Civic Hacknight - Transit/Transpo/#Bi­keNYC Focus</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 11th  7:00pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              This is our traditional hacknight with a bit of a twist. With the growing realm of NYC transit and transportation data, every month we dedicate one hacknight a month to transit, transportation, #BikeNYC, and @CitibikeNYC data.What is a hacknight?&nbsp;<br><br>This night is for technologists, designers, developers, and mapmakers who are working on projects. Consider this to be a bit of a study hall. Bring your projects, apps, datasets, and questions, and we will try to collectively answer them.&nbsp;
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              THU
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              12
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://cmxsummit.com" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">CMX Summit ($425)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 12th  9:00am
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              CMX Summit is a conference dedicated to helping you build better communities. Over 2 full days you'll gain clear strategies and proven tactics from the world's leading community experts.

Speakers include successful CEO's like Meetup's Scott Heiferman and Tina Roth Eisenberg from Creative Mornings as well as leading community building experts from companies like TED, Reddit, Etsy, Adobe, BuzzFeed and field experts in Behavioral Analysis and Psychology. 

Space is limited and will sell out. Register at http://cmxsummit.com
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              THU
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              12
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://ultralightstartups-startupdigest.eventbrite.com/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Ultra Light Startups ($20/$30)</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 12th  6:30pm
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              See 8 startups present to 4 top VC's.  Investors give feedback and you vote for your favorite startups, who win prizes.  Startups this month are WiseBanyan, The Loadown, DoRevolution, Aarting, Echovate, Chatwala, Binary Event Network and AfreSHeet.  VC's this month are ARC Angel Fund, Vast Ventures, Paladin Capital, and Flybridge Capital.  Free pizza :)
Register with code 'sd' for 50% off
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              Microsoft (11 Times Square) | 
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
      <tr>
        <td width="100" style="vertical-align: top; padding: 0 0 0 20px;" valign="top">
          <div style="font-family: Tahoma, Geneva, sans-serif; display: block; width: 80px; height: 80px; border-radius: 5px; color: #ffffff; text-align: center; vertical-align: bottom; background-color: #383e4a; margin: 0; padding: 0;" align="center">
            <span style="font-size: 14px; font-weight: 400; display: block; padding: 10px 0 0 0; margin: 0;">
              MON
            </span>
            <span href="" style="font-size: 42px; font-weight: 900; display: block; margin-top: -5px;">
              16
            </span>
          </div>
        </td>
        <td style="padding: 0 20px 0 0">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">

              <a href="http://www.youngstartup.com/newyork2014/speakers.php" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">New York Venture Summit</a>
          </h4>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; font-size: 14px; font-weight: 700; line-height: 1.6em; margin: 0 0 5px 0; padding: 0;">
              June 16th
            </p>
        </td>
      </tr>
        <tr>
          <td colspan="2" style="padding: 10px 20px 50px 20px;">
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 14px; padding: 0; margin: 10px 0 10px 0; line-height: 1.6em;">
              More than 40 leading VCs will speak at the Summit. These top-tier venture investors will discuss: VC investment trends, strategies for investing in early stage ventures, strategies for finding and accessing capital, what they look for in early stage companies, the kinds of companies they find most attractive, and the do's and don'ts in structuring deals.Confirmed VC Speakers, Judges and Experts Include:&nbsp;<a href="http://www.youngstartup.com/newyork2014/bio.php?id=2357" target="" rel="">Grant Allen</a><br>Senior Vice President,<br>ABB Technology Ventures<br><br>&nbsp;<a href="http://www.youngstartup.com/newyork2014/bio.php?id=2314" target="" rel="">Gil Beyda</a><br>Managing Partner,<br>Genacast Ventures
            </p>
            <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 15px 0 0 0; font-size: 12px; padding: 0;">
              
              
              <a href="http://www.google.com/calendar/embed?src=startupdigest.com_97of8kad3f2jq2a1h8jo9d02bk@group.calendar.google.com&amp;ctz=(GMT-05:00) Eastern Time (US &amp; Canada)" target="_blank" style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none; margin: 0; padding: 0;">
                View in Calendar
              </a>
            </p>
          </td>
        </tr>
  </table>

                      <table border="0" cellpadding="0" cellspacing="0" width="600">
    <tr>
      <td style="padding: 0 20px 0 20px;">
        <hr style="border: none; display: block; height: 2px; background-color: #d7d7d7; margin: 0 0 25px 0;">
      </td>
    </tr>
      <tr>
        <td style="padding: 0px 20px 50px 20px;">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">
              <a href="http://connect.kaltura.com/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Kaltura Connect (the Video Experience Conference) ($550- $950)</a>
          </h4>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; font-weight: 900; padding: 0; line-height: 1.8em;">
            June 16th 10:00am
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; padding: 0; line-height: 1.8em;">
            Jazz at Lincoln Center, NYC
            
            
          </p>
        </td>
      </tr>
      <tr>
        <td style="padding: 0px 20px 50px 20px;">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">
              <a href="startupbus2014.eventbrite.com" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">What Happened on the StartupBus NYC? (Free)</a>
          </h4>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; font-weight: 900; padding: 0; line-height: 1.8em;">
            June 16th  6:30pm
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; padding: 0; line-height: 1.8em;">
            ThoughtWorks 99 Madison Ave, Floor 15
            
            
          </p>
        </td>
      </tr>
      <tr>
        <td style="padding: 0px 20px 50px 20px;">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">
              <a href="https://generalassemb.ly/education/assembled-capital-a-founders-guide-to-fundraising/new-york-city/5422" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">Assembled Capital, A Founder&#x27;s Guide to Fundraising ($75)</a>
          </h4>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; font-weight: 900; padding: 0; line-height: 1.8em;">
            June 21st  9:30am
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; padding: 0; line-height: 1.8em;">
            General Assembly East (902 Broadway, 4th Fl, NY NY 10010)
            
            
          </p>
        </td>
      </tr>
      <tr>
        <td style="padding: 0px 20px 50px 20px;">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">
              <a href="http://world.mongodb.com/" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">MongoDB World  ($1095)</a>
          </h4>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; font-weight: 900; padding: 0; line-height: 1.8em;">
            June 23rd
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; padding: 0; line-height: 1.8em;">
            New York City
            
            
          </p>
        </td>
      </tr>
      <tr>
        <td style="padding: 0px 20px 50px 20px;">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">
              <a href="http://strategyhack.org/apply" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">StrategyHack Deadline ($25)</a>
          </h4>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; font-weight: 900; padding: 0; line-height: 1.8em;">
            June 28th
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; padding: 0; line-height: 1.8em;">
            New York, NY
            
            
          </p>
        </td>
      </tr>
      <tr>
        <td style="padding: 0px 20px 50px 20px;">
          <h4 style="font-family: Tahoma, Geneva, sans-serif; color: #0072f1; font-weight: bold; line-height: 1.2em; font-size: 18px; margin: 0 0 4px 0; padding: 0;">
              <a href="http://members.founderdating.com/connect?s=header" style="font-weight: bold; font-family: Tahoma, Geneva, sans-serif; color: #0072f1; text-decoration: none;">FounderDating Application Deadline (NYC)</a>
          </h4>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; font-weight: 900; padding: 0; line-height: 1.8em;">
            July 30th
          </p>
          <p style="font-family: Tahoma, Geneva, sans-serif; color: #000000; margin: 0; font-size: 12px; padding: 0; line-height: 1.8em;">
            New York
            
            
          </p>
        </td>
      </tr>
  </table>

                    
                    
<table border="0" cellpadding="0" cellspacing="0" width="600">
  <tr>
    <td width="250" valign="top" style="background-color: #182937;">
      <ul style="font-size: 14px; line-height: 1.6em; list-style-type: none; margin: 20px 0 10px 0; padding: 0 0 0 20px;">
        <li style="font-family: Tahoma, Geneva, sans-serif; list-style-position: inside; margin: 0 0 10px 0; padding: 0;">
          <a href="https://www.startupdigest.com/subscriptions" style="color: #398ff0; font-style: normal; text-decoration: none; display: block; font-size: 20px; margin: 0; padding: 0;" target="_blank">Manage Subscription</a>
        </li>
        <li style="font-family: Tahoma, Geneva, sans-serif; list-style-position: inside; margin: 0 0 10px 0; padding: 0;">
          <a href="https://www.startupdigest.com/events/new" style="color: #398ff0; font-style: normal; text-decoration: none; display: block; font-size: 20px; margin: 0; padding: 0;" target="_blank">Submit Event</a>
        </li>
        <li style="font-family: Tahoma, Geneva, sans-serif; list-style-position: inside; margin: 0; padding: 0;">
          <a href="http://us1.campaign-archive1.com/?u=92be899ef5a892c60b4a6cd97&id=abae58820c&e=40e4668758" target="_blank" style="color: #398ff0; font-style: normal; text-decoration: none; display: block; font-size: 20px; margin: 0; padding: 0;">View in Browser</a>
        </li>
      </ul>
    </td>
    <td style="background-color: #182937; padding: 0 20px 0 0;">
      <p style="font-family: Tahoma, Geneva, sans-serif; color: #ffffff; font-size: 13px; line-height: 1.8em; margin: 20px 0 15px 0;">
        You are receiving this email because you are an active member
        of the New York City startup community.
      </p>
      <p style="font-family: Tahoma, Geneva, sans-serif; color: #ffffff; font-size: 13px; line-height: 1.8em; margin: 0 0 10px 0; padding: 10px 0 10px 0;">
        &copy; 2009-2013 <a href="http://www.startupdigest.com" style="color: #398ff0;">StartupDigest</a>.
        StartupDigest is a registered trademark of <a href="http://www.startupweekend.com" style="color: #398ff0;">Startup Weekend</a>.
        All rights reserved.
      </p>
    </td>
  </tr>
</table>

                </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>    
</html>

  """


toPlainText html