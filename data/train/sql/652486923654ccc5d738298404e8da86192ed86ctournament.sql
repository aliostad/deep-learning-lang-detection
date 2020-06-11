-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
--
-- Author: Michael Werts, mcwerts@gmail.com

DROP DATABASE IF EXISTS tournament;

CREATE DATABASE tournament;

\c tournament;

CREATE TABLE players (
	id SERIAL primary key,
	name TEXT);

CREATE TABLE matches (
	winner INTEGER references players(id),
    loser INTEGER references players(id));

CREATE VIEW win_view(player, wins) AS 
	SELECT winner, count(winner) AS wins FROM matches GROUP BY winner;

CREATE VIeW winx_view(player, name, wins) AS
	SELECT players.id, players.name, COALESCE(win_view.wins, 0)
	FROM players LEFT OUTER JOIN win_view
	ON players.id = win_view.player;

CREATE VIEW loss_view(player, losses) AS 
	SELECT loser, count(loser) AS losses FROM matches GROUP BY loser;

CREATE VIEW lossx_view(player, name, losses) AS
	SELECT players.id, players.name, COALESCE(loss_view.losses, 0)
	FROM players LEFT OUTER JOIN loss_view
	ON players.id = loss_view.player;

CREATE VIEW standings(player, name, wins, losses) AS
	SELECT winx_view.player, winx_view.name, winx_view.wins, 
		(winx_view.wins+lossx_view.losses) AS matches_played
	FROM winx_view JOIN lossx_view 
	ON winx_view.player = lossx_view.player
	ORDER BY wins DESC;
