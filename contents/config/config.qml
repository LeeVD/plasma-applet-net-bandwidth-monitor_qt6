import QtQuick
import org.kde.plasma.configuration

// property bool testing: plasmoid.configuration.testing

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: 'preferences-desktop-settings'
         source: 'configGeneral.qml'
    }
    ConfigCategory {
        name: i18n("Network")
        icon: 'network-card' //'network-wired'
        source: 'configNetwork.qml'
    }
    // ConfigCategory {
    //     name: i18n("Testing")
    //     icon: 'preferences-desktop-locale' //'configure'
    //     source: 'configTesting.qml'

    // }
    // ConfigCategory {
    //     name: i18n("CPU")
    //     icon: 'show-gpu-effects' //'network-wired'
    //     source: 'config/configCPU.qml'
    // }
    // ConfigCategory {
    //     name: i18n('Tooltip')
    //     icon: 'dialog-information' //'preferences-desktop-locale' //'configure'
    //     source: 'config/configToolTip.qml'
    // }
}