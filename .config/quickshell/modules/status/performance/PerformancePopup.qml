import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower

PanelWindow {
    id: root

    visible: false
    focusable: true

    anchors { top: true; right: true }
    margins { top: 38; right: 8 }

    WlrLayershell.layer: WlrLayer.Overlay

    implicitWidth:  240
    implicitHeight: card.implicitHeight

    color: "transparent"

    onVisibleChanged: if (visible) focusItem.forceActiveFocus()

    Item {
        id: focusItem
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.visible = false
    }

    readonly property var profiles: [
        { profile: PowerProfile.PowerSaver,  icon: "\uf06c", label: "Power Saver",  color: "#9ece6a",
          desc: "Reduced performance, max battery" },
        { profile: PowerProfile.Balanced,    icon: "\uf0e7", label: "Balanced",     color: "#e0af68",
          desc: "Default system profile" },
        { profile: PowerProfile.Performance, icon: "\uf135", label: "Performance",  color: "#f7768e",
          desc: "Max performance, more power use" },
    ]

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
            Text {
                text: "\uf135  Performance"
                color: "#7aa2f7"; font.bold: true; font.pixelSize: 13
                font.family: "JetBrainsMono Nerd Font"
            }

            Rectangle { width: parent.width; height: 1; color: "#2d3355" }

            // Profile buttons
            Repeater {
                model: root.profiles

                delegate: Rectangle {
                    required property var modelData

                    property bool isActive: PowerProfiles.profile === modelData.profile
                    property bool isAvailable: modelData.profile !== PowerProfile.Performance
                                            || PowerProfiles.hasPerformanceProfile

                    width: col.width
                    height: 52
                    radius: 8
                    opacity: isAvailable ? 1.0 : 0.4
                    color: isActive           ? Qt.rgba(modelData.color.r ?? 0.5,
                                                        modelData.color.g ?? 0.5,
                                                        modelData.color.b ?? 0.5, 0.15)
                         : btnArea.containsMouse ? "#252840"
                         : "transparent"

                    Behavior on color { ColorAnimation { duration: 100 } }

                    // Active indicator bar on left
                    Rectangle {
                        width: 3; height: 32; radius: 2
                        anchors { left: parent.left; leftMargin: 0; verticalCenter: parent.verticalCenter }
                        color: modelData.color
                        visible: isActive
                    }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                        spacing: 10

                        Text {
                            text: modelData.icon
                            color: modelData.color
                            font.pixelSize: 20
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: modelData.label
                                color: "#c0caf5"; font.pixelSize: 12; font.bold: isActive
                            }
                            Text {
                                text: modelData.desc
                                color: "#565f89"; font.pixelSize: 10
                                width: parent.width; wrapMode: Text.WordWrap
                            }
                        }

                        Text {
                            text: "\uf00c"
                            color: modelData.color; font.pixelSize: 12
                            font.family: "JetBrainsMono Nerd Font"
                            visible: isActive
                        }
                    }

                    MouseArea {
                        id: btnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: isAvailable ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                        enabled: isAvailable
                        onClicked: {
                            PowerProfiles.profile = modelData.profile
                            root.visible = false
                        }
                    }
                }
            }

            // Degradation warning
            Rectangle {
                width: parent.width
                height: warnText.implicitHeight + 12
                radius: 6
                color: "#2a1f2e"
                visible: PowerProfiles.degradationReason !== PerformanceDegradationReason.None

                Text {
                    id: warnText
                    anchors { fill: parent; margins: 6 }
                    text: "\uf071  " + (PowerProfiles.degradationReason === PerformanceDegradationReason.HighTemperature
                          ? "Performance limited: high temperature"
                          : "Performance limited: lap detection")
                    color: "#e0af68"; font.pixelSize: 10
                    font.family: "JetBrainsMono Nerd Font"
                    wrapMode: Text.WordWrap
                }
            }

            Item { height: 4; width: 1 }
        }
    }

}
