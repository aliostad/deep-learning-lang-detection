<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>/api/v1</title>
	<style>
		a{
			line-height: 1.5;
			color:#156AEB;
		}
	</style>
</head>
<body>
	<br>
	&nbsp;&nbsp;&nbsp;&nbsp;<a href='/'>Home</a>
	<br>
	<ul>
		<li>
			<a href='/api/v1/households'>/api/v1/households</a><br>
			<ul style='list-style:square'>
				<li><a href='/api/v1/household/1'>/api/v1/household/{id}</a></li>
				<li><a href='/api/v1/household/1/messages'>/api/v1/household/{id}/messages</a></li>
				<li><a href='/api/v1/household/1/tags'>/api/v1/household/{id}/tags</a></li>
				<li>  <a href='/api/v1/household/1/members'>/api/v1/household/{id}/members</a></li>
				<li><a href='/api/v1/household/1/meals'>/api/v1/household/{id}/meals</a></li>
				<li><a href='/api/v1/household/1/events'>/api/v1/household/{id}/events</a></li>
				<li><a href='/api/v1/household/1/todos'>/api/v1/household/{id}/todos</a></li>
				<li><a href='/api/v1/household/1/notifications'>/api/v1/household/{id}/notifications</a></li>
			</ul>
		</li>
		<li>
			<a href='/api/v1/users'>/api/v1/users</a>
			<ul style='list-style:square'>
				<li><a href='/api/v1/user/1'>/api/v1/user/{id}</a></li>
				<li><a href='/api/v1/user/1/picture'>/api/v1/user/{id}/picture</a></li>
				<li><a href='/api/v1/user/1/recipes'>/api/v1/user/{id}/recipes</a></li>
			</ul>
		</li>
		<li><a href='/api/v1/messages'>/api/v1/messages</a></li>
		<li><a href='/api/v1/categories'>/api/v1/categories</a></li>
		<li><a href='/api/v1/unit_of_measure'>/api/v1/units_of_measure</a></li>
		<li><a href='/api/v1/ingredients'>/api/v1/ingredients</a></li>
		<li><a href='/api/v1/recipe_ingredients'>/api/v1/recipe_ingredients</a></li>
		<li><a href='/api/v1/recipes'>/api/v1/recipes</a>
			<ul style='list-style:square'>
				<li><a href='/api/v1/recipe/1'>/api/v1/recipe/{id}</a></li>
				<li><a href='/api/v1/recipe/1/recipe_ingredients'>/api/v1/recipe/{id}/recipe_ingredients</a></li>
				<li><a href='/api/v1/recipe/1/pictures'>/api/v1/recipe/{id}/pictures</a></li>
				<li><a href='/api/v1/recipe/1/categories'>/api/v1/recipe/{id}/categories</a></li>
				<li><a href='/api/v1/recipe/1/tags'>/api/v1/recipe/{id}/tags</a></li>
				<li><a href='/api/v1/recipe/1/reviews'>/api/v1/recipe/{id}/reviews</a></li>
			</ul>
		</li>

		<li><a href='/api/v1/recipe_reviews'>/api/v1/recipe_reviews</a></li>
		<li><a href='/api/v1/meals'>/api/v1/meals</a>
			<ul style='list-style:square'>
				<li><a href='/api/v1/meal/1'>/api/v1/recipe/{id}</a></li>
				<li><a href='/api/v1/meal/1/recipes'>/api/v1/recipe/{id}/recipes</a></li>
				<li><a href='/api/v1/meal/1/tags'>/api/v1/recipe/{id}/tags</a></li>
			</ul>
		</li>
		<li><a href='/api/v1/events'>/api/v1/events</a>
			<ul style='list-style:square'>
				<li><a href='/api/v1/meal/1'>/api/v1/recipe/{id}</a></li>
			</ul>
		</li>
		<li><a href='/api/v1/todos'>/api/v1/todos</a></li>
		<li><a href='/api/v1/documents'>/api/v1/documents</a></li>
		<li><a href='/api/v1/pictures'>/api/v1/pictures</a></li>
		<li><a href='/api/v1/notifications'>/api/v1/notifications</a></li>
	</ul>
</body>
</html>
