<?php
require($_SERVER["DOCUMENT_ROOT"]."/bitrix/header.php");
$APPLICATION->SetTitle("Корзина");
$APPLICATION->IncludeComponent(
    "bitrix:sale.basket.basket.line",
    "empty_cart",
    array(
        "PATH_TO_BASKET" => "/personal/cart/",
        "PATH_TO_ORDER" => "/personal/cart/",
        "SHOW_NUM_PRODUCTS" => "Y",
        "SHOW_TOTAL_PRICE" => "Y",
        "SHOW_EMPTY_VALUES" => "Y",
        "SHOW_PRODUCTS" => "Y",
        "SHOW_DELAY" => "N",
        "SHOW_NOTAVAIL" => "N",
        "SHOW_SUBSCRIBE" => "N",
        "SHOW_IMAGE" => "Y",
        "SHOW_PRICE" => "Y",
        "SHOW_SUMMARY" => "Y"
    )
);
require($_SERVER["DOCUMENT_ROOT"]."/bitrix/footer.php");
?>