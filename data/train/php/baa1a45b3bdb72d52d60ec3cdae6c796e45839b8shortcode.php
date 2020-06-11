<?php

include_once(plugin_dir_path(__FILE__) . 'model/partyRepository.php');

function piratePartyShortcode($attributes) {
    $defaultAttributes = array(
        'id' => null,
        'show-all' => false,
        'show-logo' => true,
        'show-native-name' => true,
        'show-memberships' => false,
        'show-website' => true,
        'show-facebook' => true,
        'show-twitter' => true,
        'show-googleplus' => false,
        'show-youtube' => false
    );
    $attributes = shortcode_atts($defaultAttributes, $attributes);
    if ($attributes['show-all']) {
        $attributes['show-logo'] = true;
        $attributes['show-native-name'] = true;
        $attributes['show-memberships'] = true;
        $attributes['show-website'] = true;
        $attributes['show-facebook'] = true;
        $attributes['show-twitter'] = true;
        $attributes['show-googleplus'] = true;
        $attributes['show-youtube'] = true;
    }

    $partyRepository = new PartyRepository();
    $party = $partyRepository->getParty($attributes['id']);

    if ($party === null) {
        return '<p>' . $attributes['id'] . ' ' . __('not found.', 'wp-pirate-parties') . '</p>';
    }

    ob_start();
    include(plugin_dir_path(__FILE__) . 'view/shortcode.php');
    return ob_get_clean();
}

add_shortcode('pirate-party', 'piratePartyShortcode');
