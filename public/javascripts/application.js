$(document).ready(function() {
  $("a[rel=popup_image]").fancybox({
    transitionIn  : 'fade',
    transitionOut : 'fade',
    titlePosition : 'over',
    titleFormat   : function(title, currentArray, currentIndex, currentOpts) {
      if (currentArray.length > 1) {
        return '<span id="fancybox-title-over">Image ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
      }
    }
  });
  $("a[rel=popup]").fancybox({
    transitionIn  : 'fade',
    transitionOut : 'fade',
    titlePosition : 'over',
    titleFormat   : function(title, currentArray, currentIndex, currentOpts) {
      if (currentArray.length > 1) {
        return '<span id="fancybox-title-over">Feature ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
      }
    }
  });
});