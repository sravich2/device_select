/**
 * Created by sachin on 2/8/15.
 */
$(document).ready(function () {
    if ($('body').is('.review-body')) {
        $('.align-settings').on('click', '*', function () {
            var align_css_class = {'text-align': $(this).attr('align-value')};
            $('.article-content').css(align_css_class);
        });

        $('.length-settings').on('click', '*', function () {
            var action = $(this).attr('length-action');
            var currentSetting = pxToPercent($('.article'));
            var newSetting;
            if (action == '+') {
                newSetting = currentSetting + 10 + '%';
            }
            else if (action == '-') {
                newSetting = currentSetting - 10 + '%';
            }
            if (parseInt(newSetting) <= 100 && parseInt(newSetting) >= 30) {
                var extend_css_class = {'width': newSetting};
                $('.article').css(extend_css_class);
            }
        });

        $('.font-size-settings').on('click', '*', function () {
            var action = $(this).attr('font-size-action');
            var currentSetting = $('.article-content').css('font-size');
            var newSetting;
            if (action == '+') {
                newSetting = (parseInt(currentSetting) + 1) + 'px';
            }
            else if (action == '-') {
                newSetting = (parseInt(currentSetting) - 1) + 'px';
            }
            var font_size_css_class = {'font-size': newSetting};
            $('.article-content').css(font_size_css_class);
        });

        $('.background-settings').on('click', '*', function () {
            var newBgColor = $(this).attr('bg-color-value');
            var bg_color_css_class;
            if (newBgColor != 'black') {
                bg_color_css_class = {'background-color': newBgColor, color: 'black'};
            }
            else {
                bg_color_css_class = {'background-color': newBgColor, color: 'white'}
            }
            $('.article-container').css(bg_color_css_class);
        });

        $('.image-settings').on('click', '*', function () {
            var img_display_class;
            var display_setting = $(this).attr('display_value');
            if (display_setting == 'block') {
                $('img').css("display", "none");
                $(this).attr('display_value', 'none');
            }
            else {
                $('img').css("display", "block");
                $(this).attr('display_value', 'block');
            }
        });

        $(document).keydown(function (e) {
            if (e.which == 39) {
                $('.article').hide('drop', {direction: 'left'}, 1000);
            }
            e.preventDefault();
        })
    }
    ;

    var pxToPercent = function (element) {
        return Math.round(100 * parseFloat(element.css('width')) / parseFloat(element.parent().css('width'))); // Converts px to %
    }
});
/**
 * Created by sachin on 1/12/15.
 */
