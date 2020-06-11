package model

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ProjectSuite extends FunSuite {

  test("Same data returns empty delta") {

    val oldProjects = List(project1, project2, project3)

    assert(Project.delta(oldProjects, oldProjects) === Nil)
  }

  test("Modified project is returned in delta") {
    val oldProjects = List(project1, project2, project3)

    val project1New = Project("aNameNew", "cat", "aRepo", List(
      PullRequest(1, "aaUrl", "aaComment"),
      PullRequest(2, "abUrl", "abComment")))

    val newProjects = List(project1New, project2, project3)

    assert(Project.delta(oldProjects, newProjects) === List(project1New))
  }

  test("project with modified PR list is returned in delta") {
    val oldProjects = List(project1, project2, project3)

    val project3New = Project("cName", "cat", "cRepo", List(
      PullRequest(4, "cbUrl", "cbComment"),
      PullRequest(6, "ccUrl", "ccComment")))

    val newProjects = List(project1, project2, project3New)

    assert(Project.delta(oldProjects, newProjects) === List(project3New))
  }

  test("Modified projects are returned in delta") {
    val oldProjects = List(project1, project2, project3)

    val project1New = Project("aNameNew", "cat", "aRepo", List(
      PullRequest(1, "aaUrl", "aaComment"),
      PullRequest(2, "abUrl", "abComment")))

    val project2New = Project("bName", "cat", "bRepo", List(
      PullRequest(3, "baUrl", "baComment"),
      PullRequest(35, "bbUrl", "bbComment")))

    val newProjects = List(project1New, project2New, project3)

    assert(Project.delta(oldProjects, newProjects) === List(project1New, project2New))
  }

  def project1 = Project("aName", "cat", "aRepo", List(
    PullRequest(1, "aaUrl", "aaComment"),
    PullRequest(2, "abUrl", "abComment")))

  def project2 = Project("bName", "cat", "bRepo", List(
    PullRequest(3, "baUrl", "baComment")))

  def project3 = Project("cName", "cat", "cRepo", List(
    PullRequest(4, "caUrl", "caComment"),
    PullRequest(4, "cbUrl", "cbComment"),
    PullRequest(6, "ccUrl", "ccComment")))

}