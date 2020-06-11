namespace PodFul.Library.IntegrationTests

open Jabberwocky.Toolkit.Assembly
open Jabberwocky.Toolkit.IO
open NUnit.Framework
open PodFul.Library
open PodFul.TestSupport
open System.Reflection
open System

type Feed_IntergrationTests() = 

    let workingDirectory = @"C:\Projects\PodFul\PodFul.Library.IntegrationTests\Test\Feed_IntergrationTests\";

    [<SetUp>]
    member public this.SetupBeforeEachTest() =
        DirectoryOperations.EnsureDirectoryIsEmpty(workingDirectory)

    [<Test>]
    member public this.``Two different feed records are equal because of same feed URL.``() =
        let inputPath = workingDirectory + "RSSFile.rss";
        Assembly.GetExecutingAssembly().CopyEmbeddedResourceToFile("RSSFile.rss", inputPath)

        let feed1 = Setup.createTestFeedWithDirectoryPath inputPath "DirectoryPath1"
        let feed2 = Setup.createTestFeedWithDirectoryPath inputPath "DirectoryPath2"

        Assert.AreEqual(true, (feed1 = feed2))

    [<Test>]
    member public this.``Two different feed records are not equal because of different feed URLs.``() =
        let inputPath1 = workingDirectory + "podcast1.rss";
        Assembly.GetExecutingAssembly().CopyEmbeddedResourceToFile("RSSFile.rss", inputPath1)

        let inputPath2 = workingDirectory + "podcast2.rss";
        Assembly.GetExecutingAssembly().CopyEmbeddedResourceToFile("RSSFile.rss", inputPath2)

        let feed1 = Setup.createTestFeedWithDirectoryPath inputPath1 "DirectoryPath1"
        let feed2 = Setup.createTestFeedWithDirectoryPath inputPath2 "DirectoryPath2"

        Assert.AreEqual(false, (feed1 = feed2))