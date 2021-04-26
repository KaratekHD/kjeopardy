
import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

Kirigami.ScrollablePage {
    property var correct: 3
    property var checked: 0
    title: "Game"
    ColumnLayout {
        Kirigami.FormLayout {
        
            Kirigami.Heading {
                text: bridge.get_task_title()
            }
            Text {
                text: bridge.get_game_description()
            }



        }
        
    }
    
}
