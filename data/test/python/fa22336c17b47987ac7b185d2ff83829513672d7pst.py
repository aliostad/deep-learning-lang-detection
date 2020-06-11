from psychopy import core, gui
import display


def pstSettings(controller):
    settingsDlg = gui.Dlg(title="PST")
    settingsDlg.addText('Set Parameters')
    settingsDlg.addField('Duration', controller.settings['PST: Duration'])
    settingsDlg.show()  # show dialog and wait for OK or Cancel
    if settingsDlg.OK:
        response = settingsDlg.data
        return response[0]
    else:
        return -1


def pst(controller, outfile):
    duration = pstSettings(controller)

    if duration == -1:
        print 'PST Cancelled'
        return

    display.text(controller.experWin, 'Running PST')
    testWin = controller.testWin

    display.countdown(controller)

    display.fill_screen(testWin, [-1, -1, -1])

    if not controller.testing:
        controller.tobii_cont.setDataFile(outfile)
        controller.tobii_cont.startTracking()
        controller.tobii_cont.setEventsAndParams(['task','duration'])
        controller.tobii_cont.setParam('task', 'pst')
        controller.tobii_cont.setParam('duration', duration)

    core.wait(duration)

    if not controller.testing:
        controller.tobii_cont.stopTracking()
        controller.tobii_cont.closeDataFile()
