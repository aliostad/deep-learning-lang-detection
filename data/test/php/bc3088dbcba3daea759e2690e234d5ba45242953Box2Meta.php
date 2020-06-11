<?php
namespace Firalabs\Shows\Meta;

/**
 * Box1 meta
 *
 * @author Maxime Beaudoin <firalabs@gmail.com>
 * @package firalabs-tv-show
 *         
 */
class Box2Meta extends AbstractMeta
{

    protected $id = 'firalabs_tv_show_show_box_2';

    protected $metaKeys = array(
        'firalabs_tv_show_box_2_title',
        'firalabs_tv_show_box_2_description',
        'firalabs_tv_show_box_2_link',
        'firalabs_tv_show_box_2_image'
    );

    public function __construct()
    {
        parent::__construct();
        $this->title = __('Box 2', 'firalabs-tv-show');
        
        $this->labels = array(
            'firalabs_tv_show_box_2_title' => __('Title', 'firalabs-tv-show'),
            'firalabs_tv_show_box_2_description' => __('Description', 'firalabs-tv-show'),
            'firalabs_tv_show_box_2_link' => __('Link', 'firalabs-tv-show'),
            'firalabs_tv_show_box_2_image' => __('Image', 'firalabs-tv-show')
        );
    }
}