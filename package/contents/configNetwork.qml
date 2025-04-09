/*
 * Copyright 2024  LeeVD <thoth360@hotmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 3 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
//import org.kde.plasma.core 2.0 as PlasmaCore
import DbusModel

import QtQuick.Dialogs

Item {
    // configNetwork.qml >>> plasmoid.configuration
    property var cfg_netSources: netSources   
    property var cfg_netDetails: netDetails

    //################## SERIALISATION FIX ###########################
    property var net: []
    property var det: []

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

    function updateNetChecked(index, value) {
        net[index].checked = value;
        net = net; // Reassign the array to trigger bindings
    }

    //################################################################

    GridLayout {
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
        QtObject {
            id: data
            property bool loading: false
        }

        ColumnLayout {
            // Master entry = All
            Row {
                CheckBox {
                    id: interfaceCheckbox_all
                    //text:       net[index].name
                    checked:    net[0].checked 
                    onCheckedChanged: {
                        if (!data.loading) {
                            net[0].checked = checked
                            // Update all interfaceCheckbox entries
                            for (let i = 1; i < net.length; i++) {
                                net[i].checked = checked
                            }
                            net = net; // Reassign the array to trigger bindings

                            cfg_netSources = netSourceEncode(net)
                            cfg_netSourcesChanged();    // SETS NEW VALUES IN MAIN 
                        }
                    }
                }
                Label {
                    text: { 
                        if (interfaceCheckbox_all.checked) {
                            return "<pre>[ <b>" + net[0].name + "</b> ]  monitoring <font color='green'><b>enabled</b></font></pre>"
                        } else {
                            return "<pre>[ " + net[0].name + " ]  monitoring <font color='red'><b>disabled</b></font></pre>"
                        }
                    }//"Enable Interface  "
                    textFormat: Text.RichText // Enable rich text formatting for bold text
                    height: interfaceCheckbox_all.height
                }
            }
            Repeater {
                model:          net.length   //sources
                Row {
                    visible: index !== 0 // Skip rendering for entry 0
                    Layout.leftMargin: 20 // Indent the row forward
                    Layout.alignment: Qt.AlignLeft // Align the row to the left
                    // spacing: 10 // Add spacing between the CheckBox and Label
                    CheckBox {
                        id: interfaceCheckbox
                        //text:       net[index].name
                        checked:    net[index].checked 
                        onCheckedChanged: {
                            if (!data.loading) {
                                net[index].checked = checked

                                // Check if all checkboxes are checked
                                let allChecked = true
                                for (let i = 1; i < net.length; i++) {
                                    if (!net[i].checked) {
                                        allChecked = false
                                        break
                                    }
                                }
                                net[0].checked = allChecked // Update interfaceCheckbox_all
                                net = net; // Reassign the array to trigger bindings

                                cfg_netSources = netSourceEncode(net)
                                cfg_netSourcesChanged();    // SETS NEW VALUES IN MAIN 
                            }
                        }
                    }
                    Label {
                        text: { 
                            if (interfaceCheckbox.checked) {
                                return "<pre>[ <b>" + net[index].name + "</b> ]  monitoring <font color='green'><b>enabled</b></font></pre>"
                            } else {
                                return "<pre>[ " + net[index].name + " ]  monitoring <font color='red'><b>disabled</b></font></pre>"
                            }
                        }//"Enable Interface  "
                        textFormat: Text.RichText // Enable rich text formatting for bold text
                        height: interfaceCheckbox.height
                    }


                }
            }
        }

        ListModel {
            id: sources
        }

        Dbus {
            id : dbus1
        }
        
        Component.onCompleted: {
            net = netSourceDecode(cfg_netSources)
            //det = netSourceDecode(cfg_netDetails)
        }
    }
}