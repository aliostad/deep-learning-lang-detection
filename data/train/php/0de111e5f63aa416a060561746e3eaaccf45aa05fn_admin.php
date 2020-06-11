<?php class fn_admin {

var $db;
var $id;
var $html;

function showTable($type,$module,$title,$name,$table,$captions,$fields,$widths,$buttons,$order) {
    

    $this->type=$type;
    $this->name=$name;
    $this->module=$module;
    $this->title=$title;
    $this->table=$table;
    $this->order=$order;
    $this->fields_ms=explode(";",$fields);
    $this->captions_ms=explode(";",$captions);
    $this->buttons_ms=explode(";",$buttons);
    $this->widths_ms=explode(";",$widths);

	$show="";
    if (($this->type=="main") or (isset($this->sub_id))) { 
        $show.=$this->showHeader();
        $show.=$this->showBox();
        $show.=$this->showFooter();
    }
    return $show;


}


function showHeader() {
    
	$show="";
    $show.=	"<div class=\"clCaptionText\">";
	$show.=		$this->title;
	$show.=	"</div>";
    $show.= "<div class=\"clHiddenInputs\">";
	$show.=	"<input type=\"hidden\" name=\"".$this->type."_input_id\"  id=\"".$this->type."_input_id\" value=\"\">";
	$show.=	"<input type=\"hidden\" name=\"".$this->type."\"  id=\"".$this->type."_input_type\" value=\"".$this->type."\">";
	$show.=	"<input type=\"hidden\" name=\"".$this->type."\"  id=\"".$this->type."_input_tbl\" value=\"".$this->table."\">";
	$show.=	"<input type=\"hidden\" name=\"".$this->type."\"  id=\"".$this->type."_input_mdl\" value=\"".$this->module."\">";
	$show.=	"</div>";
   	$show.="<div class=\"clTextLine\">";
	$show.=	"<div class=\"clSomeText\">";
    return $show;  
    
}

function showFooter() {
    
	$show="";
	$show.=	"</div>";
	$show.="</div>";
    return $show;
}


function showBox() {
    
	$show="";
        if (isset($this->db)) {
        switch ($this->type) {    
    	case 'main':
           $this->sql="SELECT * FROM `".$this->table."` WHERE (1=1) ORDER by ".$this->order."";
        break;
        case 'sub':
           $this->sql="SELECT * FROM `".$this->table."` WHERE (".$this->connect."=".$this->sub_id.") ORDER by ".$this->order."";
        break;
    	}
        $this->res=mysql_query($this->sql,$this->db);
        if (isset($this->res)) {
          if ($this->res) {
            $this->showSet();
            $show.=$this->showPages();
         	$this->rows_count=mysql_num_rows($this->res);
        	if ($this->rows_count>0) {
            $show.= "<div class=\"clTblBox\"><ul id=\"id".$this->name."_ul\" class=\"cl".$this->name."_ul\">";
        		while($this->row=mysql_fetch_array($this->res)) {
  		         if (isset($this->row['id'])) {
  		            $show.=$this->showLine();
                 }
        		}
        	$show.=	"</ul></div>";
    	    }
            $show.=$this->showLimit();
          }
        }
    }
    return $show;
    
}

function showSet() {

	if (isset($_SESSION[$this->type.':list_now'])) {	
   	    $this->list_now=$_SESSION[$this->type.':list_now'];
    } else {
	    $this->list_now=1;		
    }
	if (isset($_SESSION[$this->type.':row_max']))  {
	    $this->row_max=$_SESSION[$this->type.':row_max'];		
    } else {
	    $this->row_max=10;		
    }

	$this->row_count_all=mysql_num_rows($this->res);
	$this->list_count=ceil($this->row_count_all/$this->row_max);
	
	if ($this->list_now > $this->list_count) 	{   $this->list_now = $this->list_count;	}
	if ($this->list_now < 1) 					{  	$this->list_now = 1;					}
		
	$this->limit=($this->list_now-1)*$this->row_max;
	if ($this->limit<0) 						{ 	$this->limit=0; 						}
	$limit=$this->limit;
	$row_max=$this->row_max;
	
	$_SESSION[$this->type.':list_now']=$this->list_now;
	$_SESSION[$this->type.':row_max']=$this->row_max;

	$this->sql.=" LIMIT {$this->limit},{$this->row_max}";
	$this->res=mysql_query($this->sql,$this->db);
	$this->row_count_now=mysql_num_rows($this->res);

}

function showPages() {

	$show="<div class=\"clTblBox\" style=\"margin-left:40px;\">";
	$show.="<table align=\"center\" border=\"0\" cellpadding=\"3\" cellspacing=\"0\" width=\"700px\">";
	$show.=	"<tr>";
	$show.=		"<td align=\"left\">";
	if ($this->list_now>1) {
		$show.=			"<div class=\"clLinkList\"><a onClick=\"".$this->type."_list_prev();\" href=\"#de\">Ïðåäûäóùàÿ</a></div>";
	} else {
		$show.=			"<div class=\"clLinkList\">Ïðåäûäóùàÿ</div>";
	}
	$show.=		"</td>";
	$show.=		"<td align=\"center\">";
	$show.=			"<div class=\"clTextList\">Ñòðàíèöà <b>".$this->list_now."</b> èç <b>".$this->list_count."</b>, ïîêàçàíû <b>".$this->row_count_now."</b> èç <b>".$this->row_count_all."</b></div>";
	$show.=		"</td>";
	$show.=		"<td align=\"right\">";
	if ($this->list_now<$this->list_count) {
		$show.=			"<div class=\"clLinkList\"><a onClick=\"".$this->type."_list_next();\" href=\"#de\">Ñëåäóþùàÿ</a></div>";
	} else {
		$show.=			"<div class=\"clLinkList\">Ñëåäóþùàÿ</div>";
	}
	$show.=		"</td>";
	$show.=	"</tr>";
	$show.="</table>";
	$show.=	"</div>";
	return $show;

}

function showLimit() {

	$show="<div class=\"clTblBox\" style=\"margin-left:40px;\">";
	$show.="<table align=\"center\" border=\"0\" cellpadding=\"3\" cellspacing=\"0\" width=\"700px\">";
	$show.=	"<tr>";
	$show.=		"<td align=\"left\">";
	$show.=			"<span class=\"clTextList\">Âûâîäèòü ïî </div>";
	if ($this->row_max!=5) {
		$show.=			"<span class=\"clLinkList\"><a onClick=\"".$this->type."_limit_five();\" href=\"#de\">5</a></div>";
	} else {
		$show.=			"<span class=\"clLinkList\">5</div>";
	}
	$show.=			"<span class=\"clTextList\"> | </div>";
	if ($this->row_max!=10) {
		$show.=			"<span class=\"clLinkList\"><a onClick=\"".$this->type."_limit_ten();\" href=\"#de\">10</a></div>";
	} else {
		$show.=			"<span class=\"clLinkList\">10</div>";
	}
	$show.=			"<span class=\"clTextList\"> | </div>";
	if ($this->row_max!=20) {
		$show.=			"<span class=\"clLinkList\"><a onClick=\"".$this->type."_limit_twenty();\" href=\"#de\">20</a></div>";
	} else {
		$show.=			"<span class=\"clLinkList\">20</div>";
	}
	$show.=			"<span class=\"clTextList\"> | </div>";
	if ($this->row_max!=50) {
		$show.=			"<span class=\"clLinkList\"><a onClick=\"".$this->type."_limit_fivty();\" href=\"#de\">50</a></div>";
	} else {
		$show.=			"<span class=\"clLinkList\">50</div>";
	}
	$show.=			"<span class=\"clTextList\"> ïîçèöèé íà ñòðàíèöå </div>";
	$show.=		"</td>";
	$show.=	"</tr>";
	$show.="</table>";
	$show.=	"</div>";
	return $show;

}


function showLine() {
    
	$show="";
           		  $this->id=$this->row['id'];
                  $show.="<li id=\"".$this->name."_li_".$this->id."\" onMouseOver=\"".$this->type."_over(".$this->id.");\"  onMouseOut=\"".$this->type."_leave(".$this->id.");\">";
                  $show.="<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">";
                  $show.="<tr>";
                  $show.=$this->showFields();
                  $show.="<td></td>";
                  $show.=$this->showButtons();
                  $show.="</tr>";
                  $show.="</table>";
                  $show.="</li>";
    return $show;
    
}


function showFields() {

    $show="";
    $ndx=0;
                  foreach ($this->fields_ms as $field) {
                   if (isset($this->row[$field])) {
                    $this->line=strval($this->row[$field]);
                    $this->len=ceil($this->widths_ms[$ndx]/10);
                    if (strlen($this->line)>$this->len) {   $this->line=substr($this->line,0,($this->len-2))."...";  }
                    $show.="<td width=\"".$this->widths_ms[$ndx]."\">";
                    $show.="<div class=\"clPanelLink\">";
                    $show.="<a href=\"#de\" onClick=\"".$this->type."_open();\">";
                    $show.=$this->line;
                    $show.="</a>";
                    $show.="</div>";
                    $show.="</td>";
                    $ndx++;
                   }
                  }
    return $show;
}

function showButtons() {
    
    $show="";
    $ndx=0;
                 foreach ($this->buttons_ms as $btn) {
                    $show.="<td width=\"30px\">";
                    $show.="<a style=\"display:none;\" href=\"#de\"  class=\"btn_".$this->type."_".$btn."\" id=\"btn_".$this->type."_".$btn."_".$this->id."\">";
                    $show.="<img class=\"clIcons\" src=\"modules/".$this->module."/img/ico_".$btn.".png\">";
                    $show.="</a>";
                    $show.="</td>";
                  }
    return $show;
}

} ?>