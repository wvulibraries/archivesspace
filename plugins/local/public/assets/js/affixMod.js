$(function(){
    console.log('custom js has been added and is running');

    if($('#affixNavFix').length){
      $('#affixNavFix').affix({
        offset: {
          top: $('#affixNavFix').offset().top,
          bottom: ($('footer').outerHeight(true) + 40),
        }
      });
    }
});
