<?php
namespace Firalabs\Shows\Meta;

/**
 * Box1 meta
 *
 * @author Maxime Beaudoin <firalabs@gmail.com>
 * @package firalabs-tv-show
 *         
 */
class Box4Meta extends AbstractMeta
{

    protected $id = 'firalabs_tv_show_show_box_4';

    protected $metaKeys = array(
        'firalabs_tv_show_box_4_title',
        'firalabs_tv_show_box_4_description',
        'firalabs_tv_show_box_4_link',
        'firalabs_tv_show_box_4_image'
    );

    public function __construct()
    {
        parent::__construct();
        $this->title = __('Box 4', 'firalabs-tv-show');
        
        $this->labels = array(
            'firalabs_tv_show_box_4_title' => __('Title', 'firalabs-tv-show'),
            'firalabs_tv_show_box_4_description' => __('Description', 'firalabs-tv-show'),
            'firalabs_tv_show_box_4_link' => __('Link', 'firalabs-tv-show'),
            'firalabs_tv_show_box_4_image' => __('Image', 'firalabs-tv-show')
        );
    }
}