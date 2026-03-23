import QtQuick
import Quickshell.Io

Item {
    id: root

    signal openPopup

    implicitWidth: 28
    implicitHeight: 26

    function closePopup() { popup.collapse() }

    property real  vol:   0.5
    property bool  muted: false

    function refresh() { stateProc.running = false; stateProc.running = true }

    Process {
        id: stateProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim()
                root.muted = line.includes("[MUTED]")
                const m = line.match(/[\d.]+/)
                if (m) root.vol = parseFloat(m[0])
            }
        }
    }

    Timer { interval: 5000; running: true; repeat: true; onTriggered: refresh() }
    Component.onCompleted: refresh()

    Text {
        anchors.centerIn: parent
        font { family: "JetBrainsMono Nerd Font"; pixelSize: 15 }
        text: {
            if (root.muted || root.vol <= 0) return "\uf026" // fa-volume-off
            if (root.vol < 0.35)             return "\uf027" // fa-volume-down
            return "\uf028"                                   // fa-volume-up
        }
        color: root.muted ? "#414868" : "#7aa2f7"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (popup.visible) { popup.collapse() }
            else { root.openPopup(); popup.expand(); popup.refresh() }
        }
    }

    VolumePopup { id: popup; visible: false }
}
