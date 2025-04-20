// import QtQuick 
// import QtQuick.Controls as QQC2
// import org.kde.kirigami as Kirigami

// Kirigami.FormLayout {
//     id: page
  
//     property alias cfg_showLabel: showLabel.checked
//     property alias cfg_showIcon: showIcon.checked
//     property alias cfg_labelText: labelText.text

//     QQC2.CheckBox {
//         id: showLabel
//         Kirigami.FormData.label: i18n("Section:")
//         text: i18n("Show label")
//     }
//     QQC2.CheckBox {
//         id: showIcon
//         text: i18n("Show icon")
//     }
//     QQC2.TextField {
//         id: labelText
//         Kirigami.FormData.label: i18n("Label:")
//         placeholderText: i18n("Placeholder")
//     }
// }

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import org.kde.plasma.plasmoid
import org.kde.plasma.configuration

Kirigami.FormLayout {
    id: page

    //property var dbusData // Add this property to accept the dbusData object

    property alias cfg_useDropdown: useDropdown.checked
    property alias cfg_useCustomValue: useCustomValue.checked
    property alias cfg_selectedSpeed: speedDropdown.currentIndex
    property alias cfg_customValue: customValue.text
    property double cfg_mySpeedDown: mySpeedDown
    property double cfg_mySpeedUp: mySpeedUp


    // Function to get the selected bandwidth speed
    function getSelectedBandwidth() {
        if (useDropdown.checked) {
            // Map the dropdown index to actual values
            //const speeds = ["1 Mbps", "10 Mbps", "100 Mbps", "1 Gbps", "10 Gbps"];
            sendData(backend.modifier); // Call sendData with the selected bandwidth
            return backend.modifier //speeds[speedDropdown.currentIndex];
        } else if (useCustomValue.checked) {
            sendData(customValue.text); // Call sendData with the custom value
            return customValue.text; // Return the custom value entered by the user
        }
        return null; // Default if no option is selected
    }

    function sendData(selectedBandwidth) {
        if (selectedBandwidth) {
            plasmoid.configuration.mySpeedDown = selectedBandwidth; // Update the downSpeed property
            plasmoid.configuration.mySpeedUp = selectedBandwidth; // Update the upSpeed property

            // console.log("Selected bandwidth sent to logic:", selectedBandwidth);
            // console.log("VAR mySpeedDown set as:", plasmoid.configuration.mySpeedDown);
            // console.log("VAR mySpeedUp set as:", plasmoid.configuration.mySpeedUp);
        } else {
            console.log("No selected bandwidth provided.");
        }
    }


    // Checkbox to toggle plasmoid.configuration.testing
    QQC2.GroupBox {
        title: i18n("Enable Testing Mode")
        Layout.fillWidth: true

        ColumnLayout {
            QQC2.CheckBox {
                id: toggleTesting
                text: i18n("Enable Testing")
                checked: plasmoid.configuration.testing // Bind to plasmoid.configuration.testing
                onClicked: {
                    plasmoid.configuration.testing = checked; // Toggle the value
                    // console.log("Testing mode:", plasmoid.configuration.testing);
                }
            }
        }
    }

    QQC2.GroupBox {
        title: i18n("Select Bandwidth Speed")
        Layout.fillWidth: true

        ColumnLayout {
            QQC2.RadioButton {
                id: useDropdown
                text: i18n("Use predefined speeds")
                checked: !cfg_useCustomValue // Default to dropdown
            }

            QtObject {
                id: backend
                property double modifier
            }

            QQC2.ComboBox {
                id: speedDropdown
                enabled: useDropdown.checked
                Layout.fillWidth: true
                textRole: "text"
                valueRole: "value"
                // When an item is selected, update the backend.
                onActivated: backend.modifier = currentValue
                // Set the initial currentIndex to the value stored in the backend.
                Component.onCompleted: currentIndex = indexOfValue(backend.modifier)
                model: {
                    if (plasmoid.configuration.binaryDecimal === "binary") {
                        // Binary values
                        return [
                            { value: 10, text: i18n("10 bps") },
                            { value: 100, text: i18n("100 bps") },
                            { value: 1024, text: i18n("1 Kibps") },
                            { value: 10240, text: i18n("10 Kibps") },
                            { value: 1048576, text: i18n("1 Mibps") },
                            { value: 10485760, text: i18n("10 Mibps") },
                            { value: 1073741824, text: i18n("1 Gibps") },
                            { value: 2147483648, text: i18n("2 Gibps") }, // Added 2 Gibps
                            { value: 5368709120, text: i18n("5 Gibps") }, // Added 5 Gibps
                            { value: 10737418240, text: i18n("10 Gibps") }
                        ];
                    } else {
                        // Decimal values
                        return [
                            { value: 10, text: i18n("10 bps") },
                            { value: 100, text: i18n("100 bps") },
                            { value: 1000, text: i18n("1 kbps") },
                            { value: 10000, text: i18n("10 kbps") },
                            { value: 100000, text: i18n("100 kbps") },
                            { value: 1000000, text: i18n("1 Mbps") },
                            { value: 10000000, text: i18n("10 Mbps") },
                            { value: 100000000, text: i18n("100 Mbps") },
                            { value: 1000000000, text: i18n("1 Gbps") },
                            { value: 2000000000, text: i18n("2 Gbps") }, // Added 2 Gbps
                            { value: 5000000000, text: i18n("5 Gbps") }, // Added 5 Gbps
                            { value: 10000000000, text: i18n("10 Gbps") }
                        ];
                    }
                }
            }
        }
    }

    QQC2.GroupBox {
        title: i18n("Enter Custom Bandwidth Speed")
        Layout.fillWidth: true

        ColumnLayout {
            QQC2.RadioButton {
                id: useCustomValue
                text: i18n("Use custom value")
                checked: !cfg_useDropdown // Default to custom value
            }

            QQC2.TextField {
                id: customValue
                placeholderText: i18n("Enter custom speed (e.g., 500 Mbps)")
                enabled: useCustomValue.checked
                Layout.fillWidth: true
            }
        }
    }

    // Example Button to Test the Function
    QQC2.Button {
        text: i18n("Send Bandwidth Data")
        Layout.fillWidth: true
        onClicked: selectedBandwidthLabel.text = page.getSelectedBandwidth();
    }

    // Section to Display the Selected Bandwidth Data
    QQC2.GroupBox {
        title: i18n("Data sent to logic:")
        Layout.fillWidth: true

        ColumnLayout {
            QQC2.Label {
                id: selectedBandwidthLabel
                text: page.getSelectedBandwidth()
                wrapMode: Text.Wrap
            }
        }
    }



}