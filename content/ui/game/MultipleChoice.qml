import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami

Kirigami.ScrollablePage {
    property var correct: bridge.get_correct_answer()
    property var checked: 0
    function check(checkbox) {
        if (checkbox == correct) {
            wrongBanner.visible = false
            correctBanner.visible = true
            return true
        } else {
            wrongBanner.visible = true
            correctBanner.visible = false
            return false
        }
        
    }
    title: "Multiple Choice Question"
    ColumnLayout {
        Kirigami.FormLayout {
            Kirigami.InlineMessage {
                Layout.fillWidth: true
                id: correctBanner
                visible: false
                type: Kirigami.MessageType.Positive
                text: "Deine Antwort ist richtig!"
            }
            Kirigami.InlineMessage {
                id: wrongBanner
                Layout.fillWidth: true
                visible: false
                type: Kirigami.MessageType.Error
                text: "Deine Antwort ist leider falsch."
            }

            Kirigami.Heading {
                text: bridge.get_task_title()
            }
            ColumnLayout {
                Layout.rowSpan: 3
                Controls.RadioButton {
                    id: firstRadio
                    text: bridge.get_answer(1)
                }
                Controls.RadioButton {
                    id: secondRadio
                    text: bridge.get_answer(2)
                }
                Controls.RadioButton {
                    id: thirdRadio
                    text: bridge.get_answer(3)
                }
                Controls.RadioButton {
                    id: fourRadio
                    text: bridge.get_answer(4)
                }
            }
            Controls.Button {
                text: "Abgeben"
                icon.name: "dialog-ok"
                Layout.fillWidth: true
                onClicked: {
                    if (!(firstRadio.checked || secondRadio.checked || thirdRadio.checked || fourRadio.checked)) {
                        showPassiveNotification("Nothing is selected!")
                    }
                    if (firstRadio.checked) {
                        check(1)
                    }
                    if (secondRadio.checked) {
                        check(2)
                    }
                    if (thirdRadio.checked) {
                        check(3)
                    }
                    if (fourRadio.checked) {
                        check(4)
                    }
                    
                }
            }

        }
        
    }
    
}
