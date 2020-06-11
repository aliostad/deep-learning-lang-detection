<!--ZZ_sprite-->
<div class="sprite">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <?php
                $BaseClass = 'glyphicon-sprite';
                $spritepath = '/img/sprite.png';
                $gridsize = 16;
                $IconArray = array(
                    'sitemap' => showIcon(0, 0, 1, 1),
                    'facebook' => showIcon(1, 0, 1, 1),
                    'twitter' => showIcon(2, 0, 1, 1),
                    'google-plus' => showIcon(3, 0, 1, 1),
                    'rss' => showIcon(4, 0, 1, 1),
                    'user' => showIcon(5, 0, 1, 1),
                    'heart' => showIcon(6, 0, 1, 1),
                    'lock' => showIcon(7, 0, 1, 1),
                    'search' => showIcon(8, 0, 1, 1),
                    'old-phone' => showIcon(9, 0, 1, 1),
                    'basket' => showIcon(10, 0, 1, 1),
                    'marker' => showIcon(11, 0, 1, 1),
                    'envelope' => showIcon(12, 0, 1, 1),
                    'fax' => showIcon(13, 0, 1, 1),
                    'phone' => showIcon(14, 0, 1, 1),
                    'trolley' => showIcon(15, 0, 1, 1),
                    'box' => showIcon(16, 0, 1, 1),
                    'cute' => showIcon(17, 0, 1, 1),
                    'nova-poshta' => showIcon(18, 0, 1, 1),
                    'truck' => showIcon(19, 0, 1, 1),
                    'sitemap-hover' => showIcon(0, 1, 1, 1),
                    'facebook-hover' => showIcon(1, 1, 1, 1),
                    'twitter-hover' => showIcon(2, 1, 1, 1),
                    'google-plus-hover' => showIcon(3, 1, 1, 1),
                    'rss-hover' => showIcon(4, 1, 1, 1),
                    'user-hover' => showIcon(5, 1, 1, 1),
                    'heart-hover' => showIcon(6, 1, 1, 1),
                    'lock-hover' => showIcon(7, 1, 1, 1),
                    'search-hover' => showIcon(8, 1, 1, 1),
                    'old-phone-hover' => showIcon(9, 1, 1, 1),
                    'basket-hover' => showIcon(10, 1, 1, 1),
                    'marker-hover' => showIcon(11, 1, 1, 1),
                    'envelope-hover' => showIcon(12, 1, 1, 1),
                    'fax-hover' => showIcon(13, 1, 1, 1),
                    'phone-hover' => showIcon(14, 1, 1, 1),
                    'trolley-hover' => showIcon(15, 1, 1, 1),
                    'box-hover' => showIcon(16, 1, 1, 1),
                    'cute-hover' => showIcon(17, 1, 1, 1),
                    'nova-poshta-hover' => showIcon(18, 1, 1, 1),
                    'truck-hover' => showIcon(19, 1, 1, 1),
                    'caret-up' => showIcon(0, 2, 1, 1),
                    'star-black' => showIcon(1, 2, 1, 1),
                    'show-block' => showIcon(2, 2, 1, 1),
                    'show-string' => showIcon(3, 2, 1, 1),
                    'select-unchecked' => showIcon(4, 2, 1, 1),
                    'radio-onchecked' => showIcon(5, 2, 1, 1),
                    'link' => showIcon(6, 2, 1, 1),
                    'caret-down' => showIcon(0, 3, 1, 1),
                    'star-white' => showIcon(1, 3, 1, 1),
                    'show-block-disabled' => showIcon(2, 3, 1, 1),
                    'show-string-disabled' => showIcon(3, 3, 1, 1),
                    'select-checked' => showIcon(4, 3, 1, 1),
                    'radio-checked' => showIcon(5, 3, 1, 1),
                    'select-mixed' => showIcon(6, 3, 1, 1),
                    'add' => showIcon(7, 3, 1, 1),
                    'caret-up-md' => showIcon(8, 2, 2, 1),
                    'caret-up-md-hover' => showIcon(8, 3, 2, 1),
                    'caret-down-md' => showIcon(10, 2, 2, 1),
                    'caret-down-md-hover' => showIcon(10, 3, 2, 1),
                    'caret-left-md' => showIcon(12, 2, 1, 2),
                    'caret-left-md-hover' => showIcon(13, 2, 1, 2),
                    'caret-right-md' => showIcon(14, 2, 1, 2),
                    'caret-right-md-hover' => showIcon(15, 2, 1, 2),
                    'success' => showIcon(16, 2, 2, 2),
                    'error' => showIcon(18, 2, 2, 2),
                    'slider-left' => showIcon(0, 4, 3, 3),
                    'slider-right' => showIcon(3, 4, 3, 3),
                    'docs' => showIcon(6, 4, 3, 3),
                    'baner-money' => showIcon(0, 7, 4, 4),
                    'baner-tasks' => showIcon(4, 7, 4, 4),
                    'baner-winner' => showIcon(8, 7, 4, 4),
                );

                function showIcon($left, $top, $width, $height) {
                    global $gridsize;
                    $left = $left * $gridsize;
                    $top = $top * $gridsize;
                    $width = $width * $gridsize;
                    $height = $height * $gridsize;
                    $css_prop = '&#09;background-position: -' . $left . 'px -' . $top . 'px;&#13;&#10;';
                    $css_prop .= $width > $gridsize ? '&#09;width: ' . $width . 'px;&#13;&#10;' : '';
                    $css_prop .= $height > $gridsize ? '&#09;height: ' . $height . 'px;&#13;&#10;' : '';
                    return $css_prop;
                }

                function CreateSpriteCss($array, $prefix) {
                    global $BaseClass;
                    global $gridsize;
                    global $spritepath;
                    $output = '.' . $BaseClass . '{'
                            . '&#13;&#10;&#09;background: url(\'' . $spritepath . '\') no-repeat;'
                            . '&#13;&#10;&#09;width: ' . $gridsize . 'px;'
                            . '&#13;&#10;&#09;height: ' . $gridsize . 'px;'
                            . '&#13;&#10;&#09;display:inline-block;&#13;&#10;}&#13;&#10;&#13;&#10;';
                    foreach ($array as $key => $value) {
                        $output .= '.' . $prefix . '-' . $key . ' {&#13;&#10;' . $value . '}&#13;&#10;&#13;&#10;';
                    }
                    return $output;
                }
                ?>
                <?php foreach ($IconArray as $key => $value): ?>
                    <div>
                        <span class="<?php echo $BaseClass . ' ' . $BaseClass . '-' . $key ?>"></span>
                        <?php echo $value; ?>
                    </div>
                <?php endforeach; ?>
                <hr>
                <p class="bg-danger"> PS. Можливо видалення деякіх символів при натискані будь-якої кнопки (фільтрація спец сімволів), краще мишкою виділяти все.</p>
                <textarea style="width: 100%; min-height: 400px;" class=""><?php echo CreateSpriteCss($IconArray, $BaseClass); ?></textarea>
            </div>
        </div>
    </div>
</div>