import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth

PanelWindow {
    id: root

    visible: false
    focusable: true

    anchors { top: true; right: true }
    margins { top: 38; right: 8 }

    WlrLayershell.layer: WlrLayer.Overlay

    implicitWidth:  260
    implicitHeight: Math.min(card.implicitHeight, 400)

    color: "transparent"

    onVisibleChanged: if (visible) focusItem.forceActiveFocus()

    Item {
        id: focusItem
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.visible = false
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
                    text: "\uf293  Bluetooth"
                    color: "#7aa2f7"; font.bold: true; font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"
                }

                Item { Layout.fillWidth: true }

                // Power toggle
                Rectangle {
                    width: 36; height: 18; radius: 9
                    color: Bluetooth.defaultAdapter?.enabled ? "#7aa2f7" : "#414868"

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Rectangle {
                        width: 12; height: 12; radius: 6
                        color: "#1f2335"
                        anchors.verticalCenter: parent.verticalCenter
                        x: Bluetooth.defaultAdapter?.enabled ? 20 : 4

                        Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    }

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (Bluetooth.defaultAdapter)
                                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
                        }
                    }
                }

                // Scan button
                Text {
                    text: Bluetooth.defaultAdapter?.discovering ? "\uf110" : "\uf002"
                    color: "#565f89"; font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"
                    leftPadding: 4

                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!Bluetooth.defaultAdapter) return
                            if (Bluetooth.defaultAdapter.discovering)
                                Bluetooth.defaultAdapter.discovering = false
                            else
                                Bluetooth.defaultAdapter.discovering = true
                        }
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: "#2d3355" }

            // Device list
            Flickable {
                width: parent.width
                height: Math.min(contentHeight, 320)
                contentHeight: devCol.implicitHeight
                clip: true

                Column {
                    id: devCol
                    width: parent.width
                    spacing: 2

                    Repeater {
                        model: Bluetooth.devices.values ?? []

                        delegate: Rectangle {
                            required property var modelData

                            width: devCol.width
                            height: 40
                            radius: 8
                            color: devArea.containsMouse ? "#252840" : "transparent"
                            Behavior on color { ColorAnimation { duration: 100 } }

                            RowLayout {
                                anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                                spacing: 8

                                // Device type icon
                                Image {
                                    source: Quickshell.iconPath(modelData.icon, true)
                                    width: 16; height: 16
                                    visible: source !== ""
                                }

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 1

                                    Text {
                                        text: modelData.name
                                        color: "#c0caf5"; font.pixelSize: 12
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }

                                    Text {
                                        text: modelData.state === BluetoothDeviceState.Connected  ? "Connected"
                                            : modelData.state === BluetoothDeviceState.Connecting  ? "Connecting…"
                                            : modelData.state === BluetoothDeviceState.Disconnecting ? "Disconnecting…"
                                            : "Disconnected"
                                        color: modelData.connected ? "#9ece6a" : "#565f89"
                                        font.pixelSize: 10
                                    }
                                }

                                // Battery
                                Text {
                                    text: modelData.batteryAvailable
                                        ? Math.round(modelData.battery * 100) + "%"
                                        : ""
                                    color: "#565f89"; font.pixelSize: 10
                                    visible: modelData.batteryAvailable
                                }

                                // Connect/disconnect toggle
                                Rectangle {
                                    width: 50; height: 20; radius: 4
                                    color: modelData.connected ? "#1a3a2a" : "#2d3355"

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.connected ? "Disconnect" : "Connect"
                                        color: modelData.connected ? "#9ece6a" : "#7aa2f7"
                                        font.pixelSize: 9
                                    }

                                    MouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: modelData.connected
                                            ? modelData.disconnect()
                                            : modelData.connect()
                                    }
                                }
                            }

                            MouseArea {
                                id: devArea
                                anchors.fill: parent
                                hoverEnabled: true
                                // Clicks handled by inner button
                            }
                        }
                    }

                    // Empty state
                    Text {
                        width: parent.width
                        text: "No paired devices"
                        color: "#565f89"; font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        topPadding: 8; bottomPadding: 8
                        visible: (Bluetooth.devices.values ?? []).length === 0
                    }
                }
            }

            Item { height: 4; width: 1 }
        }
    }

}
