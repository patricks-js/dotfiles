import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    visible: false
    focusable: true

    anchors { top: true; bottom: true; left: true; right: true }

    // Set a namespace so Hyprland can target it:
    //   layerrule = blur, launcher
    //   layerrule = ignorezero, launcher
    WlrLayershell.layer:     WlrLayer.Overlay
    WlrLayershell.namespace: "launcher"

    color: "transparent"

    // ── Public API ─────────────────────────────────────────────────────────────
    function open() {
        visible = true
        searchField.clear()
        searchField.forceActiveFocus()
    }
    function close()  { visible = false }
    function toggle() { visible ? close() : open() }

    // ── ESC to close ───────────────────────────────────────────────────────────
    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.close()
    }

    // ── App list (already excludes NoDisplay/Hidden) ───────────────────────────
    property var filteredApps: {
        const q = searchField.text.trim().toLowerCase()
        const all = DesktopEntries.applications.values ?? []
        const sorted = [...all].sort((a, b) => a.name.localeCompare(b.name))
        if (!q) return sorted
        return sorted.filter(a =>
            a.name.toLowerCase().includes(q) ||
            (a.comment ?? "").toLowerCase().includes(q)
        )
    }

    // ── Backdrop — click outside card closes launcher ──────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#cc000000"

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    // ── Card ───────────────────────────────────────────────────────────────────
    Rectangle {
        anchors.centerIn: parent
        width: 580
        height: 520
        color: "#1a1b26"
        radius: 14
        border { color: "#414868"; width: 1 }

        MouseArea { anchors.fill: parent } // block backdrop clicks

        // Search bar
        Rectangle {
            id: searchBox
            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 14 }
            height: 44
            radius: 8
            color: "#24283b"
            border { color: searchField.activeFocus ? "#7aa2f7" : "#414868"; width: 1 }

            Row {
                anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                spacing: 8

                Text {
                    text: "\uf002"
                    font { family: "JetBrainsMono Nerd Font"; pixelSize: 14 }
                    color: "#565f89"
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: searchField
                    anchors.verticalCenter: parent.verticalCenter
                    width: searchBox.width - 56
                    color: "#c0caf5"
                    font.pixelSize: 14
                    placeholderText: "Buscar aplicativos..."
                    placeholderTextColor: "#565f89"
                    background: null
                    focus: true
                    Keys.onEscapePressed: root.close()
                }
            }
        }

        // App grid
        GridView {
            id: grid
            anchors {
                top: searchBox.bottom; topMargin: 10
                left: parent.left;     leftMargin: 10
                right: parent.right;   rightMargin: 10
                bottom: parent.bottom; bottomMargin: 10
            }
            clip: true

            readonly property int cols: 5
            cellWidth:  Math.floor(width / cols)
            cellHeight: 96

            model: root.filteredApps

            delegate: Item {
                required property var modelData

                width:  GridView.view.cellWidth
                height: GridView.view.cellHeight

                // Hover highlight
                Rectangle {
                    anchors { fill: parent; margins: 4 }
                    radius: 8
                    color: ma.containsMouse ? "#ffffff12" : "transparent"
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 6
                    width: parent.width - 12

                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: Quickshell.iconPath(modelData.icon)
                        width: 38; height: 38
                        smooth: true; mipmap: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        text: modelData.name
                        color: ma.containsMouse ? "#ffffff" : "#c0caf5"
                        font.pixelSize: 11
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.WordWrap
                    }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { modelData.execute(); root.close() }
                }
            }

            // Scroll indicator
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                contentItem: Rectangle {
                    implicitWidth: 3
                    radius: 2
                    color: "#414868"
                }
            }
        }
    }
}
