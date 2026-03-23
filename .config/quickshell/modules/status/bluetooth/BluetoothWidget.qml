import QtQuick
import Quickshell.Bluetooth

Item {
    id: root

    signal openPopup

    implicitWidth: 28
    implicitHeight: 26

    function closePopup() { popup.visible = false }

    property bool hasConnected: {
        const devs = Bluetooth.devices.values ?? []
        return devs.some(d => d.connected)
    }

    // ── Button ────────────────────────────────────────────────────────────────
    Text {
        anchors.centerIn: parent
        text: root.hasConnected ? "\uf294" : "\uf293"
        font.pixelSize: 15
        font.family: "JetBrainsMono Nerd Font"
        color: {
            if (!Bluetooth.defaultAdapter?.enabled) return "#414868"
            if (root.hasConnected)                  return "#7aa2f7"
            return "#a9b1d6"
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
            }
        }
    }

    BluetoothPopup { id: popup; visible: false }
}
