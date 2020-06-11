namespace Exira.Users.Domain

module CommandHandler =
    open Commands
    open AccountCommandHandler
    open UserCommandHandler

    let private handleAccountCommand es command =
        match command with
        | Create accountCommand -> handleCreateAccount accountCommand es

    let private handleUserCommand es command =
        match command with
        | Register userCommand -> handleRegister userCommand es
        | Login userCommand -> handleLogin userCommand es
        | Verify userCommand -> handleVerify userCommand es
        | ChangePassword userCommand -> handleChangePassword userCommand es
        | RequestPasswordReset userCommand -> handleRequestPasswordReset userCommand es
        | VerifyPasswordReset userCommand -> handleVerifyPasswordReset userCommand es

    let handleCommand es command =
        match command with
        | User userCommand -> handleUserCommand es userCommand
        | Account accountCommand -> handleAccountCommand es accountCommand

