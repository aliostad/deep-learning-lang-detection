<?php
/*
Template Name: Homepage
 *
 * @package Themelion
 */
get_header(); 
$show_hero = get_field('show_hero_element');
$show_iconbox = get_field('show_icon_box_element');
$show_quote = get_field('show_quotes_element');
$show_blog_posts = get_field('show_blog_posts');
?>

<?php 

    if($show_hero) { get_template_part( 'content', 'hero' ); }

    if($show_iconbox) { get_template_part( 'content', 'iconbox' ); }

    if($show_blog_posts) { get_template_part( 'content', 'blog-carousel' ); }

    if($show_quote) { get_template_part( 'content', 'quote' ); }

?>

    <div class="portfolio block">
    </div>

<?php get_footer(); ?>