function bindFullPageEvents() {
  // 
  
  document.addEventListener("turbolinks:click", function() {
    $('*[data-toggle = "tooltip"]').tooltip('hide');
  })
 
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
    e.preventDefault();
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

  $(document).off('click', '.remote-tab').on('click', '.remote-tab', function(e) {
    var ref = $(this).attr("href");
    var url = $(this).data("url");
    var tabContainer = $(this).closest('.nav').next('.tab-content');
    var tabContent = tabContainer.find(ref);
    if (tabContent.length) {
      if ( tabContent.html().trim().length == 0) {
        $.getScript(url, function() { 
          // tabContainer.initialiseNewContent({ doFullHeight: false });
        });
      } else {
        // Resize full heights inside tabs on tab change
      }
      $(this).tab('show');

    }
    e.preventDefault();
    return(false);
  });

  $(document).on('shown.bs.tab', function(event) {
    $('.full-height').fullHeight();
    var s = event.target.href.match(/#[^#]*$/);
    if (s) {
      window.history.replaceState(history.state, "", s);
    }
  });

  // reset fullheights when modals closes
  $(document).on('hidden.bs.modal', function(e) {
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

  $(document).on('show.bs.modal', function(e) {
    var a = $(e.relatedTarget)
    var dest = a.attr("href");
    $.getScript(dest, function() { });
  });

  $(document).on('click', '.reset-input', function(e) {
    $($(this).data('target')).val('');
    return(false);
  });

  window.onscroll = function() {
    $('.infinite-scroll.no-full-height').performScroll(true);
  }

};

function fetchActiveTab() {
  if ( $('ul#tabs').length == 0 ) return;
  var hashBit = window.location.hash;
  if (hashBit) {
    var tab = $('ul#tabs li a[href="'+ hashBit + '"]');
    if (tab.length > 0 ) {
      $('ul#tabs li a').removeClass("active"); 
      tab.click(); 
      return;
    }
  } 
  var default_tab = $('ul#tabs li a.default');
  if (default_tab.length > 0)
    setTimeout( function() { $('ul#tabs li a.default').click(); }, 100 );
  else if ( $('ul#tabs li a.active').length == 0 ) { $('ul#tabs li a:first').click(); };
}

function everyPageSetup() {
  fetchActiveTab();
  $('html').initialiseNewContent( { "doFullHeight": true } );
};

bindFullPageEvents();

$(document).on('turbolinks:load', everyPageSetup);
$(window).resize( function() { $('.full-height').fullHeight(); });
