var Tabula;
window.Tabula = Tabula || {};
$.ajaxSetup({ cache: false }); // fixes a dumb issue where Internet Explorer caches Ajax requests. See https://github.com/tabulapdf/tabula/issues/408
var base_uri = $('base').attr("href");

Tabula.UI_VERSION = "1.2.1-2018-05-22"; // when we make releases, we should remember to up this.
// Add '-pre' to the end of this for a prerelease version; this will let
// our "new version" check give you that channel.

// Note that this is separate from the "API version" (internal app version)
// which is what we check against GitHub. In the future, this will allow us
// to modularize the UI from the backend some more.


var TabulaRouter = Backbone.Router.extend({
  routes: {
    "":                            "upload",
    "/":                           "upload",
    "pdf/:file_id":                "view",
    "pdf/:file_id/extract":        "view", // you have to make selections first, so going directly to /extract doesn't work.
    "queue/:file_id":              'status',
    "error":                       'uploadError',
    "help":                        'help',
    "about":                       'about',
    "mytemplates":                 'templates'
  },

  help: function(){
    document.title="Help | Tabula";
    $('nav li a').removeClass('active'); $('nav #help-nav').addClass('active');
    $('#tabula-app').html( _.template( $('#help-template').html().replace(/nestedscript/g, 'script') )({ }) );
  },

  about: function(){
    document.title="About | Tabula";
    $('nav li a').removeClass('active'); $('nav #about-nav').addClass('active');
    $('#tabula-app').html( _.template( $('#about-template').html().replace(/nestedscript/g, 'script') )({ }) );
  },

  templates: function(){
    document.title="Templates | Tabula";
    $('nav li a').removeClass('active'); $('nav #templates-nav').addClass('active');
    $('#tabula-app').html( _.template( $('#templates-template').html().replace(/nestedscript/g, 'script') )({ }) );
    $.ajax({
      url: (base_uri || '/') + "js/template_library.js",
      dataType: "script",
      async: true,
      success: function(data, status, jqxhr){
        Tabula.library = new Tabula.TemplateLibrary({el: $('#tabula-app')[0]}).render();
      },
      error: function(a,b,c){
        console.log(a,b,c);
      }
    });
  },

  upload: function() { // library page.
    document.title="Import | XML Extractor";
    $('nav li a').removeClass('active'); $('nav #upload-nav').addClass('active');
    $.ajax({
      url: (base_uri || '/') + "js/library.js",
      dataType: "script",
      async: true,
      success: function(data, status, jqxhr){
        Tabula.library = new Tabula.Library({el: $('#tabula-app')[0]}).render();
      },
      error: function(a,b,c){
        console.log(a,b,c);
      }
    });
  },

  view: function(file_id) {
    $('nav li a').removeClass('active');
    // $('body').prepend( _.template( $('#navbar-template').html().replace(/nestedscript/g, 'script') )({}) ); // navbar.
    $('body').addClass('page-selections')
    $('#tabula-app').html( _.template( $('#pdf-view-template').html().replace(/nestedscript/g, 'script') )({}) );

    $.ajax({
      url: (base_uri || '/') + "js/pdf_view.js",
      dataType: "script",
      async: true,
      success: function(data, status, jqxhr){
        Tabula.pdf_view = new Tabula.PDFView({pdf_id: file_id});
        Tabula.pdf_view.getData();
      },
      error: function(a,b,c){
        console.log(a,b,c);
      }
    });
  },
});




$(function(){
  window.tabula_router = new TabulaRouter();
  Backbone.history.start({
    pushState: true,
    root: base_uri
  });
});
