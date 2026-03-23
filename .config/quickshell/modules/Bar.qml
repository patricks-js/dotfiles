import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import "./status"

PanelWindow {
    id: panel

    signal powerClicked
    signal launcherClicked

    implicitHeight: 36

    anchors {
        top: true
        left: true
        right: true
    }

    exclusiveZone: implicitHeight
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"

        Item {
            anchors {
                fill: parent
                leftMargin: 14
                rightMargin: 14
            }

            // ── LEFT: Arch icon + workspaces ─────────────────────────────────
            Row {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                spacing: 10

                Text {
                    text: "\uf303"
                    color: "#7aa2f7"
                    font.pixelSize: 20
                    font.family: "JetBrainsMono Nerd Font"
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: panel.launcherClicked()
                    }
                }

                Rectangle {
                    width: 1; height: 18
                    color: "#414868"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Row {
                    spacing: 5
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {
                        model: 5

                        delegate: Rectangle {
                            required property int index

                            property bool active: Hyprland.focusedWorkspace?.id === index + 1

                            width: active ? 22 : 8
                            height: 8
                            radius: 4
                            color: active ? "#7aa2f7" : "#414868"

                            Behavior on width  { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                            Behavior on color  { ColorAnimation  { duration: 150 } }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch(`workspace ${index + 1}`)
                            }
                        }
                    }
                }
            }

            // ── CENTER: Day + Date ────────────────────────────────────────────
            Text {
                anchors.centerIn: parent
                color: "#c0caf5"
                font.pixelSize: 13
                font.bold: true

                property var now: new Date()
                text: Qt.formatDateTime(now, "dddd, d 'de' MMMM")

                Timer {
                    interval: 60000
                    running: true
                    repeat: true
                    onTriggered: parent.now = new Date()
                }
            }

            // ── RIGHT: Status area + system tray + power button ──────────────
            Row {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                spacing: 4

                StatusArea { anchors.verticalCenter: parent.verticalCenter }

                Rectangle {
                    width: 1; height: 18; color: "#414868"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Repeater {
                    model: SystemTray.items.values

                    delegate: Item {
                        required property var modelData

                        width: 26; height: 26

                        Image {
                            anchors.centerIn: parent
                            source: modelData.icon
                            width: 16; height: 16
                            smooth: true
                            mipmap: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: mouse => {
                                if (mouse.button === Qt.LeftButton)
                                    modelData.activate()
                                else if (modelData.hasMenu)
                                    modelData.display(panel, mouseX, mouseY)
                            }
                        }
                    }
                }

                Rectangle {
                    width: 1; height: 18; color: "#414868"
                    anchors.verticalCenter: parent.verticalCenter
                    visible: SystemTray.items.values.length > 0
                }

                Text {
                    text: "\uf011"
                    color: "#f7768e"
                    font.pixelSize: 17
                    font.family: "JetBrainsMono Nerd Font"
                    leftPadding: 6
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: panel.powerClicked()
                    }
                }
            }
        }
    }
}
