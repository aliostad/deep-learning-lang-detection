package org.kostaskougios.idea.projects

import com.intellij.openapi.project.{Project, ProjectManager, ProjectManagerListener}
import org.kostaskougios.idea.compilation.CompilationManager

/**
 * helps other components to manage project events
 *
 * @author	kostas.kougios
 *            Date: 22/07/14
 */
class ProjectsManager(compilationManager: CompilationManager)
{
	private val pm = ProjectManager.getInstance
	pm.addProjectManagerListener(new ProjectManagerListener
	{
		override def projectClosing(project: Project) {
		}

		override def canCloseProject(project: Project) = true

		override def projectClosed(project: Project) {
		}

		override def projectOpened(project: Project) {
			compilationManager.projectOpened(project)
		}
	})

	def projects = pm.getOpenProjects.toList

}
