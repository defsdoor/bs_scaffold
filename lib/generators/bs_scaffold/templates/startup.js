var navPosition = 0;

function bindFullPageEvents() {
  document.addEventListener("turbolinks:click", function() {
    $('*[data-toggle = "tooltip"]').tooltip('hide');
  })
 
  $(document).on('change', '.onchange.persisted', function(e) {
    $(this).collectedSubmit();
    e.preventDefault();
    return(false);
  });

  $(document).on('change', '.context-show', function(e) {
    $(this).contextShow();
    e.preventDefault();
    return(false);
  });

  $(document).on('click', '.onclick.persisted', function(e) {
    $(this).collectedSubmit();
    e.preventDefault();
    return(false);
  });

  $(document).on('click', '#sideNav .nav-link', function(e) {
    $('#sideNav').removeClass('show');
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

  $(document).on('click', '.dropdown-menu a.dropdown-toggle', function(e) {
    if (!$(this).next().hasClass('show')) {
      $(this).parents('.dropdown-menu').first().find('.show').removeClass('show');
    }
    var $subMenu = $(this).next('.dropdown-menu');
    $subMenu.toggleClass('show');


    $(this).parents('li.nav-item.dropdown.show').on('hidden.bs.dropdown', function(e) {
      $('.dropdown-submenu .show').removeClass('show');
    });

    return false;
  });

  $(document).on('click', '.copy-to-clipboard', function(e) {
    var button = $(this);
    var target = button.data('target');
    var copied = button.data('copied');
    if (target.length > 0) {
      $(target).select();
      $(target)[0].setSelectionRange(0,9999999999);
      document.execCommand("copy");
      if (copied) {
        var current_text = button.html();
        button.html(copied);
        setTimeout( function() { button.html(current_text); }, 3000);
      }
    }
  });

  $(document).on('click', '.row-click', function(e) {
    var target = $(e.target);
    if (target.is("td")) {
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
    }
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
    var s = event.target.href.match(/#[^#]*$/);
    if (s) {
      window.history.replaceState(history.state, "", s);
    }
  });

  // reset fullheights when modals closes
  $(document).on('hidden.bs.modal', function(e) {
    $('#Modal').resetModal();
    var importing = $('.modal-body.import').length > 0 ;
    if (importing) Turbolinks.visit(window.location.toString(), { action: 'replace' });
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
    if (e.data != undefined) return;
    var dest = a.attr("href");
    if (dest != undefined) {
      $.getScript(dest, function() {
        var change_size_to = $('#Modal .modal-body').data('size');
        if (change_size_to != '') $('#Modal .modal-dialog').alterClass("modal-sm modal-lg modal-xl", change_size_to);
      });
    }
  });

  $(document).on('click', '.reset-input', function(e) {
    $($(this).data('target')).val('');
    return(false);
  });

  $(document).on('ajax:success', function(e) {
    var load_again = ! $(e.target).is("body");
    highLightTree(load_again);
  });
  $(document).ajaxSuccess(function(e) {
    var load_again = ! $(e.target).is("body");
    highLightTree(load_again);
  });

  $(document).on('change', '.reload-select', function(e) {
    console.log($(this));
    var target = $(this).data("reload-target");
    var url = $(this).data("reload-url");
    var val = $(this).find('option:selected').attr("value");
    $.get( url.replace("-1", val), function(data) {
      $(target).html(data);
    });
  });

  window.onscroll = function() {
    $('.infinite-scroll.no-full-height').performScroll(true);
  }
};

function highLightTree(load_again) {
  $('#treeView .nav-link').removeClass('active');
  var treeLink = $('#treeLink');
  if (treeLink.length > 0) {
    var linkValue=treeLink.data('link-id');
    if (linkValue.length > 0) {
      var treeEntry = $('#treeView .nav-link'+linkValue);
      if (treeEntry.length > 0) {
        treeEntry.addClass('active').html(treeLink.html());
      } else  {
        if (load_again == undefined || load_again) $.ajax( { url: '/tree', context: document.body, dataType: "script" });
      }
    }
    $('.link-title').html(treeLink.html());
  }
};

function fetchActiveTab() {
  $('ul.live-tabs').each( function() {
    var tabs = $(this);
    var hashBit = window.location.hash;
    if (hashBit) {
      var tab = tabs.find('li a[href="'+ hashBit + '"]');
      if (tab.length > 0 ) {
        tabs.find('li a').removeClass("active"); 
        tab.click(); 
        return;
      }
    } 
    var default_tab = tabs.find('li a.default');
    if (default_tab.length > 0)
      setTimeout( function() { tabs.find('li a.default').click(); }, 100 );
    else if ( tabs.find('li a.active').length == 0 ) { tabs.find('li a:first').click(); };
  })
}

function everyPageSetup() {
  $('#Modal').resetModal();
  fetchActiveTab();
  $('html').initialiseNewContent( { "doFullHeight": true } );
  highLightTree();
};

bindFullPageEvents();

$(document).on("turbolinks:before-visit", function(event) { navPosition = $('#sideNav').scrollTop(); });
$(document).on("turbolinks:render", function(event) { $('#sideNav').scrollTop(navPosition); });

$(document).on('turbolinks:load', everyPageSetup);
$(window).resize( function() { $('.full-height').fullHeight(); });
