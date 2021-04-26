

import QtQuick 2.1
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.11 as Kirigami

Kirigami.ApplicationWindow {
    
    title: "Kjeopardy"
    function pushReplaceLayer(page, args) {
        if (pageStack.layers.depth === 2) {
            pageStack.layers.replace(page, args);
        } else {
            pageStack.layers.push(page, args);
        }
    }
    
    globalDrawer: Kirigami.GlobalDrawer {
		isMenu: true
		actions: [
            Kirigami.Action {
				text: "About"
				icon.name: "help-about"
				onTriggered: pushReplaceLayer(Qt.resolvedUrl("AboutPage.qml")) 
				enabled: pageStack.layers.currentItem.title !== "About"
			}, 
			Kirigami.Action {
				text: "Quit"
				icon.name: "gtk-quit"
				shortcut: StandardKey.Quit
				onTriggered: Qt.quit()
			}
		]
	}
	
    Overview {
        id: overview
    }
    pageStack.initialPage: overview
}    
