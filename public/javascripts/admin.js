$(function () {
  SyntaxHighlighter.defaults['toolbar'] = false;
  SyntaxHighlighter.all();

  $('form').submit(function () {
    $.each(WYMeditor.INSTANCES, function (i, e) {
      jQuery.wymeditors(i).update();
    });
  });
});
