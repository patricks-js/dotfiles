import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    visible: false
    focusable: true

    anchors { top: true; right: true }
    margins { top: 36; right: 0 }

    WlrLayershell.layer: WlrLayer.Overlay

    implicitWidth:  280
    implicitHeight: 48

    color: "transparent"

    onVisibleChanged: if (visible) focusItem.forceActiveFocus()

    Item {
        id: focusItem
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.collapse()
    }

    // ── Public API ─────────────────────────────────────────────────────────────
    function expand() {
        visible = true
        card.animOpen = true
    }

    function collapse() {
        card.animOpen = false
    }

    // ── State ─────────────────────────────────────────────────────────────────
    property int pct: 50

    function refresh() { getProc.running = false; getProc.running = true }

    Process {
        id: getProc
        command: ["sh", "-c", "brightnessctl -m | cut -d, -f5 | tr -d '%'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const n = parseInt(text.trim())
                if (!isNaN(n)) {
                    root.pct = n
                    slider.value = n
                }
            }
        }
    }

    Timer { id: debounce; interval: 60; onTriggered: setProc.running = true }

    Process {
        id: setProc
        command: ["sh", "-c", `brightnessctl set ${Math.round(slider.value)}%`]
    }

    // ── Animated card ─────────────────────────────────────────────────────────
    Rectangle {
        id: card

        property bool animOpen: false

        width:  parent.width
        height: animOpen ? parent.implicitHeight : 0
        clip:   true

        color: "#1a1b26"

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: parent.color
            border { color: "#414868"; width: 1 }
        }
        Rectangle {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            height: 10
            color: parent.color
        }

        Behavior on height {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        onHeightChanged: if (height === 0 && !animOpen) root.visible = false

        // ── Content ───────────────────────────────────────────────────────────
        RowLayout {
            anchors { fill: parent; leftMargin: 14; rightMargin: 14; topMargin: 4 }
            spacing: 10

            Text {
                text: root.pct <= 25 ? "\uf0eb" : "\uf185"
                font { family: "JetBrainsMono Nerd Font"; pixelSize: 16 }
                color: "#e0af68"
            }

            Slider {
                id: slider
                Layout.fillWidth: true
                from: 1; to: 100
                value: root.pct
                stepSize: 1

                onMoved: debounce.restart()

                background: Rectangle {
                    x: slider.leftPadding
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    width:  slider.availableWidth
                    height: 4
                    radius: 2
                    color:  "#414868"

                    Rectangle {
                        width:  slider.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color:  "#e0af68"
                    }
                }

                handle: Rectangle {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    width: 14; height: 14
                    radius: 7
                    color:  slider.pressed ? "#e0af68" : "#c0caf5"
                    border { color: "#1a1b26"; width: 2 }
                }
            }

            Text {
                text: Math.round(slider.value) + "%"
                color: "#565f89"
                font.pixelSize: 12
                Layout.preferredWidth: 32
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
