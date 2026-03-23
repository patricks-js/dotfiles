import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    signal openPopup

    implicitWidth: 28
    implicitHeight: 26

    property string ssid:      ""
    property int    signal:    0
    property bool   connected: false

    function closePopup() { popup.visible = false }

    // ── Current connection state (lightweight, runs periodically) ─────────────
    Process {
        id: stateProc
        command: ["sh", "-c",
            "nmcli -t -f active,ssid,signal dev wifi 2>/dev/null" +
            " | awk -F: '/^yes/{s=$2; for(i=3;i<=NF;i++) s=s\":\"$i; print s; exit}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim()
                if (t.length > 0) {
                    const lastColon = t.lastIndexOf(':')
                    root.ssid      = t.substring(0, lastColon)
                    root.signal    = parseInt(t.substring(lastColon + 1)) || 0
                    root.connected = root.ssid.length > 0
                } else {
                    root.ssid = ""; root.signal = 0; root.connected = false
                }
            }
        }
    }

    function refreshState() { stateProc.running = false; stateProc.running = true }

    Timer { interval: 15000; running: true; repeat: true; onTriggered: refreshState() }
    Component.onCompleted: refreshState()

    // ── Button ────────────────────────────────────────────────────────────────
    Text {
        anchors.centerIn: parent
        text: "\uf1eb"
        font.pixelSize: 15
        font.family: "JetBrainsMono Nerd Font"
        color: {
            if (!root.connected)      return "#414868"
            if (root.signal >= 70)    return "#7aa2f7"
            if (root.signal >= 40)    return "#e0af68"
            return "#f7768e"
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (popup.visible) {
                popup.visible = false
            } else {
                root.openPopup()
                popup.visible = true
                popup.scan()
            }
        }
    }

    WifiPopup { id: popup; visible: false }
}
