function bindFullPageEvents() {
  // 
  $(document).on('change', '.onchange.persisted', function(e) {
    $(this).collectedSubmit();
    e.preventDefault();
    return(false);
  });

  $(document).on('click', '.onclick.persisted', function(e) {
    $(this).collectedSubmit();
    e.preventDefault();
    return(false);
  });

  $(document).tooltip({
    selector: '[data-toggle="tooltip"]',
    container: 'body', placement: function(context, source) {
      var position = $(source).position().left;
      var window_width = $(window).width();
      if (position > window_width/2 ) return "left";
      return "right";
    }
  });

  $(document).on('dblclick', '.double-click', function(e) {
    $(this).collectedSubmit( { url: $(this).data("doubleclick").url, collect: $(this).data("doubleclick").collect } );
    // if ($(this).hasClass('remote-tab')
    return(false);
  });

  $(document).on('click', '.row-click', function(e) {
    var url = $(this).data('url');
    if ( $(this).hasClass('remote') ) {
      $.getScript(url);
    } else {
      Turbolinks.visit(url);
    }
    if ( $(this).hasClass('activate') ) {
      $(this).addClass('active').siblings().removeClass('active');
    }
    e.preventDefault();
    return(false);
  });

  $(document).on('click', '.remote-tab', function(e) {
    var ref = $(this).attr("href");
    var url = $(this).data("url");
    var tabContainer = $(this).closest('.nav').next('.tab-content');
    var tabContent = tabContainer.find(ref);
    if (tabContent.length) {
      $(this).tab('show');
      if (tabContent.is(':empty')) {
        $(ref).html('<div class="text-center"><i class="fontello icon-4x icon-spin4 icon-spin-cw"></i></div>');
        $.getScript(url, function() { 
          tabContainer.initialiseNewContent({ doFullHeight: true });
        });
      } else {
        // Resize full heights inside tabs on tab change
        tabContainer.initialiseNewContent({ doFullHeight: true });
      }

    }
    e.preventDefault();
    return(false);
  });

  // reset fullheights when modals closes
  $(document).on('hidden.bs.modal', function(e) {
    console.log("cheese");
    $('#Modal').html('<div class="modal-dialog" role="document"><div class="modal-content"><div class="text-center"><i class="fontello icon-4x icon-spin4 icon-spin-cw"></i></div><div></div></div></div>');
    $('.full-height').fullHeight();
  });

  // set input to first input field when modal shows
  $(document).on('shown.bs.modal', function(e) {
    var focalPoint=$(e.target);
    setTimeout( function() { 
      focalPoint.firstFocus(); 
    }, 500);
  });

  $(document).on('click', '.reset-input', function(e) {
    $($(this).data('target')).val('');
    return(false);
  });

};

function everyPageSetup() {
  console.log("Every Page");
  $('html').initialiseNewContent( { "doFullHeight": true } );
};

bindFullPageEvents();

$(document).on('turbolinks:load', everyPageSetup);
$(window).resize( function() { $('.full-height').fullHeight(); });
