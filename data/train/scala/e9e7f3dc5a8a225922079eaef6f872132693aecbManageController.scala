package controllers

import models.Genres
import models.Artists
import models.Albums
import models.Tracks
import models.Countries

object ManageController extends AbstractController {
	def genresPage = withAuth { implicit request =>
	  Ok(views.html.edit.genre.genres())
	}
	
	def artistsPage(genreid: Long) = withAuth { implicit request =>
	  Ok(views.html.edit.artist.artists(genreid, Genres.comboOptions, Countries.comboOptions))
	}
	
	def albumsPage(artistid: Long) = withAuth { implicit request =>
	  Ok(views.html.edit.albums(Albums.byArtist(artistid)))
	}
	
	def tracksPage(albumid: Long) = withAuth { implicit request =>
	  Ok(views.html.edit.tracks(Tracks.byAlbum(albumid)))
	}
	
	def deleteGenre(id: Long) = withAuth { implicit request =>
	  Genres.delete(id)
	  Redirect(routes.ManageController.genresPage)
	}
	
	def deleteArtist(id: Long) = withAuth { implicit request =>
	  Artists.delete(id)
	  Redirect(routes.ManageController.genresPage)
	}
	
	def deleteAlbum(id: Long) = withAuth { implicit request =>
	  Albums.delete(id)
	  Redirect(routes.ManageController.genresPage)
	}
	
	def deleteTrack(id: Long) = withAuth { implicit request =>
	  Tracks.delete(id)
	  Redirect(routes.ManageController.genresPage)
	}
}