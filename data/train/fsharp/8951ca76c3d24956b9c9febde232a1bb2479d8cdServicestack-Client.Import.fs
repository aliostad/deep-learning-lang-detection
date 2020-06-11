namespace Fable.Import.Servicestack
open System
open System.Text.RegularExpressions
open Fable.Core
open Fable.Import.JS
open Fable.PowerPack.Fetch
open Fable.Import.Browser

type [<AllowNullLiteral>] IReturnVoid =
    interface end

and [<AllowNullLiteral>] IReturn<'T> =
    interface end

and [<AllowNullLiteral>] [<Import("*","ResponseStatus")>] ResponseStatus() =
    member __.errorCode with get(): string = jsNative and set(v: string): unit = jsNative
    member __.message with get(): string = jsNative and set(v: string): unit = jsNative
    member __.stackTrace with get(): string = jsNative and set(v: string): unit = jsNative
    member __.errors with get(): ResizeArray<ResponseError> = jsNative and set(v: ResizeArray<ResponseError>): unit = jsNative
    member __.meta with get(): obj = jsNative and set(v: obj): unit = jsNative

and [<AllowNullLiteral>] [<Import("*","ResponseError")>] ResponseError() =
    member __.errorCode with get(): string = jsNative and set(v: string): unit = jsNative
    member __.fieldName with get(): string = jsNative and set(v: string): unit = jsNative
    member __.message with get(): string = jsNative and set(v: string): unit = jsNative
    member __.meta with get(): obj = jsNative and set(v: obj): unit = jsNative

and [<AllowNullLiteral>] [<Import("*","ErrorResponse")>] ErrorResponse() =
    member __.responseStatus with get(): ResponseStatus = jsNative and set(v: ResponseStatus): unit = jsNative

and [<AllowNullLiteral>] IResolver =
    abstract tryResolve: Function: obj -> obj

and [<AllowNullLiteral>] [<Import("*","NewInstanceResolver")>] NewInstanceResolver() =
    interface IResolver with
        member __.tryResolve(Function: obj): obj = jsNative
    member __.tryResolve(ctor: ObjectConstructor): obj = jsNative

and [<AllowNullLiteral>] [<Import("*","SingletonInstanceResolver")>] SingletonInstanceResolver() =
    interface IResolver with
        member __.tryResolve(Function: obj): obj = jsNative
    member __.tryResolve(ctor: ObjectConstructor): obj = jsNative

and [<AllowNullLiteral>] ServerEventMessage =
    abstract ``type``: (* TODO StringEnum ServerEventConnect | ServerEventHeartbeat | ServerEventJoin | ServerEventLeave | ServerEventUpdate | ServerEventMessage *) string with get, set
    abstract eventId: float with get, set
    abstract channel: string with get, set
    abstract data: string with get, set
    abstract selector: string with get, set
    abstract json: string with get, set
    abstract op: string with get, set
    abstract target: string with get, set
    abstract cssSelector: string with get, set
    abstract body: obj with get, set
    abstract meta: obj with get, set

and [<AllowNullLiteral>] ServerEventCommand =
    inherit ServerEventMessage
    abstract userId: string with get, set
    abstract displayName: string with get, set
    abstract channels: string with get, set
    abstract profileUrl: string with get, set

and [<AllowNullLiteral>] ServerEventConnect =
    inherit ServerEventCommand
    abstract id: string with get, set
    abstract unRegisterUrl: string with get, set
    abstract heartbeatUrl: string with get, set
    abstract updateSubscriberUrl: string with get, set
    abstract heartbeatIntervalMs: float with get, set
    abstract idleTimeoutMs: float with get, set

and [<AllowNullLiteral>] ServerEventHeartbeat =
    inherit ServerEventCommand


and [<AllowNullLiteral>] ServerEventJoin =
    inherit ServerEventCommand


and [<AllowNullLiteral>] ServerEventLeave =
    inherit ServerEventCommand


and [<AllowNullLiteral>] ServerEventUpdate =
    inherit ServerEventCommand


and [<AllowNullLiteral>] IReconnectServerEventsOptions =
    abstract url: string option with get, set
    abstract onerror: Func<obj, unit> option with get, set
    abstract onmessage: Func<obj, unit> option with get, set
    abstract error: Error option with get, set

and ReadyState =
    | CONNECTING = 0
    | OPEN = 1
    | CLOSED = 2

and [<AllowNullLiteral>] IEventSourceStatic =
    inherit EventTarget
    abstract url: string with get, set
    abstract withCredentials: bool with get, set
    abstract CONNECTING: ReadyState with get, set
    abstract OPEN: ReadyState with get, set
    abstract CLOSED: ReadyState with get, set
    abstract readyState: ReadyState with get, set
    abstract onopen: Function with get, set
    abstract onmessage: Func<IOnMessageEvent, unit> with get, set
    abstract onerror: Function with get, set
    abstract close: Func<unit, unit> with get, set
    [<Emit("new $0($1...)")>] abstract Create: url: string * ?eventSourceInitDict: IEventSourceInit -> IEventSourceStatic

and [<AllowNullLiteral>] IEventSourceInit =
    abstract withCredentials: bool option with get, set

and [<AllowNullLiteral>] IOnMessageEvent =
    abstract data: string with get, set

and [<AllowNullLiteral>] IEventSourceOptions =
    abstract channels: string option with get, set
    abstract handlers: obj option with get, set
    abstract receivers: obj option with get, set
    abstract onException: Function option with get, set
    abstract onReconnect: Function option with get, set
    abstract onTick: Function option with get, set
    abstract resolver: IResolver option with get, set
    abstract validate: Func<ServerEventMessage, bool> option with get, set
    abstract heartbeatUrl: string option with get, set
    abstract unRegisterUrl: string option with get, set
    abstract updateSubscriberUrl: string option with get, set
    abstract heartbeatIntervalMs: float option with get, set
    abstract heartbeat: float option with get, set

and [<AllowNullLiteral>] [<Import("*","ServerEventsClient")>] ServerEventsClient(baseUrl: string, channels: ResizeArray<string>, ?options: IEventSourceOptions, ?eventSource: IEventSourceStatic) =
    member __.channels with get(): ResizeArray<string> = jsNative and set(v: ResizeArray<string>): unit = jsNative
    member __.options with get(): IEventSourceOptions = jsNative and set(v: IEventSourceOptions): unit = jsNative
    member __.eventSource with get(): IEventSourceStatic = jsNative and set(v: IEventSourceStatic): unit = jsNative
    member __.UnknownChannel with get(): string = jsNative and set(v: string): unit = jsNative
    member __.eventStreamUri with get(): string = jsNative and set(v: string): unit = jsNative
    member __.updateSubscriberUrl with get(): string = jsNative and set(v: string): unit = jsNative
    member __.connectionInfo with get(): ServerEventConnect = jsNative and set(v: ServerEventConnect): unit = jsNative
    member __.serviceClient with get(): JsonServiceClient = jsNative and set(v: JsonServiceClient): unit = jsNative
    member __.stopped with get(): bool = jsNative and set(v: bool): unit = jsNative
    member __.resolver with get(): IResolver = jsNative and set(v: IResolver): unit = jsNative
    member __.listeners with get(): obj = jsNative and set(v: obj): unit = jsNative
    member __.EventSource with get(): IEventSourceStatic = jsNative and set(v: IEventSourceStatic): unit = jsNative
    member __.withCredentials with get(): bool = jsNative and set(v: bool): unit = jsNative
    member __.onMessage with get(): Func<IOnMessageEvent, unit> = jsNative and set(v: Func<IOnMessageEvent, unit>): unit = jsNative
    member __.onError with get(): Func<obj, unit> = jsNative and set(v: Func<obj, unit>): unit = jsNative
    member __.getEventSourceOptions(): obj = jsNative
    member __.reconnectServerEvents(?opt: IReconnectServerEventsOptions): IEventSourceStatic = jsNative
    member __.start(): obj = jsNative
    member __.stop(): Promise<unit> = jsNative
    member __.invokeReceiver(r: obj, cmd: string, el: Element, request: ServerEventMessage, name: string): unit = jsNative
    member __.hasConnected(): bool = jsNative
    member __.registerHandler(name: string, fn: Function): obj = jsNative
    member __.setResolver(resolver: IResolver): obj = jsNative
    member __.registerReceiver(receiver: obj): obj = jsNative
    member __.registerNamedReceiver(name: string, receiver: obj): obj = jsNative
    member __.unregisterReceiver(?name: string): obj = jsNative
    member __.updateChannels(channels: ResizeArray<string>): unit = jsNative
    member __.update(subscribe: U2<string, ResizeArray<string>>, unsubscribe: U2<string, ResizeArray<string>>): unit = jsNative
    member __.addListener(eventName: string, handler: Func<ServerEventMessage, unit>): obj = jsNative
    member __.removeListener(eventName: string, handler: Func<ServerEventMessage, unit>): obj = jsNative
    member __.raiseEvent(eventName: string, msg: ServerEventMessage): unit = jsNative
    member __.getConnectionInfo(): ServerEventConnect = jsNative
    member __.getSubscriptionId(): string = jsNative
    member __.updateSubscriber(request: UpdateEventSubscriber): Promise<obj> = jsNative
    member __.subscribeToChannels([<ParamArray>] channels: string[]): Promise<unit> = jsNative
    member __.unsubscribeFromChannels([<ParamArray>] channels: string[]): Promise<unit> = jsNative
    member __.getChannelSubscribers(): Promise<ResizeArray<ServerEventUser>> = jsNative
    member __.toServerEventUser(map: obj): ServerEventUser = jsNative

and [<AllowNullLiteral>] IReceiver =
    abstract noSuchMethod: selector: string * message: obj -> obj

and [<AllowNullLiteral>] [<Import("*","ServerEventReceiver")>] ServerEventReceiver() =
    interface IReceiver with
        member __.noSuchMethod(selector: string, message: obj): obj = jsNative
    member __.client with get(): ServerEventsClient = jsNative and set(v: ServerEventsClient): unit = jsNative
    member __.request with get(): ServerEventMessage = jsNative and set(v: ServerEventMessage): unit = jsNative

and [<AllowNullLiteral>] [<Import("*","UpdateEventSubscriber")>] UpdateEventSubscriber() =
    interface IReturn<UpdateEventSubscriberResponse>
    member __.id with get(): string = jsNative and set(v: string): unit = jsNative
    member __.subscribeChannels with get(): ResizeArray<string> = jsNative and set(v: ResizeArray<string>): unit = jsNative
    member __.unsubscribeChannels with get(): ResizeArray<string> = jsNative and set(v: ResizeArray<string>): unit = jsNative
    member __.getTypeName(): string = jsNative

and [<AllowNullLiteral>] [<Import("*","UpdateEventSubscriberResponse")>] UpdateEventSubscriberResponse() =
    member __.responseStatus with get(): ResponseStatus = jsNative and set(v: ResponseStatus): unit = jsNative

and [<AllowNullLiteral>] [<Import("*","GetEventSubscribers")>] GetEventSubscribers() =
    interface IReturn<obj []>
    member __.channels with get(): ResizeArray<string> = jsNative and set(v: ResizeArray<string>): unit = jsNative
    member __.getTypeName(): string = jsNative

and [<AllowNullLiteral>] [<Import("*","ServerEventUser")>] ServerEventUser() =
    member __.userId with get(): string = jsNative and set(v: string): unit = jsNative
    member __.displayName with get(): string = jsNative and set(v: string): unit = jsNative
    member __.profileUrl with get(): string = jsNative and set(v: string): unit = jsNative
    member __.channels with get(): ResizeArray<string> = jsNative and set(v: ResizeArray<string>): unit = jsNative
    member __.meta with get(): obj = jsNative and set(v: obj): unit = jsNative

and [<AllowNullLiteral>] [<Import("*","HttpMethods")>] HttpMethods() =
    member __.Get with get(): string = jsNative and set(v: string): unit = jsNative
    member __.Post with get(): string = jsNative and set(v: string): unit = jsNative
    member __.Put with get(): string = jsNative and set(v: string): unit = jsNative
    member __.Delete with get(): string = jsNative and set(v: string): unit = jsNative
    member __.Patch with get(): string = jsNative and set(v: string): unit = jsNative
    member __.Head with get(): string = jsNative and set(v: string): unit = jsNative
    member __.Options with get(): string = jsNative and set(v: string): unit = jsNative
    member __.hasRequestBody with get(): Func<string, bool> = jsNative and set(v: Func<string, bool>): unit = jsNative

and [<AllowNullLiteral>] IRequestFilterOptions =
    abstract url: string with get, set

and [<AllowNullLiteral>] Cookie =
    abstract name: string with get, set
    abstract value: string with get, set
    abstract path: string with get, set
    abstract domain: string option with get, set
    abstract expires: DateTime option with get, set
    abstract httpOnly: bool option with get, set
    abstract secure: bool option with get, set
    abstract sameSite: string option with get, set

and [<AllowNullLiteral>] [<Import("*","GetAccessTokenResponse")>] GetAccessTokenResponse() =
    member __.accessToken with get(): string = jsNative and set(v: string): unit = jsNative
    member __.responseStatus with get(): ResponseStatus = jsNative and set(v: ResponseStatus): unit = jsNative

and [<AllowNullLiteral>] [<Import("JsonServiceClient","servicestack-client")>] JsonServiceClient(baseUrl: string) =
    member __.baseUrl with get(): string = jsNative and set(v: string): unit = jsNative
    member __.replyBaseUrl with get(): string = jsNative and set(v: string): unit = jsNative
    member __.oneWayBaseUrl with get(): string = jsNative and set(v: string): unit = jsNative
    member __.mode with get(): RequestMode = jsNative and set(v: RequestMode): unit = jsNative
    member __.credentials with get(): RequestCredentials = jsNative and set(v: RequestCredentials): unit = jsNative
    member __.headers with get(): Headers = jsNative and set(v: Headers): unit = jsNative
    member __.userName with get(): string = jsNative and set(v: string): unit = jsNative
    member __.password with get(): string = jsNative and set(v: string): unit = jsNative
    member __.bearerToken with get(): string = jsNative and set(v: string): unit = jsNative
    member __.refreshToken with get(): string = jsNative and set(v: string): unit = jsNative
    member __.refreshTokenUri with get(): string = jsNative and set(v: string): unit = jsNative
    member __.requestFilter with get(): Func<Request, IRequestFilterOptions, unit> = jsNative and set(v: Func<Request, IRequestFilterOptions, unit>): unit = jsNative
    member __.responseFilter with get(): Func<Response, unit> = jsNative and set(v: Func<Response, unit>): unit = jsNative
    member __.exceptionFilter with get(): Func<Response, obj, unit> = jsNative and set(v: Func<Response, obj, unit>): unit = jsNative
    member __.onAuthenticationRequired with get(): Func<unit, Promise<obj>> = jsNative and set(v: Func<unit, Promise<obj>>): unit = jsNative
    member __.manageCookies with get(): bool = jsNative and set(v: bool): unit = jsNative
    member __.cookies with get(): obj = jsNative and set(v: obj): unit = jsNative
    member __.toBase64 with get(): Func<string, string> = jsNative and set(v: Func<string, string>): unit = jsNative
    member __.setCredentials(userName: string, password: string): unit = jsNative
    member __.setBearerToken(token: string): unit = jsNative
    member __.get(request: U2<IReturn<'T>, string>, ?args: obj): Promise<'T> = jsNative
    member __.delete(request: U2<IReturn<'T>, string>, ?args: obj): Promise<'T> = jsNative
    member __.post(request: IReturn<'T>, ?args: obj): Promise<'T> = jsNative
    member __.postToUrl(url: string, request: IReturn<'T>, ?args: obj): Promise<'T> = jsNative
    member __.put(request: IReturn<'T>, ?args: obj): Promise<'T> = jsNative
    member __.putToUrl(url: string, request: IReturn<'T>, ?args: obj): Promise<'T> = jsNative
    member __.patch(request: IReturn<'T>, ?args: obj): Promise<'T> = jsNative
    member __.patchToUrl(url: string, request: IReturn<'T>, ?args: obj): Promise<'T> = jsNative
    member __.createUrlFromDto(``method``: string, request: IReturn<'T>): string = jsNative
    member __.toAbsoluteUrl(relativeOrAbsoluteUrl: string): string = jsNative
    member __.createRequest(``method``: obj, request: obj, ?args: obj, ?url: obj): obj = jsNative
    member __.createResponse(res: obj, request: obj): obj = jsNative
    member __.handleError(holdRes: obj, res: obj): obj = jsNative
    member __.send(``method``: string, request: U2<obj, obj>, ?args: obj, ?url: string): Promise<'T> = jsNative
    member __.raiseError(res: Response, error: obj): obj = jsNative

type [<Erase>]Globals =
    [<Global>] static member toCamelCase with get(): Func<string, string> = jsNative and set(v: Func<string, string>): unit = jsNative
    [<Global>] static member sanitize with get(): Func<obj, obj> = jsNative and set(v: Func<obj, obj>): unit = jsNative
    [<Global>] static member nameOf with get(): Func<obj, obj> = jsNative and set(v: Func<obj, obj>): unit = jsNative
    [<Global>] static member css with get(): Func<U2<string, NodeListOf<Element>>, string, string, unit> = jsNative and set(v: Func<U2<string, NodeListOf<Element>>, string, string, unit>): unit = jsNative
    [<Global>] static member splitOnFirst with get(): Func<string, string, ResizeArray<string>> = jsNative and set(v: Func<string, string, ResizeArray<string>>): unit = jsNative
    [<Global>] static member splitOnLast with get(): Func<string, string, ResizeArray<string>> = jsNative and set(v: Func<string, string, ResizeArray<string>>): unit = jsNative
    [<Global>] static member humanize with get(): Func<obj, obj> = jsNative and set(v: Func<obj, obj>): unit = jsNative
    [<Global>] static member queryString with get(): Func<string, obj> = jsNative and set(v: Func<string, obj>): unit = jsNative
    [<Global>] static member combinePaths with get(): Func<obj, string> = jsNative and set(v: Func<obj, string>): unit = jsNative
    [<Global>] static member createPath with get(): Func<string, obj, string> = jsNative and set(v: Func<string, obj, string>): unit = jsNative
    [<Global>] static member createUrl with get(): Func<string, obj, string> = jsNative and set(v: Func<string, obj, string>): unit = jsNative
    [<Global>] static member appendQueryString with get(): Func<string, obj, string> = jsNative and set(v: Func<string, obj, string>): unit = jsNative
    [<Global>] static member bytesToBase64 with get(): Func<Uint8Array, string> = jsNative and set(v: Func<Uint8Array, string>): unit = jsNative
    [<Global>] static member stripQuotes with get(): Func<string, string> = jsNative and set(v: Func<string, string>): unit = jsNative
    [<Global>] static member tryDecode with get(): Func<string, string> = jsNative and set(v: Func<string, string>): unit = jsNative
    [<Global>] static member parseCookie with get(): Func<string, Cookie> = jsNative and set(v: Func<string, Cookie>): unit = jsNative
    [<Global>] static member toDate with get(): Func<string, DateTime> = jsNative and set(v: Func<string, DateTime>): unit = jsNative
    [<Global>] static member toDateFmt with get(): Func<string, string> = jsNative and set(v: Func<string, string>): unit = jsNative
    [<Global>] static member padInt with get(): Func<float, U2<string, float>> = jsNative and set(v: Func<float, U2<string, float>>): unit = jsNative
    [<Global>] static member dateFmt with get(): Func<DateTime, string> = jsNative and set(v: Func<DateTime, string>): unit = jsNative
    [<Global>] static member dateFmtHM with get(): Func<DateTime, string> = jsNative and set(v: Func<DateTime, string>): unit = jsNative
    [<Global>] static member timeFmt12 with get(): Func<DateTime, string> = jsNative and set(v: Func<DateTime, string>): unit = jsNative


