INSERT INTO `ipb_posts` (`pid`, `append_edit`, `edit_time`, `author_id`, `author_name`, `use_sig`, `use_emo`, `ip_address`, `post_date`, `icon_id`, `post`, `queued`, `topic_id`, `post_title`, `new_topic`, `edit_name`, `post_key`, `post_parent`, `post_htmlstate`, `post_edit_reason`) VALUES

{% for post in posts %}
({{ post.zeta_id }}, 0, NULL, {{ post.user.zeta_id|default:"NULL" }}, '{{ post.username }}', 1, 1, '{{ post.ip_address }}', {{ post.date_posted|date:"U" }}, 0, '{{ post.raw_post_bbcode|linebreaksbr }}', 0, {{ post.thread.zeta_id }}, NULL, 1, NULL, '0', 0, 0, ''){% if not forloop.last %},{% else %};{% endif %}
{% endfor %}

