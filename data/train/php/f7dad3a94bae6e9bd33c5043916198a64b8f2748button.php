<button type="button" name="btn_back" class="button back" onclick="location.href='<?php echo url::base()?>admin_banner'">
<span><?php echo Kohana::lang('global_lang.btn_back_list')?></span>
</button>
<?php if($this->permisController('save')) { ?>
<button type="button" name="btn_save" class="button save" onclick="javascript:save();">
<span><?php echo Kohana::lang('global_lang.btn_save')?></span>
</button>        
<button type="button" name="btn_save_add" class="button save" onclick="javascript:save('add');">
<span><?php echo Kohana::lang('global_lang.btn_save_add')?></span>
</button>
<?php }//save ?>