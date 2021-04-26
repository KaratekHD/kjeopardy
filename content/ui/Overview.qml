import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

Kirigami.ScrollablePage {
    id: startPage
    title: "KJeopardy"
    header: Controls.ToolBar {
        id: toolbar
        RowLayout {
            anchors.fill: parent
            Kirigami.SearchField {
                id: searchField

                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.maximumWidth: Kirigami.Units.gridUnit*30
            }
        }
    }

    actions.main: Kirigami.Action {
		id: addAction
		icon.name: "list-add"
		text: i18nc("@action:button", "Add jeopardy")
		onTriggered:  mainModel.append({"title": "Jeopardy",
                "image": "../img/fallback_banner.jpg",
                "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam id risus id augue euismod accumsan. Nunc vestibulum placerat bibendum.",
                "actions": [{text: "Play", icon: "media-playback-start"}]
            })
	}
	
	actions.left: Kirigami.Action {
        text: "Quit"
        icon.name: "gtk-quit"
        onTriggered: Qt.quit()
        
    }
    property var arr: bridge.get_files()
    Component.onCompleted: {
        print(arr)
        print(arr.length)
        for (var i = 0; i < arr[0].length; i++) {
            print(arr[0][i])
            mainModel.append({"title": bridge.get_jeopardy_title(i),
                "image": bridge.get_jeopardy_image(i),
                "text": bridge.get_jeopardy_description(i),
                "actions": [{text: "Play", icon: "media-playback-start"}],
                "file": bridge.get_jeopardy_filename(i)
            })
            
        }
        
    }
    

    Kirigami.CardsListView {
        id: view
        model: ListModel {
            id: mainModel
            
        }

        delegate: Kirigami.AbstractCard {
            //NOTE: never put a Layout as contentItem as it will cause binding loops
            //SEE: https://bugreports.qt.io/browse/QTBUG-66826
            contentItem: Item {
                implicitWidth: delegateLayout.implicitWidth
                implicitHeight: delegateLayout.implicitHeight
                GridLayout {
                    id: delegateLayout
                    anchors {
                        left: parent.left
                        top: parent.top
                        right: parent.right
                        //IMPORTANT: never put the bottom margin
                    }
                    rowSpacing: Kirigami.Units.largeSpacing
                    columnSpacing: Kirigami.Units.largeSpacing
                    columns: width > Kirigami.Units.gridUnit * 20 ? 4 : 2
                    Kirigami.Icon {
                        source: model.image
                        Layout.fillHeight: true
                        Layout.maximumHeight: Kirigami.Units.iconSizes.huge
                        Layout.preferredWidth: height
                    }
                    ColumnLayout {
                        Kirigami.Heading {
                            level: 2
                            text: model.title
                        }
                        Kirigami.Separator {
                            Layout.fillWidth: true
                        }
                        Controls.Label {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            text: model.text
                        }
                        Controls.Label {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            text: model.file
                        }
                    }
                    Controls.Button {
                        icon.name: model.actions.get(0).icon
                        Layout.alignment: Qt.AlignRight|Qt.AlignVCenter
                        Layout.columnSpan: 2 
                        text: "Play"
                        onClicked: pushReplaceLayer(Qt.resolvedUrl("game/GameTable.qml"))
                    }
                }
            }
        }
    }
/*
    Kirigami.CardsGridView {
        id: view
        model: ListModel {
            id: mainModel
        }

        delegate:Kirigami.Card {
            id: card
            banner {
                title: model.title
                source: model.image
            }
            contentItem: Controls.Label {
                wrapMode: Text.WordWrap
                text: model.text
            }
            actions: [
                Kirigami.Action {
                    text: model.actions.get(0).text
                    icon.name: model.actions.get(0).icon
                    onTriggered: pushReplaceLayer(Qt.resolvedUrl("game/GameTable.qml"))
                }
            ]
        }
    }
    */
    
    

}
