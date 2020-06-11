<?php
namespace api;
/**
 * <api-request> 
 * 	<api-lines>
 *   <api-line><api-rmethod>GET</api-rmethod><api-base>/api/body/</api-base><api-var>{method}</api-var>?request=<api-var>{url}</api-var></api-line>
 *   <api-var-line><api-var-def>{method}</api-var-def> = <api-var>{class method}</api-var> [&nbsp;&nbsp;| <api-var>{class method}</api-var> ] | all</api-var-line>
 *   <api-var-line><api-var-def>{class method}</api-var-def> = A valid method for this class</api-var-line>
 *  </api-lines>
 * </api-request>
 * 
 * @uses HtmlBodyWrap 
 * @author Will
 * @package \api\body
 *
 */
class Body extends HtmlBodyWrap{
	
}

/**
 * <api-request> 
 * 	<api-lines>
 *   <api-line><api-rmethod>GET</api-rmethod><api-base>/api/head/</api-base><api-var>{method}</api-var>?request=<api-var>{url}</api-var></api-line>
 *   <api-var-line><api-var-def>{method}</api-var-def> = <api-var>{class method}</api-var> [&nbsp;&nbsp;| <api-var>{class method}</api-var> ] | all</api-var-line>
 *   <api-var-line><api-var-def>{class method}</api-var-def> = A valid method for this class</api-var-line>
 *  </api-lines>
 * </api-request>
 * 
 * @uses HtmlHeadWrap
 * @author Will
 * @package api/head
 * @namespace api
 *
 */
class Head extends HtmlHeadWrap{

}

/**
 * <api-request> 
 * 	<api-lines>
 *   <api-line><api-rmethod>GET</api-rmethod><api-base>/api/server/</api-base><api-var>{method}</api-var>?request=<api-var>{url}</api-var></api-line>
 *   <api-var-line><api-var-def>{method}</api-var-def> = <api-var>{class method}</api-var> [&nbsp;&nbsp;| <api-var>{class method}</api-var> ] | all</api-var-line>
 *   <api-var-line><api-var-def>{class method}</api-var-def> = A valid method for this class</api-var-line>
 *  </api-lines>
 * </api-request>
 * 
 * @uses ServerWrap
 * @author Will
 * @package api/server
 * @namespace api
 *
 */
class Server extends ServerWrap{

}

/**
 * <api-request> 
 * 	<api-lines>
 *   <api-line><api-rmethod>GET</api-rmethod><api-base>/api/social/</api-base><api-var>{method}</api-var>?request=<api-var>{url}</api-var></api-line>
 *   <api-var-line><api-var-def>{method}</api-var-def> = <api-var>{class method}</api-var> [&nbsp;&nbsp;| <api-var>{class method}</api-var> ] | all</api-var-line>
 *   <api-var-line><api-var-def>{class method}</api-var-def> = A valid method for this class</api-var-line>
 *  </api-lines>
 * </api-request>
 * 
 * @uses SocialWrap
 * @author Will
 * @package api/social
 * @namespace api
 *
 */
class Social extends SocialWrap{

}

/**
 * <api-request> 
 * 	<api-lines>
 *   <api-line><api-rmethod>GET</api-rmethod><api-base>/api/google/</api-base><api-var>{method}</api-var>?request=<api-var>{url}</api-var></api-line>
 *   <api-var-line><api-var-def>{method}</api-var-def> = <api-var>{class method}</api-var> [&nbsp;&nbsp;| <api-var>{class method}</api-var> ] | all</api-var-line>
 *   <api-var-line><api-var-def>{class method}</api-var-def> = A valid method for this class</api-var-line>
 *  </api-lines>
 * </api-request>
 * 
 * @author Will
 * @package api/google
 * @namespace api
 *
 */
class Google extends GoogleWrap{
	
}

/**
 * 
 * <api-request> 
 * 	<api-lines>
 *   <api-line><api-rmethod>GET</api-rmethod><api-base>/api/moz/</api-base><api-var>{method}</api-var>?request=<api-var>{url}</api-var></api-line>
 *   <api-var-line><api-var-def>{method}</api-var-def> = <api-var>{class method}</api-var> [&nbsp;&nbsp;| <api-var>{class method}</api-var> ] | all</api-var-line>
 *   <api-var-line><api-var-def>{class method}</api-var-def> = A valid method for this class</api-var-line>
 *  </api-lines>
 * </api-request>
 * 
 * @author Will
 * @package api/moz
 * @namespace api
 *
 */
class Moz extends MozWrap{
	
} 

/**
 * <api-request> 
 * 	<api-lines>
 *   <api-line><api-rmethod>GET</api-rmethod><api-base>/api/semrush/</api-base><api-var>{method}</api-var>?request=<api-var>{url}</api-var></api-line>
 *   <api-var-line><api-var-def>{method}</api-var-def> = <api-var>{class method}</api-var> [&nbsp;&nbsp;| <api-var>{class method}</api-var> ] | all</api-var-line>
 *   <api-var-line><api-var-def>{class method}</api-var-def> = A valid method for this class</api-var-line>
 *  </api-lines>
 * </api-request>
 * 
 * @author Will
 * @package api/semrush
 * @namespace api
 *
 */
class SemRush extends SemRushWrap{
	
}

/*
 *
 * <api-request>
 * 	<api-lines>
 *   <api-line><api-rmethod>GET</api-rmethod><api-base>/api/w3c/</api-base><api-var>{method}</api-var>?request=<api-var>{url}</api-var></api-line>
 *   <api-var-line><api-var-def>{method}</api-var-def> = <api-var>{class method}</api-var> [&nbsp;&nbsp;| <api-var>{class method}</api-var> ] | all</api-var-line>
 *   <api-var-line><api-var-def>{class method}</api-var-def> = A valid method for this class</api-var-line>
 *  </api-lines>
 * </api-request>
 *
 * @author Will
 * @package api/w3c
 * @namespace api
 */
class W3c extends W3cWrap{

}
?>