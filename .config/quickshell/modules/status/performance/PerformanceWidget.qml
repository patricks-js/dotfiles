import QtQuick
import Quickshell.Services.UPower

Item {
    id: root

    signal openPopup

    implicitWidth: 28
    implicitHeight: 26

    function closePopup() { popup.visible = false }

    // Icon and color per active profile
    readonly property var profileMeta: ({
        [PowerProfile.Performance]: { icon: "\uf135", color: "#f7768e", label: "Performance" },
        [PowerProfile.Balanced]:    { icon: "\uf0e7", color: "#e0af68", label: "Balanced"    },
        [PowerProfile.PowerSaver]:  { icon: "\uf06c", color: "#9ece6a", label: "Power Saver" },
    })

    property var meta: profileMeta[PowerProfiles.profile]
                    ?? { icon: "\uf135", color: "#565f89", label: "Unknown" }

    // ── Button ────────────────────────────────────────────────────────────────
    Text {
        anchors.centerIn: parent
        text: root.meta.icon
        font.pixelSize: 15
        font.family: "JetBrainsMono Nerd Font"
        color: root.meta.color
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

    PerformancePopup { id: popup; visible: false }
}
