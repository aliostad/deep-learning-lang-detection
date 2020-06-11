namespace Gwp.EventStore

open System

type Event = {
  version: int64
  domain: string
  eventKey: string
  eventData: byte array
}

type Cmd =
  | PostEventSeq of PostEvent seq
  | PostEvent of PostEvent
  | ListEvents of ListEvents
  | PutEvent of PutEvent

and PostEvent = {
  domain: string
  eventKey: string
  eventData: byte array
}

and ListEvents = {
  domain: string
  offset: int64
  limit: int64
}

and PutEvent = {
  version: int64
  domain: string
  eventKey: string
  eventData: byte array
}

type Reply =
  | EventPage of EventPage
  | EventNotify of EventNotify
  | UnableToProcess of UnableToProcess

and EventPage = {
  events: Event list
  offset: int64
  count: int64
}

and EventNotify = {
  version: int64
}

and UnableToProcess = {
  reason: string
}
