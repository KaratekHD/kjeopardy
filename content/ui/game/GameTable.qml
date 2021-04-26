
import QtQuick 2.1
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.11 as Kirigami

Kirigami.Page {
    title: jtitle.text
    function processButtonInput(points, collumn) {
        //processQuestion("52d4e1b4-1d2a-4596-b8b1-5621bfe3c4c0", points, collumn) //TODO: Change the UUID stuff later
        //print(bridge.get_is_question("52d4e1b4-1d2a-4596-b8b1-5621bfe3c4c0", points, collumn))
        if(!(bridge.get_question_exists("52d4e1b4-1d2a-4596-b8b1-5621bfe3c4c0", points, collumn))) {
            showPassiveNotification("Question is undefined.")
            return
            
        }
        if (bridge.get_is_question("52d4e1b4-1d2a-4596-b8b1-5621bfe3c4c0", points, collumn)) {
            bridge.set_asked_question("52d4e1b4-1d2a-4596-b8b1-5621bfe3c4c0", points, collumn)
            pageStack.layers.push(Qt.resolvedUrl("MultipleChoice.qml"))
        } else {
            bridge.set_asked_question("52d4e1b4-1d2a-4596-b8b1-5621bfe3c4c0", points, collumn)
            pageStack.layers.push(Qt.resolvedUrl("game.qml"))
        }
    }

    GridLayout {
        anchors.centerIn: parent
        Layout.preferredHeight:  parent.height
        columns: 4
        rows: 6
        Text {
            text: head0.text
            id: headColumn1
        }
        Text {
            text: head1.text
            id: headColumn2
        }
        Text {
            text: head2.text
            id: headColumn3
        }
        Text {
            text: head3.text
            id: headColumn4
        }
        Controls.Button {
            id: buttonP200C1
            text: "200"
            onClicked: processButtonInput(200, 1)
        }
        Controls.Button {
            id: buttonP200C2
            text: "200"
            onClicked: processButtonInput(200, 2)
        }
        Controls.Button {
            id: buttonP200C3
            text: "200"
            onClicked: processButtonInput(200, 3)
        }
        Controls.Button {
            id: buttonP200C4
            text: "200"
            onClicked: processButtonInput(200, 4)
        }
        Controls.Button {
            id: buttonP400C1
            text: "400"
            onClicked: processButtonInput(400, 1)
        }
        Controls.Button {
            id: buttonP400C2
            text: "400"
            onClicked: processButtonInput(400, 2)
        }
        Controls.Button {
            id: buttonP400C3
            text: "400"
            onClicked: processButtonInput(400, 3)
        }
        Controls.Button {
            id: buttonP400C4
            text: "400"
            onClicked: processButtonInput(400, 4)
        }
        Controls.Button {
            id: buttonP600C1
            text: "600"
            onClicked: processButtonInput(600, 1)
        }
        Controls.Button {
            id: buttonP600C2
            text: "600"
            onClicked: processButtonInput(600, 2)
        }
        Controls.Button {
            id: buttonP600C3
            text: "600"
            onClicked: processButtonInput(600, 3)
        }
        Controls.Button {
            id: buttonP600C4
            text: "600"
            onClicked: processButtonInput(600, 4)
        }
        Controls.Button {
            id: buttonP800C1
            text: "800"
            onClicked: processButtonInput(800, 1)
        }
        Controls.Button {
            id: buttonP800C2
            text: "800"
            onClicked: processButtonInput(800, 2)
        }
        Controls.Button {
            id: buttonP800C3
            text: "800"
            onClicked: processButtonInput(800, 3)
        }
        Controls.Button {
            id: buttonP800C4
            text: "800"
            onClicked: processButtonInput(800, 4)
        }
        Controls.Button {
            id: buttonP1000C1
            text: "1000"
            onClicked: processButtonInput(1000, 1)
        }
        Controls.Button {
            id: buttonP1000C2
            text: "1000"
            onClicked: processButtonInput(1000, 2)
        }
        Controls.Button {
            id: buttonP1000C3
            text: "1000"
            onClicked: processButtonInput(1000, 3)
        }
        Controls.Button {
            id: buttonP1000C4
            text: "1000"
            onClicked: processButtonInput(1000, 4)
        }
        
    }
}
