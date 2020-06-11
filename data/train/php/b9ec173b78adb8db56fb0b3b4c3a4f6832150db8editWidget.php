<?php

$selectTableHeading = isset($WidgetSettings->tableHeading) ? $WidgetSettings->tableHeading : '';
$selectShowQty = isset($WidgetSettings->showQty) ? $WidgetSettings->showQty : '';
$selectShowName = isset($WidgetSettings->showName) ? $WidgetSettings->showName : '';
$selectShowBarcode = isset($WidgetSettings->showBarcode) ? $WidgetSettings->showBarcode : '';
$selectShowModel = isset($WidgetSettings->showModel) ? $WidgetSettings->showModel : '';
$selectShowTax = isset($WidgetSettings->showTax) ? $WidgetSettings->showTax : '';
$selectShowPrice = isset($WidgetSettings->showPrice) ? $WidgetSettings->showPrice : '';
$selectShowPriceTax = isset($WidgetSettings->showPriceTax) ? $WidgetSettings->showPriceTax : '';
$selectShowTotal = isset($WidgetSettings->showTotal) ? $WidgetSettings->showTotal : '';
$selectShowTotalTax = isset($WidgetSettings->showTotalTax) ? $WidgetSettings->showTotalTax : '';
$selectShowExtraInfo = isset($WidgetSettings->showExtraInfo) ? $WidgetSettings->showExtraInfo : '';

$TableHeadingCheckbox = '<input type="checkbox" name="tableHeading" value="1"' . ($selectTableHeading === true ? ' checked=checked' : '') . '>';
$ShowQtyCheckbox = '<input type="checkbox" name="showQty" value="1"' . ($selectShowQty === true ? ' checked=checked' : '') . '>';
$ShowNameCheckbox = '<input type="checkbox" name="showName" value="1"' . ($selectShowName === true ? ' checked=checked' : '') . '>';
$ShowBarcodeCheckbox = '<input type="checkbox" name="showBarcode" value="1"' . ($selectShowBarcode === true ? ' checked=checked' : '') . '>';
$ShowModelCheckbox = '<input type="checkbox" name="showModel" value="1"' . ($selectShowModel === true ? ' checked=checked' : '') . '>';
$ShowTaxCheckbox = '<input type="checkbox" name="showTax" value="1"' . ($selectShowTax === true ? ' checked=checked' : '') . '>';
$ShowPriceCheckbox = '<input type="checkbox" name="showPrice" value="1"' . ($selectShowPrice === true ? ' checked=checked' : '') . '>';
$ShowPriceTaxCheckbox = '<input type="checkbox" name="showPriceTax" value="1"' . ($selectShowPriceTax === true ? ' checked=checked' : '') . '>';
$ShowTotalCheckbox = '<input type="checkbox" name="showTotal" value="1"' . ($selectShowTotal === true ? ' checked=checked' : '') . '>';
$ShowTotalTaxCheckbox = '<input type="checkbox" name="showTotalTax" value="1"' . ($selectShowTotalTax === true ? ' checked=checked' : '') . '>';
$ShowExtraInfoCheckbox = '<input type="checkbox" name="showExtraInfo" value="1"' . ($selectShowExtraInfo === true ? ' checked=checked' : '') . '>';

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array(
			'colspan' => 2,
			'text'    => '<b> Invoice Listing Products Widget Properties</b>'
		)
	)
));

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Table Heading:'),
		array('text' => $TableHeadingCheckbox)
	)
));

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Qty column:'),
		array('text' => $ShowQtyCheckbox)
	)
));

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Name column:'),
		array('text' => $ShowNameCheckbox)
	)
));

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Barcode column:'),
		array('text' => $ShowBarcodeCheckbox)
	)
));

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Model column:'),
		array('text' => $ShowModelCheckbox)
	)
));

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Tax column:'),
		array('text' => $ShowTaxCheckbox)
	)
));

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Price column:'),
		array('text' => $ShowPriceCheckbox)
	)
));
$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Price with Tax Included column:'),
		array('text' => $ShowPriceTaxCheckbox)
	)
));
$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Total column:'),
		array('text' => $ShowTotalCheckbox)
	)
));
$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Total with Tax Included column:'),
		array('text' => $ShowTotalTaxCheckbox)
	)
));

$WidgetSettingsTable->addBodyRow(array(
	'columns' => array(
		array('text' => 'Show Extra info like reservation data Included column:'),
		array('text' => $ShowExtraInfoCheckbox)
	)
));


