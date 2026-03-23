import QtQuick
import Quickshell.Io

Item {
    id: root

    signal openPopup

    implicitWidth: 28
    implicitHeight: 26

    function closePopup() { popup.collapse() }

    property int pct: 50

    function refresh() { stateProc.running = false; stateProc.running = true }

    Process {
        id: stateProc
        command: ["sh", "-c", "brightnessctl -m | cut -d, -f5 | tr -d '%'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const n = parseInt(text.trim())
                if (!isNaN(n)) root.pct = n
            }
        }
    }

    Timer { interval: 5000; running: true; repeat: true; onTriggered: refresh() }
    Component.onCompleted: refresh()

    Text {
        anchors.centerIn: parent
        font { family: "JetBrainsMono Nerd Font"; pixelSize: 15 }
        text: {
            if (root.pct <= 25) return "\uf0eb" // fa-lightbulb-o (dim)
            if (root.pct <= 60) return "\uf185" // fa-sun-o (medium)
            return "\uf185"                      // fa-sun-o (bright)
        }
        color: "#e0af68"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (popup.visible) { popup.collapse() }
            else { root.openPopup(); popup.expand(); popup.refresh() }
        }
    }

    BrightnessPopup { id: popup; visible: false }
}
