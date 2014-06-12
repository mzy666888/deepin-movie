import QtQuick 2.1
import Deepin.Widgets 1.0

Rectangle {
    id: playlistPanel
    state: "active"
    opacity: 1

    property var currentItem
    property string tabId: "local"
    property bool expanded: width == program_constants.playlistWidth
    property url currentPlayingSource
    property alias window: playlistPanelArea.window

    signal newSourceSelected (string path)
    
    signal addButtonClicked ()
    signal deleteButtonClicked ()
    signal clearButtonClicked ()
    signal modeButtonClicked ()

    states: [
        State {
            name: "active"
            PropertyChanges { target: playlistPanel; color: "#1B1C1D"; opacity: 1 }
            PropertyChanges { target: hidePlaylistButton; source: "image/playlist_handle_bg.png"; opacity: 1 }
        },
        State {
            name: "inactive"
            PropertyChanges { target: playlistPanel; color: "#1B1C1D"; opacity: 0.95 }
            PropertyChanges { target: hidePlaylistButton; source: "image/playlist_handle_bg.png"; opacity: 0.95 }
        }
    ]

    onStateChanged: {
        if (state == "inactive") {
            hide_timer.restart()
        } else {
            hide_timer.stop()
        }
    }

    function show() {
        if (!expanded) {
            visible = true
            showingPlaylistPanelAnimation.restart()
        }
    }

    function hide() {
        if (expanded) {
            hidingPlaylistPanelAnimation.restart()
        }
    }

    function toggleShow() {
        if (expanded) {
            hidingPlaylistPanelAnimation.restart()
        } else {
            visible = true
            showingPlaylistPanelAnimation.restart()
        }
    }

    function getContent(type) {
        return playlist.getContent()
    }

    function addItem(item) {
        playlist.addItem(item)
    }

    function clear() {
        playlist.clear()
        database.playlist_local = ""
    }
    
    function getRandom() { return playlist.getRandom() }
    function getPreviousSource() { return playlist.getPreviousSource() }
    function getNextSource() { return playlist.getNextSource() }
    function getPreviousSourceCycle() { return playlist.getPreviousSourceCycle() }
    function getNextSourceCycle() { return playlist.getNextSourceCycle() }

    Timer {
        id: hide_timer
        interval: 5000
        repeat: false

        onTriggered: hidingPlaylistPanelAnimation.start()
    }

    PropertyAnimation {
        id: showingPlaylistPanelAnimation
        alwaysRunToEnd: true

        target: playlistPanel
        property: "width"
        to: program_constants.playlistWidth
        duration: 100
        easing.type: Easing.OutQuint

        onStopped: {
            playlistPanel.state = "active"
        }
    }

    PropertyAnimation {
        id: hidingPlaylistPanelAnimation
        alwaysRunToEnd: true

        target: playlistPanel
        property: "width"
        to: 0
        duration: 100
        easing.type: Easing.OutQuint

        onStopped: {
            playlistPanel.visible = false
        }
    }

    DragableArea {
        id: playlistPanelArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: { playlistPanel.state = "active" }
        onWheel: {}
    }

    Item {
        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottom_rect.top
        anchors.topMargin: 20
        anchors.bottomMargin: 20

        DScrollBar {
            flickable: playlist
            anchors.right: parent.right
            anchors.rightMargin: 5
        }

        PlaylistView {
            id: playlist
            width: parent.width - 14 * 2
            height: Math.min(parent.height, childrenRect.height)
            root: playlist
            visible: playlistPanel.expanded
            currentPlayingSource: playlistPanel.currentPlayingSource
            anchors.horizontalCenter: parent.horizontalCenter

            onNewSourceSelected: {
                playlistPanel.newSourceSelected(path)
            }

            Component.onCompleted: initializeWithContent(database.playlist_local)
        }
    }

    Rectangle {
        id: bottom_rect
        width: parent.width
        height: 25
        color: Qt.rgba(1, 1, 1, 0.05)
        anchors.bottom: parent.bottom

        Row {
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin: 10
            spacing: 10

            OpacityImageButton {
                imageName: "image/playlist_mode_button.png"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: { playlistPanel.modeButtonClicked() }
            }
            OpacityImageButton {
                imageName: "image/playlist_delete_button.png"
                anchors.verticalCenter: parent.verticalCenter                
                onClicked: { playlistPanel.deleteButtonClicked() }
            }
            OpacityImageButton {
                imageName: "image/playlist_add_button.png"
                anchors.verticalCenter: parent.verticalCenter                
                onClicked: { playlistPanel.addButtonClicked() }
            }            
            OpacityImageButton {
                imageName: "image/playlist_clear_button.png"
                anchors.verticalCenter: parent.verticalCenter                
                onClicked: { playlistPanel.clearButtonClicked() }
            }            
        }
    }

    Image {
        id: hidePlaylistButton
        width: implicitWidth
        height: implicitHeight
        anchors.right: parent.left
        anchors.verticalCenter: playlistPanel.verticalCenter

        DImageButton {
            id: handle_arrow_button
            normal_image: "image/playlist_handle_normal.png"
            hover_image: "image/playlist_handle_hover.png"
            press_image: "image/playlist_handle_press.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 3

            onClicked: {
                hidingPlaylistPanelAnimation.restart()
            }
        }
    }
}
