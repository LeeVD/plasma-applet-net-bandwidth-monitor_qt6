import QtQuick
import org.kde.plasma.networkmanagement as PlasmaNM

Item {
    function test(){
        console.log("test called!")
    } 
    // PlasmaNM.NetworkStatus {
    //     id: networkStatus
    //     onNetworkStatusChanged: {
    //         console.log("Network status changed:", networkStatus.networkStatus)
    //     }
    // }

    // PlasmaNM.ConnectionIcon {
    //     id: connectionIcon
    //     onConnectionIconChanged: {
    //         console.log("Connection icon changed:", connectionIcon.connectionIcon)
    //     }
    // }
}