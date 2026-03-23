import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    visible: false
    focusable: true

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    color: "transparent"

    onVisibleChanged: if (visible) focusItem.forceActiveFocus()

    Item {
        id: focusItem
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.close()
    }

    function toggle() { root.visible = !root.visible }
    function close()  { root.visible = false }

    // ── Dimmed backdrop — click outside to dismiss ────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#99000000"

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }

        // ── Centered card ─────────────────────────────────────────────────────
        Rectangle {
            anchors.centerIn: parent
            width: btnRow.width + 48
            height: 120
            radius: 16
            color: "#1f2335"

            // Swallow clicks so they don't reach the backdrop
            MouseArea { anchors.fill: parent }

            Row {
                id: btnRow
                anchors.centerIn: parent
                spacing: 12

                // ── Button component ─────────────────────────────────────────
                component PowerBtn: Rectangle {
                    property string icon
                    property string label
                    property color  iconColor
                    signal activated

                    width: 72; height: 72
                    radius: 12
                    color: btnArea.containsMouse ? Qt.rgba(1,1,1,0.07) : "transparent"

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: parent.parent.icon
                            color: parent.parent.iconColor
                            font.pixelSize: 26
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: parent.parent.label
                            color: "#a9b1d6"
                            font.pixelSize: 11
                        }
                    }

                    MouseArea {
                        id: btnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: parent.activated()
                    }
                }

                PowerBtn {
                    icon: "\uf023"
                    label: "Lock"
                    iconColor: "#9ece6a"
                    onActivated: {
                        root.close()
                        Quickshell.execDetached(["hyprlock"])
                    }
                }

                PowerBtn {
                    icon: "\uf186"
                    label: "Suspend"
                    iconColor: "#7aa2f7"
                    onActivated: {
                        root.close()
                        Quickshell.execDetached(["systemctl", "suspend"])
                    }
                }

                PowerBtn {
                    icon: "\uf021"
                    label: "Restart"
                    iconColor: "#e0af68"
                    onActivated: {
                        root.close()
                        Quickshell.execDetached(["systemctl", "reboot"])
                    }
                }

                PowerBtn {
                    icon: "\uf011"
                    label: "Shutdown"
                    iconColor: "#f7768e"
                    onActivated: {
                        root.close()
                        Quickshell.execDetached(["systemctl", "poweroff"])
                    }
                }
            }
        }
    }

}
