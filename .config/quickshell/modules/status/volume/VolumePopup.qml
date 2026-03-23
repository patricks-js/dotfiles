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

    // Flush with bar bottom — looks like the bar is extending
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
        // visible = false is triggered by onHeightChanged after animation
    }

    // ── State ─────────────────────────────────────────────────────────────────
    property real vol:   0.5
    property bool muted: false

    function refresh() { getProc.running = false; getProc.running = true }

    Process {
        id: getProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim()
                root.muted = line.includes("[MUTED]")
                const m = line.match(/[\d.]+/)
                if (m) {
                    root.vol = parseFloat(m[0])
                    slider.value = root.vol * 100
                }
            }
        }
    }

    Timer { id: debounce; interval: 60; onTriggered: setProc.running = true }

    Process {
        id: setProc
        command: ["sh", "-c", `wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ ${Math.round(slider.value)}%`]
    }

    Process {
        id: muteProc
        command: ["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"]
        onRunningChanged: if (!running) root.refresh()
    }

    // ── Animated card ─────────────────────────────────────────────────────────
    Rectangle {
        id: card

        property bool animOpen: false

        width:  parent.width
        height: animOpen ? parent.implicitHeight : 0
        clip:   true

        color:  "#1a1b26"

        // Flat on top (connects to bar), rounded on bottom
        Rectangle {
            anchors.fill: parent
            radius: 10
            color: parent.color
            border { color: "#414868"; width: 1 }
        }
        Rectangle {
            // Cover top radius so it looks flush with bar
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

            // Mute / volume icon
            Text {
                text: {
                    if (root.muted || root.vol <= 0) return "\uf026"
                    if (root.vol < 0.35)             return "\uf027"
                    return "\uf028"
                }
                font { family: "JetBrainsMono Nerd Font"; pixelSize: 16 }
                color: root.muted ? "#414868" : "#7aa2f7"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: muteProc.running = true
                }
            }

            // Slider
            Slider {
                id: slider
                Layout.fillWidth: true
                from: 0; to: 100
                value: root.vol * 100
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
                        color:  "#7aa2f7"
                    }
                }

                handle: Rectangle {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    width: 14; height: 14
                    radius: 7
                    color:  slider.pressed ? "#7aa2f7" : "#c0caf5"
                    border { color: "#1a1b26"; width: 2 }
                }
            }

            // Percentage
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
