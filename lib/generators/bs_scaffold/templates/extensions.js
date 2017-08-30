var getUrlParameter = function getUrlParameter(url, sParam) {
    var sPageURL = decodeURIComponent(url),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

(function($) {

  $.fn.observeField = function(frequency, callback) {

    frequency = frequency * 1000; // translate to milliseconds

    return this.each(function(){
      var $this = $(this);
      var prev = $this.val();
      var prevChecked = $this.prop('checked');

      var check = function() {
        if(removed()){ // if removed clear the interval and don't fire the callback
          if(ti) clearInterval(ti);
          return;
        }

        var val = $this.val();
        var checked = $this.prop('checked');
        if(prev != val || checked != prevChecked ){
          prev = val;
          prevChecked = checked;
          $this.map(callback); // invokes the callback on $this
        }
      };

      var removed = function() {
        return $this.closest('html').length == 0
      };

      var reset = function() {
        if(ti){
          clearInterval(ti);
          ti = setInterval(check, frequency);
        }
      };

      check();
      var ti = setInterval(check, frequency); // invoke check periodically

      // reset counter after user interaction
      $this.bind('keyup click mousemove', reset); //mousemove is for selects
    });

  };

  $.fn.resetModal = function(options) {
    return this.each( function() {
      var element = $(this);
      element.find('.modal-content').html('<div class="center-text"><i class="icon-spinner animate-spin icon-3x"></i></div>')
        .end()
        .find('.modal-dialog').removeClass('modal-lg').removeClass('modal-sm');
    });
  }

  $.fn.observed = function(options) {
    return this.each( function() {
      $(this).observeField(0.3, function() {
        var collect = $(this).data('collect');
        if (collect) {
          $(this).collectedSubmit();
        } else {
          var url = $(this).data('url');
          var name = $(this).attr('name');
          var data = {};
          data[name] = $(this).val();
          $.ajax( {
            url: url,
            dataType: "script",
            data: data });
        }
        $(this).keypress(function(event) { return event.keyCode != 13; });
      });
    });
  };

  $.fn.flash = function(options) {
    var opacity = 100;
    var color = "255, 255, 20";
    var element = $(this);
    return this.each( function() {
      var interval = setInterval(function() {
        opacity -= 3;
        if (opacity <=0) {
           clearInterval(interval);
           element.css({background: ""});
        } else
          element.css({background: "rgba("+color+", "+opacity/100+")"});
      }, 30);
    });
  };

  $.fn.goto = function(element) {
    return this.each( function() {
      $(this).scrollTop( element.position().top);
    });
  };

  $.fn.infiniteScroll = function(options) {
    return this.each( function() {
      var element = $(this);
      var target_element;
      if (element.data('scroll-target') ) {
        target_element = $(element.data('scroll-target') );
        if (target_element.length == 0) console.log('Scroll target does not exist');
      } else {
        target_element = element;
      }
      var next_page_url = target_element.data('next-page-url');
      if (next_page_url != '' ) {
        element.scrollTop(0)
          .off('scroll')
          .on('scroll', function() {
            var target_element;
            if (element.data('scroll-target') ) {
              target_element = $(element.data('scroll-target') );
            } else {
              target_element = element
            }
            var more = target_element.find('.more');
            var height = element.height();
            var next_page_url = target_element.data('next-page-url');
            if (next_page_url == '' ) return;
            var this_top = $(this).position().top; //scroll container top
            var position = more.position().top - this_top; // more data's top
            if (next_page_url && position <= height + height/2 ) {
              target_element.removeData('next-page-url')
                .removeAttr('data-next-page-url');
              more.find('.message').html('<i class="fa fa-spinner fa-2x fa-spin"></i>');
              $.getScript( next_page_url )
                .done( function() {
                  more.appendTo(target_element);
                  var next_page_url = target_element.data('next-page-url');
                  if (next_page_url)
                    more.find('.message').html('<a href="' + next_page_url + '" data-remote="true">More</a>');
                  else
                    more.find('.message').html("No More Records");
                } );
            }

        });
      } else {
          if (target_element.children().length > 1)
            target_element.find('.more  .message').html('No More Records', '');
          else
            target_element.find('.more .message').html('No Records Found', '');
      }
    });
  };

  $.fn.setupTooltips = function(options) {
    return this.each( function() {
      $(this).find('[data-toggle="tooltip"]').tooltip({container: 'body', placement: function(context, source) {
        var position = $(source).position().left;
        var window_width = $(window).width();
        if (position > window_width/2 ) return "left";
        return "right";
      } });
    });
  };


  $.fn.newHTML = function(html, options) {
    return this.each( function() {
      $(this).html(html).initialiseNewContent(options);
    });
  }

  $.fn.replaceHTML = function(html, options) {
    return this.each( function() {
      $(this).replaceWith(html);
      $(this).initialiseNewContent(options);
    });
  }

  $.fn.initialiseNewContent = function(options) {
    this.each( function() {
      $(this).find('.infinite-scroll').infiniteScroll()
        .end()
        .find('.observed').observed()
        .end()
//        .setupTooltips()
//        .find('.datepicker').datepicker( { dateFormat: 'dd/mm/yy', autoClose: true, changeYear: true })
 //       .end()
//      .find('[type="checkbox"].switch').bootstrapSwitch().on('switchChange.bootstrapSwitch', function(event, state) {
 //       if ($(this).data('toggle') ) $($(this).data('toggle')).toggle();
  //    })
   //   .end()
    });

    if ($(this).hasClass('infinite-scroll')) $(this).infiniteScroll();

    if ( options && options.doFullHeight) {
      console.log("Doing Full Height");
      $('.full-height').fullHeight();
    }

    return(this);

  }

  $.fn.firstFocus = function(options) {
    return this.each(function() {
      $(this).find(':input:not(input[type=button],input[type=submit],button,input[type="hidden"]):first').focus();
    });
  }

  $.fn.fullHeight = function(options) {
    var window_height =  $(window).height();        // Bottom of browser window
    var selected = this.each( function() {
        $(this).height($(this).css('min-height') || 0 );
    });

    var baseline = $('#pageBaseLine');
    if (baseline.length == 1) {
      var footerTop = $('#pageBaseLine').offset().top; // Bottom of document

      return selected.each( function() {
        var element = $(this);
        var base = $(element.data('baseline'));
          var baseTop = base.offset().top;
          var bottomGap = footerTop - baseTop;
          if (window_height > footerTop) {
            var pageBottom = window_height;
          } else {
            var pageBottom = footerTop;
          }
          element.height( element.height() + pageBottom - baseTop - bottomGap  ); // is this window decoration ?
      });
    }
  };


  $.fn.getInputType = function () {
    return this[0].tagName.toString().toLowerCase() === "input" ?
      $(this[0]).prop("type").toLowerCase() :
      this[0].tagName.toLowerCase();
  }; // getInputType

  $.fn.collectedSubmit = function(options) {
    var element = $(this);

    if ( options && options.url) {
      var gotoURL = options.url;
    } else {
      var gotoURL = element.data('url');
    }

    if ( options && options.collect) {
      var collect = options.collect;
    } else {
      var collect = element.data('collect');
    }
    
    if (!gotoURL) gotoURL = element.attr('href');

    var data = {};
    var notSort = !element.hasClass('sort');
    $(collect).each( function() {
      var thisIsSort=$(this).hasClass('sort');
      if ($(this).getInputType() == "radio") {
        if ( $(this).is(":checked") )
          data[$(this).attr('name')] = $(this).val();
      }
      else if ( notSort ) {
        if (thisIsSort) {
          if  ($(this).hasClass('current')) {
            var href = $(this). attr('href');
            data['sort'] = getUrlParameter(href, 'sort');
            data['direction'] = $(this).hasClass('desc') ? 'desc' : 'asc';
          }
        }
        else data[$(this).attr('name')] = $(this).val();
      } else {
        if (! thisIsSort) data[$(this).attr('name')] = $(this).val();
      }
    });
    $.ajax( {
      url: gotoURL,
      dataType: "script",
      data: data });
  };


})(jQuery);
