import QtQuick 2.1
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.11 as Kirigami

Kirigami.ScrollablePage {
    title: "Placeholder page"
    RowLayout {
        Kirigami.InlineMessage {
            Layout.fillWidth: true
            visible: true
            text: "This is a placeholder page. It does not do anything, and you are seeing this because this is a development build that is not yet fully functional. If this appears in a production build and you are not  a developer, something is wrong."
        }

        
    }
    
}
