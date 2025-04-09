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
 
 // useful:
 // Run widget:
 // plasmoidviewer -a org.kde.nbm_wip -l topedge -f horizontal 
 // serialised settings:
 // home/user/.config/plasmoidviewer-appletsrc

import org.kde.plasma.components as PlasmaComponents    // used in tooltip section
//import org.kde.plasma.extras as PlasmaExtras            // used in tooltip section

//plasma6
import QtQuick
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import QtQuick.Layouts
import org.kde.plasma.plasmoid

Item {
    id: itemParent
    anchors.fill: parent

    property double marginFactor: 0.2

    // PRIMARY UI INTERFACE DATA VARIABLES 
    property double downSpeed: 0
    property double upSpeed: 0

    property bool singleLine: {
        if (!showSeparately) {
            return true
        }
        switch (speedLayout) {
            case 'row':    return true      // SIDE BY SIDE
            case 'column': return false     // ONE ABOVE OTHER
            default:        return height / 2 * fontSizeScale < Kirigami.Theme.smallFont.pixelSize && plasmoid.formFactor !== PlasmaCore.Types.Vertical
        }
    }

    property double marginWidth:        speedTextMetrics.font.pixelSize * marginFactor
    property double iconWidth:          showIcons ? iconTextMetrics.width + marginWidth : 0
    property double doubleIconWidth:    showIcons ? (doubleIconTextMetrics.width + marginWidth) : 0
    property double speedWidth:         speedTextMetrics.width + 2*marginWidth
    property double unitWidth:          showUnits ? unitTextMetrics.width + marginWidth : 0

    //property double toolTipWidth:       showTooltip ? TextMetrics2 : 0 


    property double aspectRatio: {
        if (showSeparately) {
            if (singleLine) {
                return (2*iconWidth + 2*speedWidth + 2*unitWidth + marginWidth) * fontSizeScale / speedTextMetrics.height
            } else {
                return (iconWidth + speedWidth + unitWidth) * fontSizeScale / (2*speedTextMetrics.height)
            }
        } else {
            return (doubleIconWidth + speedWidth + unitWidth) * fontSizeScale / speedTextMetrics.height
        }
    }

    property double fontHeightRatio: speedTextMetrics.font.pixelSize / speedTextMetrics.height

    property double offset: {
        if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
            return (width - height * aspectRatio) / 2
        } else {
            return 0
        }
    }

    property bool boolUnits: {
        if (speedUnits !== 'bits')  return false;
        else                        return true;     
    }

    property double getBinDec: {
        if (binaryDecimal === 'binary')     return 1024;    // binary
        else                                return 1000;    // decimal
    }

    Layout.minimumWidth: {
        if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
            return 0
        } else if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
            return Math.ceil(height * aspectRatio)
        } else {
            return Math.ceil(height * aspectRatio)
        }
    }
    Layout.minimumHeight: {
        if (plasmoid.formFactor === PlasmaCore.Types.Vertical) {
            return Math.ceil(width / aspectRatio * fontSizeScale * fontSizeScale)
        } else if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
            return 0
        } else {
            return Math.ceil(Kirigami.Theme.smallFont.pixelSize / fontSizeScale)
        }
    }

    Layout.preferredWidth:  Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    TextMetrics {
        id: iconTextMetrics
        text: iconStyle(1)
        font.pixelSize: 64
    }

    TextMetrics {
        id: doubleIconTextMetrics
        text: iconStyle(2)
        font.pixelSize: 64
    }

    TextMetrics {
        id: speedTextMetrics
        text: getDecimalPlace()      //'1000.0'
        font.pixelSize: 64    
    }

    TextMetrics {
        id: unitTextMetrics
        text: {
            if (speedUnits === 'bits') {
                return shortUnits ? 'm' : 'Mib/s'
            } else {
                return shortUnits ? 'M' : 'MiB/s'
            }
        }
        font.pixelSize: 64
    }

    Item {
        id: offsetItem
        width: offset
        height: parent.height
        x: 0
        y: 0
    }
    // USED TO GET THE CURRENT THEME COLOR - Theme.textColor OR ColorScope.textColor DOESNT WORK CORRECTLY
    SystemPalette { 
        id: myPalette; 
        colorGroup: SystemPalette.Active 
    }

    // USED FOR TESTING UI
    // Rectangle{
    //     id: rec_t1
    //     height:             dataShown('t1', 'height') 
    //     width:              dataShown('t1', 'width') 
    //     anchors.left:       dataShown('t1', 'anchorL') 
    //     anchors.leftMargin: dataShown('t1', 'anchorLMargin') 
    //     y:                  dataShown('t1', 'y') 
    //     visible:            true //dataShown('t1', 'visible')
    //     color: "red"
    // }
    // Rectangle{
    //     id: rec_t2
    //     height:             dataShown('t2', 'height') 
    //     width:              dataShown('t2', 'width') 
    //     anchors.left:       dataShown('t2', 'anchorL') 
    //     anchors.leftMargin: dataShown('t2', 'anchorLMargin') 
    //     y:                  dataShown('t2', 'y') 
    //     visible:            true //dataShown('t2', 'visible')
    //     color: "blue"
    // }
    // Rectangle{
    //     id: rec_t3
    //     height:             dataShown('t3', 'height') 
    //     width:              dataShown('t3', 'width') 
    //     anchors.left:       dataShown('t3', 'anchorL') 
    //     anchors.leftMargin: dataShown('t3', 'anchorLMargin') 
    //     y:                  dataShown('t3', 'y') 
    //     visible:            true //dataShown('t3', 'visible')
    //     color: "green"
    // }

    // Rectangle{
    //     id: rec_b1
    //     height:             dataShown('b1', 'height') 
    //     width:              dataShown('b1', 'width') 
    //     anchors.left:       dataShown('b1', 'anchorL') 
    //     anchors.leftMargin: dataShown('b1', 'anchorLMargin') 
    //     y:                  dataShown('b1', 'y') 
    //     visible:            true //dataShown('b1', 'visible')
    //     color: "dark blue"
    // }
    // Rectangle{
    //     id: rec_b2
    //     height:             dataShown('b2', 'height') 
    //     width:              dataShown('b2', 'width') 
    //     anchors.left:       dataShown('b2', 'anchorL') 
    //     anchors.leftMargin: dataShown('b2', 'anchorLMargin') 
    //     y:                  dataShown('b2', 'y') 
    //     visible:            true //dataShown('b2', 'visible')
    //     color: "purple"
    // }
    // Rectangle{
    //     id: rec_b3
    //     height:             dataShown('b3', 'height') 
    //     width:              dataShown('b3', 'width') 
    //     anchors.left:       dataShown('b3', 'anchorL') 
    //     anchors.leftMargin: dataShown('b3', 'anchorLMargin') 
    //     y:                  dataShown('b3', 'y') 
    //     visible:            true //dataShown('b3', 'visible')
    //     color: "pink"
    // }

    Text {
        id: t1 //topIcon
        //height:             dataShown('t1', 'height') 
        width:              dataShown('t1', 'width') 
        verticalAlignment:  dataShown('t1', 'vertiAlign') 
        horizontalAlignment:dataShown('t1', 'horizAlign') 
        anchors.left:       dataShown('t1', 'anchorL') 
        anchors.leftMargin: dataShown('t1', 'anchorLMargin') 
        y:                  dataShown('t1', 'y') 
        font.pixelSize:     dataShown('t1', 'fontPixSize') 
        renderType:         dataShown('t1', 'renderType') 
        text:               dataShown('t1', 'text')  
        color:              dataShown('t1', 'color') 
        visible:            dataShown('t1', 'visible') 
        bottomPadding:      dataShown('t1', 'padding') //-10.0
    }

    Text {
        id: t2 //topText
        //height:             dataShown('t2', 'height') 
        width:              dataShown('t2', 'width') 
        verticalAlignment:  dataShown('t2', 'vertiAlign') 
        horizontalAlignment:dataShown('t2', 'horizAlign') 
        anchors.left:       dataShown('t2', 'anchorL') 
        anchors.leftMargin: dataShown('t2', 'anchorLMargin') 
        y:                  dataShown('t2', 'y') 
        font.pixelSize:     dataShown('t2', 'fontPixSize') 
        renderType:         dataShown('t2', 'renderType') 
        text:               dataShown('t2', 'text')  
        color:              dataShown('t2', 'color') 
        visible:            dataShown('t2', 'visible')  
        bottomPadding:      dataShown('t2', 'padding') //-10.0
    }

    Text {
        id: t3 //topUnitText
        //height:             dataShown('t3', 'height') 
        width:              dataShown('t3', 'width') 
        verticalAlignment:  dataShown('t3', 'vertiAlign') 
        horizontalAlignment:dataShown('t3', 'horizAlign') 
        anchors.left:       dataShown('t3', 'anchorL') 
        anchors.leftMargin: dataShown('t3', 'anchorLMargin') 
        y:                  dataShown('t3', 'y') 
        font.pixelSize:     dataShown('t3', 'fontPixSize') 
        renderType:         dataShown('t3', 'renderType') 
        text:               dataShown('t3', 'text')  
        color:              dataShown('t3', 'color') 
        visible:            dataShown('t3', 'visible')
        bottomPadding:      dataShown('t3', 'padding') //-10.0
    }

    Text {
        id: b1 //bottomIcon
        //height:             dataShown('b1', 'height') 
        width:              dataShown('b1', 'width') 
        verticalAlignment:  dataShown('b1', 'vertiAlign') 
        horizontalAlignment:dataShown('b1', 'horizAlign') 
        anchors.left:       dataShown('b1', 'anchorL') 
        anchors.leftMargin: dataShown('b1', 'anchorLMargin') 
        y:                  dataShown('b1', 'y') 
        font.pixelSize:     dataShown('b1', 'fontPixSize') 
        renderType:         dataShown('b1', 'renderType') 
        text:               dataShown('b1', 'text')  
        color:              dataShown('b1', 'color') 
        visible:            dataShown('b1', 'visible') 
        topPadding:         dataShown('b1', 'padding') //-10.0
        //bottomPadding: 30.0
        //topPadding: -10.0
    }

    Text {
        id: b2 //bottomText    
        //height:             dataShown('b2', 'height') 
        width:              dataShown('b2', 'width') 
        verticalAlignment:  dataShown('b2', 'vertiAlign') 
        horizontalAlignment:dataShown('b2', 'horizAlign') 
        anchors.left:       dataShown('b2', 'anchorL') 
        anchors.leftMargin: dataShown('b2', 'anchorLMargin') 
        y:                  dataShown('b2', 'y') 
        font.pixelSize:     dataShown('b2', 'fontPixSize') 
        renderType:         dataShown('b2', 'renderType') 
        text:               dataShown('b2', 'text')  
        color:              dataShown('b2', 'color') 
        visible:            dataShown('b2', 'visible') 
        topPadding:         dataShown('b2', 'padding') //-10.0
    }

    Text {
        id: b3 //bottomUnitText
        //height:             dataShown('b3', 'height') 
        width:              dataShown('b3', 'width') 
        verticalAlignment:  dataShown('b3', 'vertiAlign') 
        horizontalAlignment:dataShown('b3', 'horizAlign') 
        anchors.left:       dataShown('b3', 'anchorL') 
        anchors.leftMargin: dataShown('b3', 'anchorLMargin') 
        y:                  dataShown('b3', 'y') 
        font.pixelSize:     dataShown('b3', 'fontPixSize') 
        renderType:         dataShown('b3', 'renderType') 
        text:               dataShown('b3', 'text')  
        color:              dataShown('b3', 'color') 
        visible:            dataShown('b3', 'visible') 
        topPadding:         dataShown('b3', 'padding') //-10.0
    }
    
    // CPU TEST
    // ToolButton {
    //     id: cpuIcon
    //     icon.name: 'show-gpu-effects'
    //     width: 20
    //     height: t3.height + b3.height
    //     anchors.left: t3.right
    //     enabled: false

    // }

    // Text {
    //     // CPU frequency
    //     id: cpuFrequency
    //     height: t2.height
    //     width: t2.width
    //     anchors.left: cpuIcon.right
    //     text: "2.4 GHz"
    //     color:              dataShown('t3', 'color')
    //     font.pixelSize:     dataShown('t3', 'fontPixSize')
    //     verticalAlignment:  dataShown('t3', 'vertiAlign') 
    //     horizontalAlignment:dataShown('t3', 'horizAlign')   
    //     y:                  dataShown('t3', 'y')  
    //     renderType:         dataShown('t3', 'renderType')    
    // }
    // Text {
    //     // CPU frequency
    //     id: cpuTemp
    //     height: t2.height
    //     width: t2.width
    //     anchors.top: cpuFrequency.bottom
    //     anchors.left: cpuIcon.right
    //     text:         netInformation[0].ip // showIP
    //     color:              dataShown('b3', 'color')
    //     font.pixelSize:     dataShown('b3', 'fontPixSize')
    //     verticalAlignment:  dataShown('b3', 'vertiAlign') 
    //     horizontalAlignment:dataShown('b3', 'horizAlign') 
    //     y:                  dataShown('b3', 'y')        
    //     renderType:         dataShown('b3', 'renderType')
    // }

    // PlasmaCore.ToolTipArea {
    //     enabled: false
    //     anchors.fill: parent
    //     interactive: true
    //     mainText: i18n("Network Bandwidth Monitor")
    //     subText: i18n("DBUS Data Source")
    //     icon: 'network-connect'        
    // }
    // PlasmaCore.ToolTipArea {
    //     mainText: i18n("Tooltip Title")
    //     subText: i18n("Some explanation.")
    //     icon: "plasma"
    //     // alternatively, you can specify your own component
    //     // to be loaded when the tooltip shows
    //     mainItem: YourCustomItem { }
    // }
    // PlasmaCore.ToolTipArea {
    //     id: toolTipArea
    //     anchors.fill: parent
    //     mainText: "Tooltip Title"
    //     subText: "Some explanation."
    //     icon: "plasma"
    //     // Custom component for the tooltip
    //     width: 500
    //     height: 300
    //     mainItem: Item {
    //         width: 500
    //         height: 300
    //         PlasmaComponents.Button {
    //             text: "Click me"
    //             anchors.centerIn: parent
    //             onClicked: {
    //                 console.log("Button clicked!")
    //             }
    //         }
    //     }
    // }

    function dataShown(caller, properties){
        var height = singleLine ? itemParent.height : itemParent.height / 2
        var fontPixelSize =  height * fontHeightRatio * fontSizeScale

        if (iconPosition === true) {                            // true = icons on right
            // DIFFERENT VARIABLES WITH ICONS ON RIGHT
            switch (properties) {               
                case 'width':
                    var a = (showSeparately ? 1 : 2) * iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    var b = speedTextMetrics.width / speedTextMetrics.height * height * fontSizeScale
                    var c = unitTextMetrics.width / unitTextMetrics.height * height * fontSizeScale
                    var d = iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    switch (caller) {
                        case 't1': return b                     //a
                        case 't2': return c                     //b
                        case 't3': return a                     //c
                        case 'b1': return b                     //d
                        case 'b2': return c                     //b
                        case 'b3': return d                     //c
                    }  
                case 'horizAlign':
                    switch (caller) {
                        // left : text in t2 & b2  |  right : text in t1 & b1  |  left Alt : see left
                        case 't1': return Text.AlignRight
                        case 't2': return Text.AlignLeft
                        case 't3': return Text.AlignHCenter //Text.AlignVCenter
                        case 'b1': return Text.AlignRight
                        case 'b2': return Text.AlignLeft
                        case 'b3': return Text.AlignHCenter //Text.AlignVCenter
                    }   
                case 'anchorL':
                    switch (caller) {
                        case 't1': return offsetItem.right
                        case 't2': return t1.right
                        case 't3': return showUnits ? t2.right : t1.right
                        case 'b1': return anchorLfunction()     //(singleLine && showIcons) ? t3.right : (singleLine ? t2.right : offsetItem.right) //showIcon
                        case 'b2': return b1.right
                        case 'b3': return showUnits ? b2.right : b1.right
                    } 
                case 'fontPixSize':
                    switch (caller) {
                        case 't1': return Math.round(height * fontHeightRatio * fontSizeScale ) // needs to return int not float
                        case 't2': return Math.round(height * fontHeightRatio * sufixSize )
                        case 't3': return Math.round(height * fontHeightRatio * iconSize);
                        case 'b1': return Math.round(height * fontHeightRatio * fontSizeScale )
                        case 'b2': return Math.round(height * fontHeightRatio * sufixSize )
                        case 'b3': return Math.round(height * fontHeightRatio * iconSize)
                    }
                case 'text':
                    switch (caller) {
                        case 't1': return speedDisplay('number', showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 't2': return speedDisplay('suffix', showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 't3': return showSeparately ? (swapDownUp ? iconStyle(0) : iconStyle(1)) : iconStyle(2)
                        case 'b1': return speedDisplay('number', swapDownUp ? downSpeed : upSpeed)
                        case 'b2': return speedDisplay('suffix', swapDownUp ? downSpeed : upSpeed)
                        case 'b3': return swapDownUp ? iconStyle(1) : iconStyle(0)
                    }  
                case 'visible':  
                    return setUiVisible(caller)
            }
        } else {                                                // false = icons on left [default]
            // DIFFERENT VARIABLES WITH ICONS ON LEFT
            switch (properties) {
                case 'width':
                    var leftUpIconWidth = (showSeparately ? 1 : 2) * iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    var leftTextWidth = speedTextMetrics.width / speedTextMetrics.height * height * fontSizeScale
                    var leftUnitWidth = unitTextMetrics.width / unitTextMetrics.height * height * fontSizeScale
                    var leftDownIconWidth = iconTextMetrics.width / iconTextMetrics.height * height * fontSizeScale
                    switch (caller) {
                        case 't1': return leftUpIconWidth       // icon
                        case 't2': return leftTextWidth         // text
                        case 't3': return leftUnitWidth         // unit
                        case 'b1': return leftDownIconWidth     // icon
                        case 'b2': return leftTextWidth         // text
                        case 'b3': return leftUnitWidth         // unit
                    }      
                case 'horizAlign':
                    switch (caller) {
                        // left : text in t2 & b2  |  right : text in t1 & b1  |  left Alt : see left
                        case 't1': return Text.AlignHCenter //Text.AlignVCenter
                        case 't2': return Text.AlignRight
                        case 't3': return Text.AlignLeft
                        case 'b1': return Text.AlignHCenter //Text.AlignVCenter
                        case 'b2': return Text.AlignRight
                        case 'b3': return Text.AlignLeft
                    }  
                case 'anchorL':
                    switch (caller) {
                        case 't1': return offsetItem.right
                        case 't2': return showIcons ? t1.right : offsetItem.right
                        case 't3': return t2.right
                        
                        case 'b1': return (singleLine && showUnits) ? t3.right : (singleLine ? t2.right : offsetItem.right)
                        case 'b2': return showIcons ? b1.right : ((singleLine && showUnits) ? t3.right : (singleLine ? t2.right : offsetItem.right))
                        case 'b3': return b2.right
                    }
                case 'fontPixSize':
                    switch (caller) {
                        case 't1': return Math.round(height * fontHeightRatio * iconSize) // needs to return int not float
                        case 't2': return Math.round(height * fontHeightRatio * fontSizeScale )
                        case 't3': return Math.round(height * fontHeightRatio * sufixSize )
                        case 'b1': return Math.round(height * fontHeightRatio * iconSize)
                        case 'b2': return Math.round(height * fontHeightRatio * fontSizeScale )
                        case 'b3': return Math.round(height * fontHeightRatio * sufixSize )
                    }
                case 'text':
                    switch (caller) {
                        case 't1': return showSeparately ? (swapDownUp ? iconStyle(0) : iconStyle(1)) : iconStyle(2)
                        case 't2': return speedDisplay('number', showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)      //speedDisplay(section, value) 
                        case 't3': return speedDisplay('suffix', showSeparately ? (swapDownUp ? upSpeed : downSpeed) : downSpeed + upSpeed)
                        case 'b1': return swapDownUp ? iconStyle(1) : iconStyle(0)
                        case 'b2': return speedDisplay('number', swapDownUp ? downSpeed : upSpeed)
                        case 'b3': return speedDisplay('suffix', swapDownUp ? downSpeed : upSpeed)
                    } 
                case 'visible':  
                    return setUiVisible(caller)
            }
        }
        // SAME VARIABLES WITH ICONS EITHER SIDE
        switch (properties) {
            //case 'height': return  singleLine ? itemParent.parent.height : itemParent.parent.height / 2
            case 'vertiAlign': //return  Text.AlignVCenter Text.AlignTop
                switch (caller) {
                    case 't1': return Text.AlignVCenter //Text.AlignBottom          
                    case 't2': return Text.AlignVCenter //Text.AlignBottom          
                    case 't3': return Text.AlignVCenter //Text.AlignBottom          
                    case 'b1': return Text.AlignVCenter //Text.AlignTop             
                    case 'b2': return Text.AlignVCenter //Text.AlignTop              
                    case 'b3': return Text.AlignVCenter //Text.AlignTop             
                }  
            case 'anchorLMargin': return fontPixelSize * marginFactor
            case 'y':
                switch (caller) {
                    case 't1': return 0
                    case 't2': return 0
                    case 't3': return 0
                    case 'b1': return singleLine ? 0 : itemParent.height / 2
                    case 'b2': return singleLine ? 0 : itemParent.height / 2
                    case 'b3': return singleLine ? 0 : itemParent.height / 2
                }    
            case 'renderType': return Text.NativeRendering
            case 'color': return uiColors(caller) 
            case 'padding': return layoutPadding    
        }    
    }

    function uiColors(caller) {
        //console.log("### uiColor START #############################################")
        // CONSIDERATIONS:
        // 1. MANUAL COLORS 
        // 2. COLOR BY BANDWIDTH (B KB MB GB)
        // 3. POSITION OF THE UI:
        //      VARS: 
        //          iconPosition (true-right | false-left)
        //          swapDownUp (true false) - doesnt matter for speedColour
        //          speedLayout ('auto', 'column', 'row') - doesnt matter here
        let suffixText = "";

        if (colorDefault) {
            return defaultTheme()
        } else {
            // WE DONT CARE ABOUT swapDownUp, WE JUST REFERENCE TOP OR BOTTOM ROWS 
            // DETERMINE WHAT ROW WE NEED TO TARGET, THEN
            // SET SUFFIXTEXT VAR BASED ON ICON POSITION 
            
            if (!iconPosition) {    // ICONS ON LEFT 
                    if (caller.includes('t')) {
                        suffixText = t3.text.toLowerCase().charAt(0);
                    } else if (caller.includes('b')) {
                        suffixText = b3.text.toLowerCase().charAt(0);
                    }
            } else {                // ICONS ON RIGHT
                if (caller.includes('t')) {
                    suffixText = t2.text.toLowerCase().charAt(0);
                } else if (caller.includes('b')) {
                    suffixText = b2.text.toLowerCase().charAt(0);
                }
            }
            //console.log("caller:",caller,"suffixText:",suffixText,"speedColorActive1:",speedColorActive1,"speedColorActive2:",speedColorActive2,"speedColorActive3:",speedColorActive3)            

            // CALLED BY TEXT ELEMENTS | iconPosition //  true = right                                  | false = left
            if (caller === 't1') { // column 1 row 1                                                 
                return iconPosition ? (speedColorActive2 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // digit   
                                    : (speedColorActive1 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // icon
            }
            if (caller === 'b1') { // column 1 row 2                                     
                return iconPosition ? (speedColorActive2 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // digit 
                                    : (speedColorActive1 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // icon
            }
            if (caller === 't2') { // column 2 row 1              
                return iconPosition ? (speedColorActive3 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // suffix   
                                    : (speedColorActive2 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // digits
            }
            if (caller === 'b2') { // column 2 row 2                         
                return iconPosition ? (speedColorActive3 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // suffix 
                                    : (speedColorActive2 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // digits
            }

            if (caller === 't3') { // column 3 row 1                                         
                return iconPosition ? (speedColorActive1 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // icon 
                                    : (speedColorActive3 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // suffix
            }
            if (caller === 'b3') { // column 3 row 2                                                   
                return iconPosition ? (speedColorActive1 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // icon    
                                    : (speedColorActive3 ? speedColors(suffixText) : baseColor(caller) || defaultTheme())   // suffix
            }
        }            
    }

    function speedColors(suffixText) {    // TEXT.CELL / (K)ib/s / ICONS - DIGITS - SUFFIX
        // THIS FUNCTION ONLY GETS CALLED IF defaultColor = FALSE & speedColorActive1,2,3 are activated
        // color_X_square SUPERCEED color_X# COLORS
        // ICONS ON LEFT: color_b_square IN DIGITS CELL SUPERCEEDS colorDownDigits. 

        if (suffixText === 'b') { 
            return color_b_square ? color_b_square : defaultTheme()
        } else if (suffixText === 'k') { 
            return color_k_square ? color_k_square : defaultTheme()
        } else if (suffixText === 'm') { 
            return color_m_square ? color_m_square : defaultTheme()
        } else if (suffixText === 'g') { 
            return color_g_square ? color_g_square : defaultTheme()
        }      
    }

    function baseColor(caller){
        //console.log(" ## base color function:" )
        //          iconPosition (true-right | false-left [default])
        //          swapDownUp (true - t:up/b:down | false - t:down/b:up [default])
        //                          true/right | false/left
        if (caller === 't1') {
            return swapDownUp ? (iconPosition ? colorUpDigits : colorUpIcon) : (iconPosition ? colorDownDigits : colorDownIcon) 
        }
        if (caller === 't2') {
            return swapDownUp ? (iconPosition ? colorUpSuffix : colorUpDigits) : (iconPosition ? colorDownSuffix : colorDownDigits) 
        }
        if (caller === 't3') {
            return swapDownUp ? (iconPosition ? colorUpIcon : colorUpSuffix) : (iconPosition ? colorDownIcon : colorDownSuffix) 
        }        
        if (caller === 'b1') {
            return swapDownUp ? (iconPosition ? colorDownDigits : colorDownIcon) : (iconPosition ? colorUpDigits : colorUpIcon) 
        }
        if (caller === 'b2') {
            return swapDownUp ? (iconPosition ? colorDownSuffix : colorDownDigits) : (iconPosition ? colorUpSuffix : colorUpDigits) 
        }
        if (caller === 'b3') {
            return swapDownUp ? (iconPosition ? colorDownIcon : colorDownSuffix) : (iconPosition ? colorUpIcon : colorUpSuffix) 
        }
    }

    function defaultTheme() {
        //console.log(" ## default theme function:", myPalette.windowText )
        return myPalette.windowText  
    }

    function setUiVisible(caller) {
        // UI ELEMENTS VISIBLE BASED ON hideInactive
        if (hideInactive === true) {
            if (downSpeed === 0 && upSpeed === 0) {
                t1.visible = false
                t2.visible = false
                t3.visible = false            
                b1.visible = false
                b2.visible = false
                b3.visible = false
            } else {
                t1.visible = iconPosition ? true : showIcons
                t2.visible = iconPosition ? showUnits : true
                t3.visible = iconPosition ? showIcons : showUnits
                b1.visible = iconPosition ? showSeparately : showSeparately && showIcons
                b2.visible = iconPosition ? showSeparately && showUnits : showSeparately
                b3.visible = iconPosition ? showSeparately && showIcons : showSeparately && showUnits
            }
        } else {
            // UI ELEMENTS VISIBLE BASED ON iconPosition
            t1.visible = iconPosition ? true : showIcons
            t2.visible = iconPosition ? showUnits : true
            t3.visible = iconPosition ? showIcons : showUnits
            b1.visible = iconPosition ? showSeparately : showSeparately && showIcons
            b2.visible = iconPosition ? showSeparately && showUnits : showSeparately
            b3.visible = iconPosition ? showSeparately && showIcons : showSeparately && showUnits
        }
        switch (caller) {
            case 't1': return iconPosition ? true : showIcons
            case 't2': return iconPosition ? showUnits : true
            case 't3': return iconPosition ? showIcons : showUnits
            case 'b1': return iconPosition ? showSeparately : showSeparately && showIcons
            case 'b2': return iconPosition ? showSeparately && showUnits : showSeparately
            case 'b3': return iconPosition ? showSeparately && showIcons : showSeparately && showUnits
        }  
    }


    function anchorLfunction() {
        switch (singleLine) {
            case false :    // one above other
                return offsetItem.right

            case true :     // side by side
                // return showUnits ? (showIcons ? t3.right : t2.right) : (showIcons ? t3.right : t1.right)
                switch (showUnits) {
                    case false : 
                        if (showIcons === false)    return t1.right
                        else                        return t3.right
                        // return showIcons ? t3.right : t1.right
                    case true :
                        if (showIcons === false)    return t2.right
                        else                        return t3.right
                        // return showIcons ? t3.right : t2.right
                }
        }
    }


    function iconStyle(a) {

        var iconArray = []

        iconArray = iconType.replace(' ', ',').split(",")

        switch(a) {
            case 0: return iconArray[1] 
            case 1: return iconArray[0]
            case 2: return iconArray[1] + iconArray[0]
        }
    }


    function getDecimalPlace() {
        return Number.parseFloat('1000').toFixed( decimalPlace );
    }


    function customRound(number) {
        var decimalPart = number - Math.floor(number);
        if (decimalPart >= 0.445) {
            return Math.ceil(number);
        } else {
            return Math.floor(number);
        }
    }

    function decimalPlaceLogic(value){
        return value === 0 ? (ignoreDecimalIdle ? 0 : decimalPlace) : decimalPlace
    }

    function speedBit(section, value, bit) {
        // console.log("speedBit()", section, "value:", value, "bit:", value)
        // console.log("...")
        if (section === 'number') return decimalFilter0 ? value.toFixed(decimalPlaceLogic(value)) : value; // result = '' if less than a Kx 
        else return shortUnits ? (boolUnits ? 'b' : 'B') : suffix('b') 
    }

    function speedKil(section, value, kil) {
        // console.log("speedKil()", section, "value:", value, "kil:", value/kil)
        // console.log("...")
        var calValue = value/kil || 0
        if (section === 'number') return decimalFilter1 ? calValue.toFixed(decimalPlaceLogic(value)) : customRound(calValue); // return Kx if less than a Mx
        else return shortUnits ? (boolUnits ? 'k' : 'K') : suffix('k') 
    }

    function speedMeg(section, value, meg) {
        // console.log("speedMeg()", section, "value:", value, "meg:", value/meg)
        // console.log("...")
        var calValue = value/meg || 0
        if (section == 'number') return decimalFilter2 ? calValue.toFixed(decimalPlaceLogic(value)) : customRound(calValue); // return Mx if less than a Gx
        else return shortUnits ? 'M' : suffix('M')
    }

    function speedGig(section, value, gig) {
        // console.log("speedGig()", section, "value:", value, "bit:", value/gig)
        // console.log("...")
        var calValue = value/gig || 0
        if (section === 'number') return decimalFilter3 ? calValue.toFixed(decimalPlaceLogic(value)) : customRound(calValue); // return Gx if less than a Gx
        else return shortUnits ? 'G' : suffix('G')
    }

    function speedTer(section, value, ter) {
        // console.log("speedTer()", section, "value:", value, "bit:", value/ter)
        // console.log("...")
        var calValue = value/ter || 0
        if (section === 'number') return decimalFilter3 ? calValue.toFixed(decimalPlaceLogic(value)) : customRound(calValue); // return Tx if less than a Tx
        else return shortUnits ? 'T' : suffix('T') 
    }
    // FUNNEL THE REQUEST TO APPROPRIATE SPEED UNIT FUNCTIONS
    function speedUnitRange(units, section, value, calcUnits) {

        const speedUnits = [speedBit, speedKil, speedMeg, speedGig, speedTer];
        for (let i = 0; i < units.length; i++) {
            if (units[i]) return speedUnits[i](section, value, calcUnits[i]);
        }
    }
    
    function speedDisplay(section, value) {
        // data communication 1 kilobit = 1000 bits, while in data storage 1 Kilobyte = 1024 Bytes
        var m   = getBinDec                    // binary 1024 | decimal 1000
        //var dec = decimalPlace                 // # of decimal places
        // BIT CONVERSION TO HIGHER PREFIXES
        const kil = m;                           // One K is 1024  b/B    1024            1000
        const meg = m * m;                       // One M is 1024 Kb/B    1048576         1000000
        const gig = m * m * m;                   // One G is 1024 Mb/B    1073741824      1000000000
        const ter = m * m * m * m;               // One T is 1024 Gb/B    1099511627776   1000000000000
        const calcUnits  = [null, kil, meg, gig, ter]

        // NEW THRESHOLD : 4 DIGITS ALLOWED
        const fourb = 10000;
        const fourk = 10000000;
        const fourm = 10000000000;
        const fourg = 10000000000000;
        const fourt = 10000000000000000;

        var result;
        //var digitNum = value.toString().length; 

        if (roundedNumber === 3) {
            var b, k, m, g, t
            b = null
            k = kil
            m = meg
            g = gig
            t = ter
        } else {
            b = fourb
            k = fourk
            m = fourm
            g = fourg
            t = fourt
        }

        if (value < k) {
            //console.log("value 0 && value < k", value)
            return speedUnitRange([speedUnitB, speedUnitK, speedUnitM, speedUnitG], section, value, calcUnits);
        } else if (value => k && value < m) {
            //console.log("value => k && value < m", value)
            return speedUnitRange([null,       speedUnitK, speedUnitM, speedUnitG], section, value, calcUnits);
        } else if (value => m && value < g) {
            //console.log("value => m && value < g", value)
            return speedUnitRange([null,       null,       speedUnitM, speedUnitG], section, value, calcUnits);
        } else if (value => g && value < t) {
            //console.log("value => g && value < t", value)
            return speedUnitRange([null,       null,       null,       speedUnitG], section, value, calcUnits);
        } else if (value > t) {
            //console.log("speedTer", value);
            return speedTer(section, value, calcUnits);
        }
    }


    function suffix(unit) { // NEW SOLUTION TO SUFFIX
        // https://en-academic.com/dic.nsf/enwiki/8315069#Kibibit_per_second
        //! BINARY:                   DECIMAL:
        //! Kibibit = 1024 bits    |  Kilobit = 1000 bits
        //! Kibibyte = 1024 bytes  |  Kilobyte = 1000 bytes
        //! Kib/s    Mib/s         |  kb/s    Mb/s
        //! KiB/s    MiB/s         |  KB/s    MB/s

        // APPEND BINARY OR DECIMAL UNIT PREFIX
        if (binaryDecimal === 'binary') {
            if (unit !== 'b') { 
                if (unit === 'k') { 
                    unit = 'K' 
                }  
                unit += 'i'
            }
        }
        // CONVERT OR APPEND BIT OR BYTE UNIT PREFIX
        if (speedUnits === 'bits') {
            if (unit !== 'b') { 
                unit += 'b' 
            }
            
        } else {
            if (unit === 'b') { 
                unit =  'B' 
            } else { 
                unit += 'B' 
            }
        }
        // APPEND PER SECOND PREFIX
        if (showSeconds === true) {
            unit += secondsPrefix
        }
        return unit
    }    

    //################## SERIALISATION FIX ###########################

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


    //2nd
    function addSources() {

        var count = 0;
        var checkedCount = 0
        var sensors = [];
        var netPath = {};
        netInterfaces = []

        sensorList = [];      
        sensors = dbusData.allSensors("network/");

        // console.log("sensors: from CR " + sensors)
        // qml: Network-sensors: 
        // network/all,
        // network/all/download,
        // network/all/downloadBits,
        // network/all/totalDownload
        // network/all/totalUpload,
        // network/all/upload,
        // network/all/uploadBits,
        // network/wlp2s0,
        // network/wlp2s0/download,
        // network/wlp2s0/downloadBits,
        // network/wlp2s0/ipv4address,
        // network/wlp2s0/ipv4dns,
        // network/wlp2s0/ipv4gateway,
        // network/wlp2s0/ipv4subnet,
        // network/wlp2s0/ipv4withPrefixLength,
        // network/wlp2s0/ipv6address,
        // network/wlp2s0/ipv6dns,
        // network/wlp2s0/ipv6gateway,
        // network/wlp2s0/ipv6subnet,
        // network/wlp2s0/ipv6withPrefixLength,
        // network/wlp2s0/network, <<< network name
        // network/wlp2s0/signal,
        // network/wlp2s0/totalDownload,
        // network/wlp2s0/totalUpload,
        // network/wlp2s0/upload,
        // network/wlp2s0/uploadBits,

        //var duplicateCheck = {}

        for (var idx = 0; idx < sensors.length; idx++) {

            if (sensors[idx].endsWith("/all")) {

                netPath = { path:    sensors[idx],
                            name:    "all", 
                            index:   idx, 
                            checked: true }
                // [{"path":"network/enx98e74323092e","name":"Wired connection 1","index":21,"checked":true},
                //  {"path":"network/wlp2s0",         "name":"DUAT",              "index":39,"checked":true}]
                netInterfaces[count] = netPath;                     // ADD INTERFACE ARRAY DATA TO MULTI DEM ARRAY
                count += 1;
            };   
            if (sensors[idx].endsWith("/network")) {

                netPath = { path:    sensors[idx].replace("/network", ""),
                            name:    dbusData.stringData(sensors[idx]), 
                            index:   idx, 
                            checked: true }
                // [{"path":"network/enx98e74323092e","name":"Wired connection 1","index":21,"checked":true},
                //  {"path":"network/wlp2s0",         "name":"DUAT",              "index":39,"checked":true}]
                netInterfaces[count] = netPath;                     // ADD INTERFACE ARRAY DATA TO MULTI DEM ARRAY
                count += 1;
            }                            
        }

        // COMPARE EXISTING INTERFACE SETTINGS WITH DISCOVERED INTERFACES
        // IF USER SETS AN INTERFACE TO NOT BE MONITORED, STORED SETTINGS WILL 
        // HAVE IT AS CHECKED:FALSE.  ADD THIS CHANGE TO netInterfaces ARRAY.
        // IF A NEW INTERFACE IS DISCOVERED, IT WILL BE ADDED / PUSHED TO THE SETTINGS STORE.

        // var pcn = plasmoid.configuration.netSources
        var pcn = netSourceDecode(plasmoid.configuration.netSources)
        // console.log("pcn:", JSON.stringify(pcn), "length:", pcn.length)

        var ni =  netInterfaces
        console.log("ni:", JSON.stringify(ni), "length:", ni.length)

        for (var i = 0; i < pcn.length; i++) {                  // LOOP THROUGH FIRST STORED SETTINGS ARRAY
            
            for (var ii = 0; ii < ni.length; ii++) {            // LOOP THROUGH SECOND netInterfaces ARRAY
                
                if (pcn[i].path === ni[ii].path) {              // PATHS MATCH - NOW COMPARE 'CHECKED'

                    if (pcn[i].checked !== ni[ii].checked) {    // DIFFERENT CHECKED MARK, PCN HAS BEEN UPDATED. MAKE NI SAME AS PCN
                        //netInterfaces[ii].checked = pcn[i].checked
                        ni[ii].checked = pcn[i].checked
                    } 
                }
                // console.log("netInterfaces: PATH: " + netInterfaces[ii].path + 
                //                          ", NAME: " + netInterfaces[ii].name + 
                //                         ", INDEX: " + netInterfaces[ii].index + 
                //                       ", CHECKED: " + netInterfaces[ii].checked)
            }
        }

        plasmoid.configuration.netSources = netSourceEncode(ni) // netInterfaces)       // PUSH FOUND INTERFACES TO STORED SETTINGS 
        //pcn = plasmoid.configuration.netSources                 // REFRESH DATA IN VARIABLE
        //pcn = netSourceEncode(plasmoid.configuration.netSources)                 // REFRESH DATA IN VARIABLE
        // console.log("PCN2:"+netSourceEncode(pcn))
        // console.log("NI2: "+netSourceEncode(ni))

        netDataBits =   [];                                     // RESET ARRAYS
        netDataByte =   [];
        netDataTotal =  [];

        for (var i = 0; i < ni.length; i++) {                  // LOOP THROUGH FIRST STORED SETTINGS ARRAY
            if (ni[i].checked === true) {
               
                sensorList.push(ni[i].path + "/downloadBits",  // CREATE ARRAY TO SUBSCRIBE TO AND POLL FROM DBUS
                                ni[i].path + "/uploadBits",
                                ni[i].path + "/download", 
                                ni[i].path + "/upload",
                                ni[i].path + "/totalDownload",
                                ni[i].path + "/totalUpload",
                                ni[i].path + "/signal")

                // INITIALIZE AND SET GLOBAL VARIABLES BASED ON CHECKED:TRUE INTERFACES
                netDataBits[checkedCount] =   { down:  0, up:  0 };
                netDataByte[checkedCount] =   { down:  0, up:  0 };
                netDataTotal[checkedCount] =  { down:  0, up:  0 };

                checkedCount += 1
            }
        }
        netDataAccumulator =        { down:  0, up:  0 };
        // console.log(sensorList)
        dbusData.subscribe(sensorList);
        // numberOfNets = count;
        numCheckedNets = checkedCount
        ready = true;
    }


    Connections {
        target: plasmoid.configuration
        function onNetSourcesChanged() {            // TRIGGERED WHEN INTERFACE CHECKED CHANGED IN SETTINGS
            dbusData.unsubscribe(sensorList)
            if ( !ready )   return
            else            addSources()
        }
    }
    NetworkMonitor {
        id: networkMonitor
    }
    // THIS WORKS - CALLS NetworkMonitor.qml function
    // function monitorNetworkChanges() {
    //     networkMonitor.test()

    //     // var component = Qt.createComponent("NetworkMonitor.qml");
    //     // if (component.status === Component.Ready) {
    //     //     var networkMonitor = component.createObject(root);
    //     //     if (networkMonitor === null) {
    //     //         console.log("Error creating network monitor");
    //     //     }
    //     // } else if (component.status === Component.Error) {
    //     //     console.log("Error loading component:", component.errorString());
    //     // }
    // }

    Connections {
        target: sysMonitor
        
        function onStatsUpd(pathKeys, values) {
            // TRIGGERED EVERY 500 MILLISECONDS

            //console.log("CR-onStatsUpd: "+ pathKeys + " || "+ values)
            // qml: CR-onStatsUpd: network/wlp2s0/download,network/wlp2s0/upload || 334,128
            // qml: CR-onStatsUpd: network/wlp2s0/downloadBits,network/wlp2s0/totalDownload,network/wlp2s0/uploadBits,network/wlp2s0/totalUpload || 0,49913032,0,169202

            var sensorPathKey;                                                  // PATH AND KEY OF DBUS FOUND INTERFACE VALUE
            var configPath;                                                     // PATH OF INTERFACE IN SETTINGS / CONFIG
            var slot = 0
            var ni = netInterfaces //plasmoid.configuration.netSources

            if ( !ready )  return;

            for (var i = 0; i < ni.length; i++) {                              // LOOP SETTINGS INTERFACE AND GRAB PATH OF CHECKED:TRUE 

                if (ni[i].checked === true) {
                    configPath = ni[i].path
                } else { 
                    continue                                                    // SKIP SETTINGS INTERFACE THAT ISNT CHECKED:TRUE 
                }                            

                for ( var ii = 0; ii < pathKeys.length; ii++ ) {                // LOOP DBUS SENSOR PATH & KEYS

                    sensorPathKey = pathKeys[ii];

                    if (sensorPathKey.indexOf(configPath) == 0) {

                        if (sensorPathKey == configPath + "/download") {         // DOWNLOAD IN BYTES
                            netDataByte[slot].down  = values[ii]       
                        }                        
                        if (sensorPathKey == configPath + "/downloadBits") {     // DOWNLOAD IN BITS
                            netDataBits[slot].down  = values[ii]                            
                        }
                        if (sensorPathKey == configPath + "/totalDownload") {    // TOTAL DOWNLOAD IN BYTES:
                            netDataTotal[slot].down = values[ii]
                        }   
                        if (sensorPathKey == configPath + "/upload") {           // UPLOAD IN BYTES
                            netDataByte[slot].up    = values[ii]       
                        }                                             
                        if (sensorPathKey == configPath + "/uploadBits") {       // UPLOAD IN BITS
                            netDataBits[slot].up    = values[ii]      
                        }
                        if (sensorPathKey == configPath + "/totalUpload") {      // TOTAL UPLOAD IN BYTES:
                            netDataTotal[slot].up   = values[ii]
                        }
                    }
                }
                slot += 1
            }
            // console.log("netDataBits[0].down", netDataBits[0].down, "netDataBits[0].up", netDataBits[0].up)
            // console.log("netDataBits[1].down", netDataBits[1].down, "netDataBits[1].up", netDataBits[1].up)
            // console.log("netDataBits[2].down", netDataBits[2].down, "netDataBits[2].up", netDataBits[2].up)

            if (accumulator) {                                                  // ACCUMULATOR SWITCHED ON
                activateAccumulator()
            }
            // const now = new Date();
            // county += 1
            // console.log(county, "|", now)

            // monitorNetworkChanges();
        }


        function onUpdateUi() {
            // THIS FUNCTION IS TRIGGERED BY updateInterval 
            setNetData()

            setUiVisible('')
        }


        function setNetData() {
            // THIS FUNCTION IS TRIGGERED BY updateInterval 
            
            if (numCheckedNets == 0) {                      // NO NETWORKS ENABLED|CHECKED [undefined fix]
                downSpeed = 0
                upSpeed   = 0

            } else {                                        // ONE OR MORE NETWORKS ENABLED|CHECKED   

                if (accumulator !== 0) {                    // ACCUMULATOR IS EITHER 1 OR 2
                     var values = getAccumulatorData()
                    downSpeed = values[0]
                    upSpeed   = values[1]                   
                    return                                  // EXIT FUNCTION
                }
                var values = multiNetAddition()             // ADD VALUES FOR MULTIPLE ACTIVE NETWORKS
                downSpeed = values[0]
                upSpeed   = values[1]                     
            } 
        }


        function multiNetAddition(){
            // IF MULTIPLE INTERFACES ARE CHECKED, DATA COLLECTED FROM EACH NEEDS TO BE ADDED TOGETHER AND DISPLAYED

            var downloaded     = 0
            var uploaded       = 0

            if (speedUnits === 'bits') {                    // BITS
                for (var i = 0; i < netDataBits.length; i++) {
                    downloaded += netDataBits[i].down
                    uploaded   += netDataBits[i].up
                }
            } else {                                        // BYTES
                for (var i = 0; i < netDataByte.length; i++) {
                    downloaded += netDataByte[i].down
                    uploaded   += netDataByte[i].up
                }
            }
            return [ downloaded, uploaded ]
        }


        function getAccumulatorData() {

            var downloaded     = 0
            var uploaded       = 0

            if (accumulator === 2) {                    // ACCUMULATOR ON [ ACCUMULATED ]
                downloaded = netDataAccumulator.down
                uploaded   = netDataAccumulator.up

            } else if (accumulator === 1) {             // ACCUMULATOR ON [ AVERAGE ]
                downloaded = getAverage(netDataAccumulator.down)
                uploaded   = getAverage(netDataAccumulator.up)
            }

            netDataAccumulator.down =   0               // RESET ACCUMULATOR DATA FOR NEXT COUNT
            netDataAccumulator.up =     0
            accumulatorCounter =        0               // RESET ACCUMULATOR COUNTER, USED TO TRIGGER updateInterval AT THE CORRECT TIME
            
            return [ downloaded, uploaded ]
        }


        function activateAccumulator() {
            // IF ACTIVATED, WILL TRIGGER EVERY 500 MILLISECONDS

            var values = multiNetAddition()
            var countx = updateInterval / 500                   // GET NUMBER OF TICKS FOR COUNTER

            if (accumulatorCounter < countx) {                  
                    netDataAccumulator.down   += values[0]
                    netDataAccumulator.up     += values[1]
            }
            accumulatorCounter            += 1
        }


        function getAverage(value) {
            var seconds = updateInterval / 1000

            return value * 0.5 / seconds
        }
    }

    Component.onCompleted: {
        addSources();
    }


    Component.onDestruction: {
        dbusData.unsubscribe(sensorList);
    }
}