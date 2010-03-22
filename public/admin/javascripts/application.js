$(function() {
  $('table.sortable tbody').sortable({
    axis: 'y',
    containment: 'table.sortable tbody',
    cursor: 'url(/admin/images/slide.cur), move',
    helper: function(e, ui) {
      ui.children().each(function() {
        $(this).width($(this).width());
      });
      return ui;
    },
    start: function(e, ui) {
      ui.item.animate({'backgroundColor': '#FFEFC5'}, 50);
      return ui;
    },
    stop: function(e, ui) {
      var ids = []
      var who = undefined;
      $('table.sortable tbody>tr').each(function(index){
        who = this.id.split("_")[0];
        ids.push(this.id.split("_")[1]);
      });
      $.post('sort/' + who, { ids: ids.join(',') });
      ui.item.animate({'backgroundColor': '#FFFFFF'}, 50);
      return ui;
    }
  }).disableSelection();
});