
package controllers;

import com.avaje.ebean.Ebean;

import controllers.repository.RepositoryFormData;

import models.repository.Repository;

import play.data.Form;

import play.mvc.Controller;
import play.mvc.Result;

import views.html.repository.repository;
import views.html.repository.repositorys;

import java.util.Date;
import java.util.List;

/**
 * @author Manuel de la Peña
 * @generated
 */
public class RepositoryApplication extends Controller {

	public static Result addRepository() {
		Form<RepositoryFormData> form = Form.form(
			RepositoryFormData.class).fill(new Repository().toFormData());

		return ok(repository.render(form));
	}

	public static Result get(Long id) {
		Repository dbRepository = Repository.find.byId(id);

		Form<RepositoryFormData> form = Form.form(
			RepositoryFormData.class).fill(dbRepository.toFormData());

		return ok(repository.render(form));
	}

	public static Result all() {
		List<Repository> repositoryList = Repository.find.all();

		return ok(repositorys.render(repositoryList));
	}

	public static Result submit() {
		Form<RepositoryFormData> formData = Form.form(
			RepositoryFormData.class).bindFromRequest();

		String[] postSubmit = request().body().asFormUrlEncoded().get("submit");

		if (postSubmit == null || postSubmit.length == 0) {
			return badRequest("You must provide a valid action");
		}
		else {
			String action = postSubmit[0];

			if ("edit".equals(action)) {
				return edit(formData);
			}
			else if ("delete".equals(action)) {
				return delete(formData);
			}
			else {
				return badRequest("This action is not allowed");
			}
		}
	}

	public static Result edit(Form<RepositoryFormData> formData) {
		if (formData.hasErrors()) {
			flash("error", "Please correct errors above.");

			return addRepository();
		}
		else {
			RepositoryFormData repositoryFormData = formData.get();

			String id = repositoryFormData.repositoryId;

			long repositoryId = 0;

			if (id != null) {
				repositoryId = Long.valueOf(id);
			}

			Repository repository;

			if (repositoryId > 0) {
				repository = Repository.find.byId(repositoryId);

				repository.setMvccVersion(Long.valueOf(repositoryFormData.mvccVersion));
				repository.setUuid(repositoryFormData.uuid);
				repository.setRepositoryId(Long.valueOf(repositoryFormData.repositoryId));
				repository.setGroupId(Long.valueOf(repositoryFormData.groupId));
				repository.setCompanyId(Long.valueOf(repositoryFormData.companyId));
				repository.setUserId(Long.valueOf(repositoryFormData.userId));
				repository.setUserName(repositoryFormData.userName);
				repository.setCreateDate(new Date(repositoryFormData.createDate));
				repository.setModifiedDate(new Date(repositoryFormData.modifiedDate));
				repository.setClassNameId(Long.valueOf(repositoryFormData.classNameId));
				repository.setName(repositoryFormData.name);
				repository.setDescription(repositoryFormData.description);
				repository.setPortletId(repositoryFormData.portletId);
				repository.setTypeSettings(repositoryFormData.typeSettings);
				repository.setDlFolderId(Long.valueOf(repositoryFormData.dlFolderId));
			}
			else {
				repository = new Repository(repositoryFormData);
			}

			Ebean.save(repository);

			flash("success", "Repository instance created/edited: " + repository);

			return all();
		}
	}

	public static Result delete(Form<RepositoryFormData> formData) {
		RepositoryFormData repositoryFormData = formData.get();

		String id = repositoryFormData.repositoryId;

		long repositoryId = 0;

		if (id != null) {
			repositoryId = Long.valueOf(id);
		}

		Repository repository;

		if (repositoryId > 0) {
			repository = Repository.find.byId(repositoryId);

			Ebean.delete(repository);
		}
		else {
			flash("error", "Cannot delete Repository");
		}

		return all();
	}

}
