import Quickshell
import Quickshell.Io
import "./modules"

ShellRoot {
    Bar {
        onPowerClicked:    powerMenu.toggle()
        onLauncherClicked: launcher.toggle()
    }

    PowerMenu { id: powerMenu }
    Launcher  { id: launcher  }

    IpcHandler {
        target: "launcher"
        function toggle(): void { launcher.toggle() }
    }
}
