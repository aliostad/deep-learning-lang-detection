package main

import ("github.com/go-gl/gl"
        glfw "github.com/go-gl/glfw3"
        "fmt")

type GlfwManager struct {
    Window *glfw.Window
    resizeCallbacks []func(int, int)
    drawCallbacks []func()
    updateCallbacks []func(float64)
}

func CreateGlfwManager() *GlfwManager {
    var err error;
    manager := new(GlfwManager)
    manager.resizeCallbacks = make([]func(int, int), 0, 10)
    manager.drawCallbacks = make([]func(), 0, 10)
    manager.updateCallbacks = make([]func(float64), 0, 10)

    glfw.SetErrorCallback(
        func(err glfw.ErrorCode, desc string) {
            fmt.Printf("%v: %v\n", err, desc)
        })

    if !glfw.Init() {
        panic("Can't init glfw!")
    }

    manager.Window, err = glfw.CreateWindow(300, 300, "Test", nil, nil)
    if err != nil {
        panic(err)
    }

    manager.Window.SetSizeCallback(
        func(window *glfw.Window, width int, height int) {
            manager.SetSize(width, height)
        })
    manager.Window.MakeContextCurrent()
    gl.Init()

    return manager
}

func (manager *GlfwManager) SubscribeSetSize(cb func(int, int)) {
    manager.resizeCallbacks = append(manager.resizeCallbacks, cb)
}

func (manager *GlfwManager) SubscribeDraw(cb func()) {
    manager.drawCallbacks = append(manager.drawCallbacks, cb)
}

func (manager *GlfwManager) SubscribeUpdate(cb func(float64)) {
    manager.updateCallbacks = append(manager.updateCallbacks, cb)
}

func (manager *GlfwManager) SetSize(w int, h int) {
    for _, f := range manager.resizeCallbacks {
        f(w, h)
    }
    gl.Viewport(0, 0, w, h)
}

func (manager *GlfwManager) Update(dt float64) {
    for _, f := range manager.updateCallbacks {
        f(dt)
    }
}

func (manager *GlfwManager) Draw() {
    for _, f := range manager.drawCallbacks {
        f()
    }
    manager.Window.SwapBuffers()
    glfw.PollEvents()
}

func (manager *GlfwManager) Destroy() {
    manager.Window.Destroy()
    glfw.Terminate()
}
