import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: root

    // ── IPC ───────────────────────────────────────────────────────────────────
    IpcHandler {
        target: "launcher"
        function toggle(): void { launcher.toggle() }
    }

    IpcHandler {
        target: "powermenu"
        function toggle(): void { powerMenu.toggle() }
    }

    // ── Wallpaper list ────────────────────────────────────────────────────────
    ListModel { id: wallpaperModel }

    Process {
        id: wallpaperProc
        command: ["bash", "-c",
            "find \"$HOME/wallpapers\" -maxdepth 1 -type f" +
            " \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \\)" +
            " 2>/dev/null | sort"]

        stdout: SplitParser {
            onRead: line => {
                const trimmed = line.trim()
                if (!trimmed) return
                const name = trimmed.split("/").pop().replace(/\.[^/.]+$/, "")
                wallpaperModel.append({ path: trimmed, name: name })
            }
        }
    }

    // ── App Launcher ──────────────────────────────────────────────────────────
    PanelWindow {
        id: launcher
        visible: false
        focusable: true
        anchors { top: true; bottom: true; left: true; right: true }
        WlrLayershell.layer:     WlrLayer.Overlay
        WlrLayershell.namespace: "launcher"
        color: "transparent"

        function open() {
            visible = true
            searchField.clear()
            searchField.forceActiveFocus()
        }
        function close()  { visible = false }
        function toggle() { visible ? close() : open() }

        readonly property bool wallpaperMode: searchField.text.startsWith(">wallpaper")
        readonly property bool commandMode:   searchField.text.startsWith(">")

        onWallpaperModeChanged: {
            if (wallpaperMode && !wallpaperProc.running) {
                wallpaperModel.clear()
                wallpaperProc.running = true
            }
        }

        property var filteredApps: {
            if (commandMode) return []
            const q = searchField.text.trim().toLowerCase()
            const all = DesktopEntries.applications.values ?? []
            const sorted = [...all].sort((a, b) => a.name.localeCompare(b.name))
            if (!q) return sorted
            return sorted.filter(a =>
                a.name.toLowerCase().includes(q) ||
                (a.comment ?? "").toLowerCase().includes(q)
            )
        }

        // ESC to close
        Item {
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: launcher.close()
        }

        // Dimmed backdrop — click outside to close
        Rectangle {
            anchors.fill: parent
            color: "#cc000000"
            MouseArea {
                anchors.fill: parent
                onClicked: launcher.close()
            }
        }

        // Card
        Rectangle {
            anchors.centerIn: parent
            width: 620
            height: launcher.wallpaperMode ? 260 : 520
            color: "#1a1b26"
            radius: 14
            border { color: "#414868"; width: 1 }
            clip: true

            Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

            MouseArea { anchors.fill: parent } // block backdrop clicks

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                // ── Wallpaper picker (>wallpaper mode) ────────────────────
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: launcher.wallpaperMode
                    orientation: ListView.Horizontal
                    spacing: 10
                    clip: true
                    model: wallpaperModel

                    delegate: Item {
                        width: 170
                        height: ListView.view.height

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            radius: 10
                            color: "#24283b"
                            border.color: wallMA.containsMouse ? "#7aa2f7" : "transparent"
                            border.width: 2
                            clip: true

                            Image {
                                anchors.fill: parent
                                source: "file://" + model.path
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 26
                                color: "#bb000000"

                                Text {
                                    anchors.centerIn: parent
                                    text: model.name
                                    color: "#c0caf5"
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                    width: parent.width - 8
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }

                        MouseArea {
                            id: wallMA
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Quickshell.execDetached(["bash", "-c",
                                    "hyprctl hyprpaper preload \"" + model.path + "\" && " +
                                    "hyprctl hyprpaper wallpaper \"," + model.path + "\""])
                                launcher.close()
                            }
                        }
                    }
                }

                // ── App grid (normal / search mode) ──────────────────────
                GridView {
                    id: appGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: !launcher.commandMode
                    clip: true

                    readonly property int cols: 5
                    cellWidth:  Math.floor(width / cols)
                    cellHeight: 88

                    model: launcher.filteredApps

                    delegate: Item {
                        required property var modelData
                        width:  appGrid.cellWidth
                        height: appGrid.cellHeight

                        Rectangle {
                            anchors { fill: parent; margins: 4 }
                            radius: 8
                            color: appMA.containsMouse ? "#ffffff12" : "transparent"
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            width: parent.width - 12

                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: Quickshell.iconPath(modelData.icon)
                                width: 36; height: 36
                                smooth: true; mipmap: true
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width
                                text: modelData.name
                                color: appMA.containsMouse ? "#ffffff" : "#c0caf5"
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                                maximumLineCount: 2
                                wrapMode: Text.WordWrap
                            }
                        }

                        MouseArea {
                            id: appMA
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { modelData.execute(); launcher.close() }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        contentItem: Rectangle {
                            implicitWidth: 3
                            radius: 2
                            color: "#414868"
                        }
                    }
                }

                // ── Command hints (> mode, not wallpaper) ─────────────────
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: launcher.commandMode && !launcher.wallpaperMode

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        Repeater {
                            model: [
                                { cmd: ">wallpaper", desc: "Pick a wallpaper from ~/wallpapers" },
                                { cmd: ">power",     desc: "Open the power menu (press Enter)"  },
                            ]

                            delegate: Row {
                                spacing: 12
                                Text {
                                    text: modelData.cmd
                                    color: "#7aa2f7"
                                    font { pixelSize: 13; family: "JetBrainsMono Nerd Font" }
                                }
                                Text {
                                    text: "— " + modelData.desc
                                    color: "#565f89"
                                    font.pixelSize: 13
                                }
                            }
                        }
                    }
                }

                // ── Search bar ────────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    height: 44
                    radius: 8
                    color: "#24283b"
                    border {
                        color: searchField.activeFocus ? "#7aa2f7" : "#414868"
                        width: 1
                    }

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
                            width: parent.width - 36
                            color: "#c0caf5"
                            font.pixelSize: 14
                            placeholderText: 'Type ">" for commands'
                            placeholderTextColor: "#565f89"
                            background: null
                            focus: true

                            Keys.onEscapePressed: launcher.close()
                            Keys.onReturnPressed: {
                                if (text.trim() === ">power") {
                                    launcher.close()
                                    powerMenu.open()
                                } else if (!launcher.commandMode && appGrid.count > 0) {
                                    launcher.filteredApps[0].execute()
                                    launcher.close()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ── Power Menu ────────────────────────────────────────────────────────────
    PanelWindow {
        id: powerMenu
        visible: false
        focusable: true
        anchors { top: true; bottom: true; left: true; right: true }
        WlrLayershell.layer:     WlrLayer.Overlay
        WlrLayershell.namespace: "powermenu"
        color: "transparent"

        function open()   { visible = true; focusItem.forceActiveFocus() }
        function close()  { visible = false }
        function toggle() { visible ? close() : open() }

        onVisibleChanged: if (visible) focusItem.forceActiveFocus()

        Item {
            id: focusItem
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: powerMenu.close()
        }

        // Dimmed backdrop
        Rectangle {
            anchors.fill: parent
            color: "#cc000000"
            MouseArea {
                anchors.fill: parent
                onClicked: powerMenu.close()
            }
        }

        // 2×2 card
        Rectangle {
            anchors.centerIn: parent
            width: 322
            height: 322
            radius: 18
            color: "#1a1b26"
            clip: true

            MouseArea { anchors.fill: parent }

            component PowerBtn: Rectangle {
                property string icon
                property string label
                property color  bgColor
                signal activated

                color: btnArea.containsMouse ? Qt.lighter(bgColor, 1.18) : bgColor
                Behavior on color { ColorAnimation { duration: 120 } }

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: parent.parent.icon
                        color: "#ffffff"
                        font { family: "JetBrainsMono Nerd Font"; pixelSize: 40 }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: parent.parent.label
                        color: "#ffffff"
                        font.pixelSize: 13
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

            GridLayout {
                anchors.fill: parent
                columns: 2
                rowSpacing: 2
                columnSpacing: 2

                PowerBtn {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    icon:    "\uf023"
                    label:   "Lock"
                    bgColor: "#7a6550"
                    onActivated: { powerMenu.close(); Quickshell.execDetached(["hyprlock"]) }
                }

                PowerBtn {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    icon:    "\uf011"
                    label:   "Shutdown"
                    bgColor: "#3d4b5c"
                    onActivated: { powerMenu.close(); Quickshell.execDetached(["systemctl", "poweroff"]) }
                }

                PowerBtn {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    icon:    "\uf186"
                    label:   "Sleep"
                    bgColor: "#3d4b5c"
                    onActivated: { powerMenu.close(); Quickshell.execDetached(["systemctl", "suspend"]) }
                }

                PowerBtn {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    icon:    "\uf021"
                    label:   "Restart"
                    bgColor: "#7a4555"
                    onActivated: { powerMenu.close(); Quickshell.execDetached(["systemctl", "reboot"]) }
                }
            }
        }
    }
}
