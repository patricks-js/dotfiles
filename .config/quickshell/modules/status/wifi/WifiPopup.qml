import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    visible: false
    focusable: true

    anchors { top: true; right: true }
    margins { top: 38; right: 8 }

    WlrLayershell.layer: WlrLayer.Overlay

    implicitWidth:  290
    implicitHeight: Math.min(card.implicitHeight, 420)

    color: "transparent"

    onVisibleChanged: if (visible) focusItem.forceActiveFocus()

    Item {
        id: focusItem
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.visible = false
    }

    // ── Network data ──────────────────────────────────────────────────────────
    property var networks: []
    property bool scanning: false

    function scan() {
        root.scanning = true
        scanProc.running = false
        scanProc.running = true
    }

    Process {
        id: scanProc
        command: ["sh", "-c",
            "nmcli -t -f IN-USE,SSID,SIGNAL device wifi list 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                const result = []
                for (const line of text.trim().split('\n')) {
                    if (!line) continue
                    const sep  = line.indexOf(':')
                    const inUse = line.substring(0, sep) === '*'
                    const rest  = line.substring(sep + 1)
                    const last  = rest.lastIndexOf(':')
                    const ssid  = rest.substring(0, last)
                    const sig   = parseInt(rest.substring(last + 1)) || 0
                    if (ssid.length > 0) result.push({ inUse, ssid, signal: sig })
                }
                // connected first, then by signal desc
                result.sort((a, b) => (b.inUse - a.inUse) || (b.signal - a.signal))
                root.networks = result
                root.scanning = false
            }
        }
    }

    // ── Card ──────────────────────────────────────────────────────────────────
    Rectangle {
        id: card
        anchors.fill: parent
        color: "#1f2335"
        radius: 12
        implicitHeight: col.implicitHeight + 20

        Column {
            id: col
            anchors { top: parent.top; left: parent.left; right: parent.right; topMargin: 12; leftMargin: 12; rightMargin: 12 }
            spacing: 6

            // Header
            RowLayout {
                width: parent.width

                Text {
                    text: "\uf1eb  WiFi"
                    color: "#7aa2f7"; font.bold: true; font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: root.scanning ? "\uf110" : "\uf021"
                    color: "#565f89"; font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.execDetached(["nmcli", "device", "wifi", "rescan"])
                            Qt.callLater(root.scan)
                        }
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: "#2d3355" }

            // Network list
            Flickable {
                width: parent.width
                height: Math.min(contentHeight, 340)
                contentHeight: netCol.implicitHeight
                clip: true

                Column {
                    id: netCol
                    width: parent.width
                    spacing: 2

                    Repeater {
                        model: root.networks

                        delegate: Rectangle {
                            required property var modelData

                            width: netCol.width
                            height: 34
                            radius: 8
                            color: modelData.inUse   ? "#283457"
                                 : hoverArea.containsMouse ? "#252840"
                                 : "transparent"

                            Behavior on color { ColorAnimation { duration: 100 } }

                            RowLayout {
                                anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                                spacing: 8

                                // Signal strength icon
                                Text {
                                    text: "\uf1eb"
                                    font.pixelSize: 13; font.family: "JetBrainsMono Nerd Font"
                                    color: modelData.signal >= 70 ? "#9ece6a"
                                         : modelData.signal >= 40 ? "#e0af68" : "#f7768e"
                                }

                                // SSID
                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.ssid
                                    color: modelData.inUse ? "#c0caf5" : "#a9b1d6"
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                }

                                // Signal %
                                Text {
                                    text: modelData.signal + "%"
                                    color: "#565f89"; font.pixelSize: 10
                                }

                                // Active checkmark
                                Text {
                                    text: modelData.inUse ? "\uf00c" : ""
                                    color: "#9ece6a"; font.pixelSize: 11
                                    font.family: "JetBrainsMono Nerd Font"
                                    visible: modelData.inUse
                                }
                            }

                            MouseArea {
                                id: hoverArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (!modelData.inUse) {
                                        Quickshell.execDetached([
                                            "nmcli", "device", "wifi", "connect", modelData.ssid
                                        ])
                                        root.visible = false
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item { height: 4; width: 1 }
        }
    }

}
