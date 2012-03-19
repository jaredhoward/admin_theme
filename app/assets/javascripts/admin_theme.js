//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require active_admin

$(function() {

  setup_sortable_tables();

  $('.flashes .flash').delay(4000).slideUp(1000);

  $('.buttons .cancel a').click(function(event){
    event.stopPropagation();
    window.history.back();
  });

});

function setup_sortable_tables() {
  $('table[data-sortable-table]').each(function(){
    sortable_table = $(this);
    sortable_area = sortable_table.first('tbody');
    sortable_value = sortable_table.data('sortable-table');

    options = {axis: 'y', containment: 'parent', cursor: 'move', items: 'tr',
      update: function(){
        ajax_options = {
          data: sortable_area.sortable('serialize'),
          dataType: 'script',
          type: 'PUT'
        }
        if (sortable_value !== true) ajax_options['url'] = (sortable_value.match(/^\//) ? sortable_value : window.location.pathname + '/' + sortable_value);

        $.ajax(ajax_options);
      }
    }
    if (sortable_table.find('span.handle').size() > 0) options['handle'] = 'span.handle'

    sortable_area.sortable(options);
    // sortable_area.disableSelection();
  });
}
