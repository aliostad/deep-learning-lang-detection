[<RequireQualifiedAccess>]
module BuildProcess

type Reason = string 
type BuildCompletionState =     
    | Success
    | Failed        of Reason

type ProcessState =
    | Started
    | Cloning
    | Cloned
    | Building
    | Completed     of BuildCompletionState

type GitCloneState = 
    | CloneSuccess
    | CloneFailed   of Reason
    
type BuildState =
    | BuildSuccessful
    | BuildFailed   of Reason

type State = { processState :ProcessState option }
    with static member Zero() = { processState = None }
    
type GitUri = string
type Branch = string
type Script = string
type Target = string

type Command = 
    | Build  of GitUri * Branch * Branch * Target seq
    | StartGitClone
    | CompleteGitClone of GitCloneState
    | StartBuild
    | CompleteBuild of BuildState

type Event = 
    | BuildBranchRequested of GitUri * Branch * Branch * Target seq
    | GitCloneStarted
    | CloneGitCompleted of GitCloneState
    | BuildStarted
    | BuildCompleted of BuildState    

type Error = 
    | BuildInAnUnexpectedState of Command * ProcessState

type AssertResult<'TEvent, 'TError> = 
    | Pass of 'TEvent
    | Fail of 'TError

module private Assert = 
    let expectState command state expected option event =  match state.processState with 
                                                           | Some s    -> Fail (BuildInAnUnexpectedState (command, s))
                                                           | _         -> Pass event
                                      
let apply state event = 
    match event with
    | BuildBranchRequested (u, b, e, t) -> { state with processState = Some Started } 
    | GitCloneStarted                   -> { state with processState = Some Cloning }
    | CloneGitCompleted c               -> match c with 
                                           | CloneSuccess   -> { state with processState = Some Cloned }
                                           | CloneFailed r  -> { state with processState = Some (Completed (Failed (r))) }
    | BuildStarted                      -> { state with processState = Some Building }
    | BuildCompleted c                  -> match c with 
                                           | BuildSuccessful   -> { state with processState = Some Cloned }
                                           | BuildFailed r  -> { state with processState = Some (Completed (Failed (r))) }

let (>|) a b = b |>  a 

let exec command state = 
    match command with
    | Build (u, b, e, t)   -> Assert.expectState command state None     >| BuildBranchRequested (u, b, e, t)
    | StartGitClone        -> Assert.expectState command state Started  >| GitCloneStarted
    | CompleteGitClone c   -> Assert.expectState command state Cloning  >| CloneGitCompleted c
    | StartBuild           -> Assert.expectState command state Cloned   >| BuildStarted
    | CompleteBuild c      -> Assert.expectState command state Building >| BuildCompleted c