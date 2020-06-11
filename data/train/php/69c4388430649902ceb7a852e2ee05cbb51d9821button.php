<button type="button" name="btn_back" class="button back" onclick="javascript:location.href='<?php echo url::base()?>admin_news/search/pid/<?php echo $mr['page_id']?>'">
    <span><?php echo Kohana::lang('global_lang.btn_back')?></span>
</button>
<?php if($this->permisController('save')) { ?>
<button type="submit" name="btn_save" class="button save" onclick="javascript:save();">
<span><?php echo Kohana::lang('global_lang.btn_save')?></span>
</button>
<button type="submit" name="btn_save_add" class="button save" onclick="javascript:save('add');">
<span><?php echo Kohana::lang('global_lang.btn_save_add')?></span>
</button>
<?php }//save?>