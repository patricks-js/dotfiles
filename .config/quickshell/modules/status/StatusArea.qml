import QtQuick
import "./wifi"
import "./bluetooth"
import "./performance"
import "./volume"
import "./brightness"

// Horizontal row of status widgets. Manages mutual exclusion of popups.
Row {
    spacing: 2

    WifiWidget {
        id: wifiWidget
        onOpenPopup: { btWidget.closePopup(); perfWidget.closePopup(); volWidget.closePopup(); brightWidget.closePopup() }
    }

    BluetoothWidget {
        id: btWidget
        onOpenPopup: { wifiWidget.closePopup(); perfWidget.closePopup(); volWidget.closePopup(); brightWidget.closePopup() }
    }

    PerformanceWidget {
        id: perfWidget
        onOpenPopup: { wifiWidget.closePopup(); btWidget.closePopup(); volWidget.closePopup(); brightWidget.closePopup() }
    }

    VolumeWidget {
        id: volWidget
        onOpenPopup: { wifiWidget.closePopup(); btWidget.closePopup(); perfWidget.closePopup(); brightWidget.closePopup() }
    }

    BrightnessWidget {
        id: brightWidget
        onOpenPopup: { wifiWidget.closePopup(); btWidget.closePopup(); perfWidget.closePopup(); volWidget.closePopup() }
    }
}
