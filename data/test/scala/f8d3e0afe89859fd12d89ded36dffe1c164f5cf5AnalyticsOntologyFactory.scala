package apps.analytics

import java.io.File
import java.net.URI

import org.semanticweb.owlapi.apibinding.OWLManager
import org.semanticweb.owlapi.model.{IRI, OWLOntology}

object AnalyticsOntologyFactory
{

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    /** The default IRI for the ScalaTion Analytics Ontology 
     */
    val remoteIRI = IRI.create("https://raw.githubusercontent.com/scalation/analytics/master/analytics.owl")

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    /** A local IRI for the ScalaTion Analytics Ontology based on a `File` path.
     */
    def localIRI (file: File) = IRI.create(file.toURI())

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    /** Load an ontology from a given IRI 
     *  @param iri  the IRI of the ontology
     */
    private def load (iri: IRI): OWLOntology =
    {
        val manager  = OWLManager.createOWLOntologyManager()
        manager.loadOntologyFromOntologyDocument(iri)
    } // load

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    /** Load the ScalaTion Analytics Ontology locally from the default file
     *  path. 
     */
    def loadLocal (): OWLOntology =
    {
        load(AnalyticsOntologyFactory.localIRI(new File("../analytics.owl")))
    } // loadLocal

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    /** Load the ScalaTion Analytics Ontology locally from the specified file
     *  path. 
     *   @param file  the file containing the ontology
     */
    def loadLocal (file: File): OWLOntology =
    {
        load(AnalyticsOntologyFactory.localIRI(file))
    } // loadLocal

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    /** Load the ScalaTion Analytics Ontology locally from the default remote
     *  location.
     */
    def loadRemote (): OWLOntology =
    {
        load(AnalyticsOntologyFactory.remoteIRI)
    } // loadRemote

    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    /** Load the ScalaTion Analytics Ontology locally from the specified remote
     *  location.
     *   @param uri  the URI of the remote ontology
     */
    def loadRemote (uri: URI): OWLOntology =
    {
        load(IRI.create(uri))
    } // loadRemote

} // AnalyticsOntology

