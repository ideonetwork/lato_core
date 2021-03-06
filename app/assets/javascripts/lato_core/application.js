// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree ./vendors
//= require_tree ./modules

$(document).ready(function () {
  CoreButton.init()
  CoreChart.init()
  CoreDatepicker.init()
  CoreFlash.init()
  CoreFormValidator.init()
  CoreLayout.init()
  CoreModal.init()
  CoreSelect.init()
  CoreSortableManager.init()
  CoreTable.init()
  CoreEditor.init()
})

$(window).load(function () {
  // DISCUSSION: Messo al load per attendere caricamento dipendenze Google mappe.
  // Valutare se fare un modulo solo per le mappe e spostare solo
  // quelllo al load.
  CoreMediapicker.init()
})
