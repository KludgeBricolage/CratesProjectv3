
    function imageGallery(imageString){
            for(i = 0; i < imageString.length; i++) {
                if(i == 0) {             
                    $(gm1).append('<img src=' + imageString[i] + '>');
                    $(gMod1).append('<img src=' + imageString[i] + '>');
                } else {
                    $(gd1).append('<img src=' + imageString[i] + '>');
                }
            }
            
            $('.crates.gallery .gallery.display').on("click", "img", function() {
                var displaySrc = $(this).attr('src');
                var mainSrc = $(this).parent().parent().find('.gallery.main').find('img').attr('src');
                $(this).parent().parent().find('.gallery.main').find('img').attr('src', displaySrc);
                $(this).attr('src', mainSrc);
                $(gMod1).find('img').attr('src', displaySrc);
                
            });
            $('.crates.gallery .gallery.main').on("click", "img", function() {
                $('.ui.basic.modal').modal('show');
            });
}