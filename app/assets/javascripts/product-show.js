/**
 * Created by sachin on 3/12/15.
 */
$(document).ready(function () {
    $('.like-want-buttons').on('click', '*', function() {
        var which_button = $(this).attr('button-value');
        var active = $(this).hasClass('active');
        //if (active) {
        //    $(this).removeClass('active');
        //}
        if (!active) {
            $(this).addClass('active');
        }
    });
});
/**
 * Created by sachin on 1/12/15.
 */
