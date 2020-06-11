<?if(!$modifiing_billing_address):?>
<h3><?= Kohana::lang('pokladna.address-changed')?></h3>
<div>
<label for="save_address_update"><?= Kohana::lang('pokladna.save_address_update')?></label>
<input type="radio" id="save_address_update" name="save_address" value="update" <?= $new_address ? '' : 'checked="checked"'?>/>
<label for="save_address_new"><?= Kohana::lang('pokladna.save_address_new')?></label>
<input type="radio" id="save_address_new" name="save_address" value="new" <?= $new_address ?  'checked="checked"' : ''?>/>
</div>
<?else:?>
<input type="hidden" name="save_address" value="new">
<?endif;?>