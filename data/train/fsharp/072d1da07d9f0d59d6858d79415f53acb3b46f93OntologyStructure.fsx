
/// Ontology and taxonomy definition, relationship, and interaction


type ``Generically dependent continuant`` = ``Generically dependent continuant``
type ``Independent continuant`` = ``Independent continuant``
type ``Two-dimensional continuant fiat boundary`` = ``Two-dimensional continuant fiat boundary``
type ``Zero-dimensional continuant fiat boundary`` = ``Zero-dimensional continuant fiat boundary``
type ``One-dimensional continuant fiat boundary`` = ``One-dimensional continuant fiat boundary``
type ``Continuant fiat boundary`` =
    {
        ``One-dimensional continuant fiat boundary`` : ``One-dimensional continuant fiat boundary``
        ``Two-dimensional continuant fiat boundary`` : ``Two-dimensional continuant fiat boundary``
        ``Zero-dimensional continuant fiat boundary`` : ``Zero-dimensional continuant fiat boundary``
    }
type Site = Site
type ``Zero-dimensional spatial region`` = ``Zero-dimensional spatial region``
type ``One-dimensional spatial region`` = ``One-dimensional spatial region``
type ``Two-dimensional spatial region`` = ``Two-dimensional spatial region``
type ``Three-dimensional spatial region`` = ``Three-dimensional spatial region``
type ``Continuant spatial region`` =
    {
        ``Zero-dimensional spatial region`` : ``Zero-dimensional spatial region``
        ``One-dimensional spatial region`` : ``One-dimensional spatial region``
        ``Two-dimensional spatial region`` : ``Two-dimensional spatial region``
        ``Three-dimensional spatial region`` : ``Three-dimensional spatial region``
    }
type ``Object aggregate`` = ``Object aggregate``
type Object = Object
type ``Fiat object`` = ``Fiat object``
type ``Material entity`` = 
    {
        ``Object aggregate`` : ``Object aggregate``
        Object : Object
        ``Fiat object`` : ``Fiat object``
    }
type Role = Role
type Function = Function
type Disposition = { Function : Function }
type ``Realizable entity`` = { Disposition : Disposition }
type ``Relational quality`` = ``Relational quality``
type Quality = { ``Relational quality`` : ``Relational quality`` }
type ``Specifically dependent continuant`` = { Quality : Quality }

type Continuant = 
    {
        ``Generically dependent continuant`` : ``Generically dependent continuant``
        ``Independent continuant`` : ``Independent continuant``
        ``Specifically dependent continuant`` : ``Specifically dependent continuant``
    }

type History = History
type ``Process profile`` = ``Process profile``
type Process = { History : History; Profile : ``Process profile`` }
type ``Process boundary`` = ``Process boundary``
type ``Spatiotemporal region`` = ``Spatiotemporal region``
type ``One-dimensional temporal region`` = ``One-dimensional temporal region``
type ``Two-dimensional temporal region`` = ``Two-dimensional temporal region``
type ``Temporal region`` = ``Temporal region``

type Occurant = 
    {
        Process : Process
        ``Process boundary`` : ``Process boundary``
        ``Spatiotemporal region`` : ``Spatiotemporal region``
        ``Temporal region`` : ``Temporal region``
    }

type Entity = 
    { 
        Continuant : Continuant
        Occurant : Occurant
    }

type Thing = { Entity : Entity }






