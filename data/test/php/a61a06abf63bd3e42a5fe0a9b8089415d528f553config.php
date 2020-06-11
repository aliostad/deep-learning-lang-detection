<?php
require_once('api.php');
require_once('routes.php');

$session_validator = array("user_id");
$api = new Api($session_validator, true);

/*
Example route
    $myroute = new Route([url], [route request method type (e.g. Route::GET)], [callable (i.e 'foo' for function foo]);
*/

// Initalizing routes for application
$ROUTES = array(
    new Route('/api/groups', Route::GET, array($api, 'getGroups')),
    new Route('/api/groups', Route::POST, array($api, 'addGroup')),
    new Route('/api/groups/:id', Route::GET, array($api, 'getGroup')),
    new Route('/api/groups/:id', Route::PUT, array($api, 'updateGroup')),
    new Route('/api/groups/:id', Route::DELETE, array($api, 'deleteGroup')),
    new Route('/api/groups/:id/permissions', Route::GET, array($api, 'getGroupPermissions')),
    new Route('/api/groups/:id/permissions', Route::POST, array($api, 'addGroupPermissions')),
    new Route('/api/groups/:id/permissions', Route::DELETE, array($api, 'deleteGroupPermissions')),

    new Route('/api/permissions', Route::GET, array($api, 'getPermissions')),
    new Route('/api/permissions', Route::POST, array($api, 'addPermission')),
    new Route('/api/permissions/:id', Route::GET, array($api, 'getPermission')),
    new Route('/api/permissions/:id', Route::PUT, array($api, 'updatePermission')),
    new Route('/api/permissions/:id', Route::DELETE, array($api, 'deletePermission')),

    new Route('/api/machines', Route::GET, array($api, 'getMachines')),
    new Route('/api/machines', Route::POST, array($api, 'addMachine')),
    new Route('/api/machines/:id', Route::GET, array($api, 'getMachine')),
    new Route('/api/machines/:id', Route::PUT, array($api, 'updateMachine')),
    new Route('/api/machines/:id', Route::DELETE, array($api, 'deleteMachine')),
    new Route('/api/machines/:id/supplies', Route::GET, array($api, 'getMachineSupplies')),
    new Route('/api/machines/:id/supplies', Route::POST, array($api, 'addMachineSupplies')),
    new Route('/api/machines/:id/supplies', Route::PUT, array($api, 'updateMachineSupplies')),
    new Route('/api/machines/:id/supplies', Route::DELETE, array($api, 'deleteMachineSupplies')),

    new Route('/api/users', Route::GET, array($api, 'getUsers')),
    new Route('/api/users', Route::POST, array($api, 'addUser')),
    new Route('/api/users/:id', Route::GET, array($api, 'getUser')),
    new Route('/api/users/:id', Route::PUT, array($api, 'updateUser')),
    new Route('/api/users/:id', Route::DELETE, array($api, 'deleteUser')),
    new Route('/api/users/:id/change', Route::PATCH, array($api, 'changePassword')),
    new Route('/api/users/:id/reset', Route::PATCH, array($api, 'resetPassword')),
    new Route('/api/users/:id/permissions', Route::GET, array($api, 'getUserPermissions')),
    new Route('/api/users/:id/permissions', Route::POST, array($api, 'addUserPermissions')),
    new Route('/api/users/:id/permissions', Route::DELETE, array($api, 'deleteUserPermissions')),

    new Route('/api/products', Route::GET, array($api, 'getProducts')),
    new Route('/api/products', Route::POST, array($api, 'addProduct')),
    new Route('/api/products/:id', Route::GET, array($api, 'getProduct')),
    new Route('/api/products/:id', Route::PUT, array($api, 'updateProduct')),
    new Route('/api/products/:id', Route::DELETE, array($api, 'deleteProduct')),

    new Route('/api/teams', Route::GET, array($api, 'getTeams')),
    new Route('/api/teams', Route::POST, array($api, 'addTeam')),
    new Route('/api/teams/:id', Route::GET, array($api, 'getTeam')),
    new Route('/api/teams/:id', Route::PUT, array($api, 'updateTeam')),
    new Route('/api/teams/:id', Route::DELETE, array($api, 'deleteTeam')),
    new Route('/api/teams/:id/members', Route::GET, array($api, 'getTeamMembers')),
    new Route('/api/teams/:id/members', Route::POST, array($api, 'addTeamMembers')),
    new Route('/api/teams/:id/members', Route::DELETE, array($api, 'deleteTeamMembers')),

    new Route('/api/login', Route::POST, array($api, 'loginUser')),
    new Route('/api/logout', Route::GET, array($api, 'logoutUser'))
);
