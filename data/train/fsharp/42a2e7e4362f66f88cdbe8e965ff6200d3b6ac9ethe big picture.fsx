(**

# The Big Picture

# <img width="640" src="img\overview.png" alt="the architecture overview">

## JobCallback
JobCallback represents a single unit of work which will be executed after pulling a trigger.

## Trigger
Triggering is a mechanism responsible for executing JobCallback at given occurrence date. The occurrence date is calculated  during trigger creation and again after each JobCallback execution. Each trigger can run only one JobCallback  at time, so it is not possible to start ne JobCallback execution while previous one is still running.

## Schedule Manager
Schedule Manager is the main component which communicates with the triggers. It can schedule or unschedule a new job (create or delete a trigger), enable or disable a trigger, fire or terminate execution of given trigger. Schedule Manager supervises the state of all triggers. 

## Start-up script
It's a F# fsx file which holds the source code for job scheduling. 

##Script Compiler
Compiles the Start-up script into Cronix.Startup.dll  on each application start.

##Bootstrapper 
The bootstrapper initializes the entire Cronix library. It's responsible for service installation, compiling the start-up script, job scheduling or even hosting the webui.

## WebUI
WebUI is a simple self-hosted web interface. It allows to manage the scheduled triggers.

*)