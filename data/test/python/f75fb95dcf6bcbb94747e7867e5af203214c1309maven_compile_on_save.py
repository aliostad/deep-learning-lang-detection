import sublime, sublime_plugin, os
import subprocess

class MavenCompileOnSave(sublime_plugin.EventListener):

	def on_post_save(self, view):
		folder = view.window().folders()[0]
		os.chdir(folder)
		maven_compile_on_save_settings = view.settings().get('maven_compile_on_save')
		file_extension = view.file_name().split("/")[-1].split(".")[-1]
		if maven_compile_on_save_settings:
			if file_extension in maven_compile_on_save_settings:
				p = subprocess.Popen("mvn compile", stdout=subprocess.PIPE, shell=True)
				print "Maven Compile on Save: Compiling ..."
		else:
			print 'Maven Compile on Save: Project not configured for MavenCOmpileOnSave.  Try setting maven_compile_on_save in project settings'