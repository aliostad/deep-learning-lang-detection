<?php
/**
 * Stores basic layout options to show or not certain web components (for example, wich panels show in the right column)
 * @author Ankso
 */
class Layout
{
    /**
     * Class construct. By default, the class shows all.
     * @param boolean $showLogin True if you want to show the login box.
     * @param boolean $showTs3 True if you want to show the TeamSpeak3 server status box.
     * @param boolean $showWowTbc True if you want to show the WoW TBC server status box.
     * @param boolean $showMinecraft True if you want to show the Minecraft server status box.
     * @param boolean $showArma True if you want to show the ArmA 2 server status box.
     * @param boolean $showSocial True if you want to show the Twitter widget and Google+ widgets.
     * @param boolean $showRecoverPassword True if you want to show the recover password box.
     */
    function __construct(
        $showLogin      = true,
        $showTs3        = true,
        $showWowTbc     = true,
        $showMinecraft  = true,
        $showArma       = true,
        $showSocial    = true,
        $showRecoverPassword = false)
    {
        $this->_layoutConfig = array(
            LAYOUT_SHOW_LOGIN      => $showLogin,
            LAYOUT_SHOW_TS3        => $showTs3,
            LAYOUT_SHOW_WOW_TBC    => $showWowTbc,
            LAYOUT_SHOW_MINECRAFT  => $showMinecraft,
            LAYOUT_SHOW_ARMA       => $showArma,
            LAYOUT_SHOW_SOCIAL     => $showSocial,
            LAYOUT_SHOW_RECOVER_PASSWORD => $showRecoverPassword,
        );
    }
    
    /**
     * Gets a layout option.
     * @param integer $index Wich option to show specified in SharedDefines.php
     * @return boolean The value for that option.
     */
    public function GetLayoutOption($index)
    {
        if ($index < LAYOUT_SHOW_LOGIN || $index >= LAYOUT_OPTIONS_COUNT)
            return false;
        return $this->_layoutConfig[$index];
    }
    
    /**
	 * Set a layout option.
     * @param integer $index Wich option to change specified in SharedDefines.php
     * @param boolean $value The value for that option.
     * @return boolean True on success, else false.
     */
    public function SetLayoutOption($index, $value)
    {
        if ($index < LAYOUT_SHOW_LOGIN || $index >= LAYOUT_OPTIONS_COUNT)
            return false;
        
        if (!is_bool($value))
            return false;
        
        $this->_layoutConfig[$index] = $value;
        return true;
    }
    
    private $_layoutConfig;          // Array with all the layout options.
}
?>