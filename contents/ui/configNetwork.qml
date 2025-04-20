/*
 * Author:  LeeVD <thoth360@hotmail.com>
 *
 * This program is open software.
 * You can redistribute it and/or modify it. 
 * 
 * This program is distributed in the hope that it will be useful.
 * It comes WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// import org.kde.plasma.components //as PlasmaComponents
//import org.kde.plasma.core 2.0 as PlasmaCore
import DbusModel

import QtQuick.Dialogs

Item {
    id: base
    // configNetwork.qml >>> plasmoid.configuration
    property var cfg_netSources: netSources   
    property var cfg_netDetails: netDetails
    // property bool cfg_allNetworksChecked: allNetworksChecked.checked

    //################## SERIALISATION FIX ###########################
    property var net: []
    property var det: []

    property bool dataLoading: true
    // property int netLength: 0 // STOP BINDING LOOP IN REPEATER

    function netSourceEncode(value) {
        return JSON.stringify(value)
    }

    function netSourceDecode(value) {
        try {
            return JSON.parse(value)
        } catch (E) {
            return []
        }
    }

    function updateNetFromModel(modelName, modelChecked) {
        for (let i = 0; i < net.length; i++) {
            if (net[i].name === modelName) {
                net[i].checked = modelChecked; // Update the checked state
                // console.log("Updated net entry:", net[i].name, "now:", net[i].checked);
                break; // Exit the loop once the matching name is found
            }
        }
        net = net; // Reassign the array to trigger bindings
        cfg_netSources = netSourceEncode(net); // Update the serialized configuration
        cfg_netSourcesChanged(); // Notify changes
    }
    //################################################################

    GridLayout {
        id: grid
        columns: 3
        columnSpacing: 15
        rowSpacing: 40

        //________ PADDING ________ 
        Rectangle {
            Layout.column: 0
            height: 2
            Layout.minimumWidth: 10 //(parent.width / 100) * 40 
            width: 5 // (parent.width / 100) * 40 
            color: "transparent"
        }
        // _______ TESTING ________

        ListModel {
            id: netInterfaceModel
        }
        ColumnLayout {
            ButtonGroup {
                id: childGroup
                exclusive: false
                checkState: allNetworks.checkState
            }
            RowLayout {
                height: allNetworks.height
                CheckBox {
                    id: allNetworks
                    checkState: childGroup.checkState
                }
                Label {
                    text: { 
                        if (allNetworks.checked) {
                            return "<pre>[ <b>" + "all" + "</b> ]  monitoring <font color='green'><b>enabled</b></font></pre>"
                        } else {
                            return "<pre>[ " + "all" + " ]  monitoring <font color='red'><b>disabled</b></font></pre>"
                        }                            
                    }
                    textFormat: Text.RichText // Enable rich text formatting for bold text
                }
            }
            Repeater {
                model: netInterfaceModel
                RowLayout {
                    height: allNetworks.height
                    CheckBox {
                        id: interfaceCheckbox
                        checked:    model.checked
                        leftPadding: indicator.width
                        ButtonGroup.group: childGroup
                        onCheckedChanged: {
                            if (!dataLoading) {
                                updateNetFromModel(model.name, interfaceCheckbox.checked)        
                            }
                        }
                    }
                    Label {
                        text: { 
                            if (interfaceCheckbox.checked) {
                                return "<pre>[ <b>" + model.name + "</b> ]  monitoring <font color='green'><b>enabled</b></font></pre>"
                            } else {
                                return "<pre>[ " + model.name + " ]  monitoring <font color='red'><b>disabled</b></font></pre>"
                            }
                        }
                        textFormat: Text.RichText // Enable rich text formatting for bold text
                    }                
                }
            }
        }

        //________ NET INTERFACE LOGIC ________

        // ColumnLayout {
        //     // Master entry = All
        //     Row {
        //         height: allNetworksChecked.height
        //         CheckBox {
        //             id: allNetworksChecked
        //             //text:       net[index].name
        //             //checked: cfg_allNetworksChecked // net[0].checked 
        //             onCheckedChanged: {
        //                 if (!data.loading) {
        //                     cfg_allNetworksChecked = allNetworksChecked.checked
        //                     // Update all individual checkboxes only if the state of "All" changes
        //                     for (let i = 0; i < net.length; i++) {
        //                         if (net[i].checked !== allNetworksChecked.checked) {
        //                             net[i] = Object.assign({}, net[i], { checked: allNetworksChecked.checked });
        //                         }
        //                     }

        //                     net = net; // Reassign the array to trigger bindings

        //                     cfg_netSources = netSourceEncode(net)
        //                     cfg_netSourcesChanged();    // SETS NEW VALUES IN MAIN 
        //                 }
        //             }
        //         }
        //         Label {
        //             text: { 
        //                 if (allNetworksChecked.checked) {
        //                     return "<pre>[ <b>" + "all" + "</b> ]  monitoring <font color='green'><b>enabled</b></font></pre>"
        //                 } else {
        //                     return "<pre>[ " + "all" + " ]  monitoring <font color='red'><b>disabled</b></font></pre>"
        //                 }                            
        //                 //     return "<pre>[ <b>" + net[0].name + "</b> ]  monitoring <font color='green'><b>enabled</b></font></pre>"
        //                 // } else {
        //                 //     return "<pre>[ " + net[0].name + " ]  monitoring <font color='red'><b>disabled</b></font></pre>"
        //                 // }
        //             }//"Enable Interface  "
        //             textFormat: Text.RichText // Enable rich text formatting for bold text
        //             // height: allNetworksChecked.height
        //         }
        //     }
        //     Repeater {
        //         model:          net.length   //sources
        //         Row {
        //             // visible: index !== 0 // Skip rendering for entry 0
        //             Layout.leftMargin: 20 // Indent the row forward
        //             Layout.alignment: Qt.AlignLeft // Align the row to the left
        //             // spacing: 10 // Add spacing between the CheckBox and Label
        //             CheckBox {
        //                 id: interfaceCheckbox
        //                 //text:       net[index].name
        //                 checked:    net[index].checked 
        //                 onCheckedChanged: {
        //                     if (!data.loading) {
        //                         // Update the specific net entry
        //                         net[index] = Object.assign({}, net[index], { checked: checked });

        //                         // Check if all individual checkboxes are checked
        //                         let allChecked = true;
        //                         for (let i = 0; i < net.length; i++) {
        //                             if (!net[i].checked) {
        //                                 allChecked = false;
        //                                 break;
        //                             }
        //                         }

        //                         // Update the "All" checkbox state only if it has changed
        //                         if (allNetworksChecked.checked !== allChecked) {
        //                             allNetworksChecked.checked = allChecked;
        //                         }
        //                         net = net; // Reassign the array to trigger bindings

        //                         cfg_netSources = netSourceEncode(net)
        //                         cfg_netSourcesChanged();    // SETS NEW VALUES IN MAIN 
        //                     }
        //                 }
        //             }
        //             Label {
        //                 text: { 
        //                     if (interfaceCheckbox.checked) {
        //                         return "<pre>[ <b>" + net[index].name + "</b> ]  monitoring <font color='green'><b>enabled</b></font></pre>"
        //                     } else {
        //                         return "<pre>[ " + net[index].name + " ]  monitoring <font color='red'><b>disabled</b></font></pre>"
        //                     }
        //                 }//"Enable Interface  "
        //                 textFormat: Text.RichText // Enable rich text formatting for bold text
        //                 height: interfaceCheckbox.height
        //             }


        //         }
        //     }
        // }

        // ListModel {
        //     id: sources
        // }

        Dbus {
            id : dbus1
        }
        
        Component.onCompleted: {
            net = netSourceDecode(cfg_netSources)
            //det = netSourceDecode(cfg_netDetails)

            // Populate the ListModel
            netInterfaceModel.clear(); // Clear any existing data
            for (let i = 0; i < net.length; i++) {
                netInterfaceModel.append(net[i]);
            }
            dataLoading = false          
        }
    }
}