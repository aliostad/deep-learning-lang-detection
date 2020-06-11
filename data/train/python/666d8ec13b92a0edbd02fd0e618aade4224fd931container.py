
import ui
import world

def create(args):
    g = ui.GumpMenu("container", args.get("x", 100), args.get("y", 100))

    cont = g.addContainerView((0, 0), args["item"])
    cont.background = args["background"]

    g.store["serial"] = args["item"].serial
    g.store["background"] = args["background"]

def save(gump):
    saveData = {
        "x": gump.x,
        "y": gump.y,
        # To be able to also restore the gump after a restart, save only the serial
        "serial": gump.store["serial"],
        "background": gump.store["background"],
    }
    return saveData

def load(saveData):
    itm = world.getDynamicItem(saveData["serial"])
    if itm:
        saveData["item"] = itm
        gump = create(saveData)
