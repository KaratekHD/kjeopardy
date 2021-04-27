#!/usr/bin/python3

import argparse
import json
from argparse import HelpFormatter
from functools import partial
from PySide2.QtWidgets import *
from PySide2.QtGui import *
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import *
import webbrowser
import os

class Transporter(QObject):
    def __init__(self, parent=None):
        QObject.__init__(self, parent)
        self._text = ""

    def get_text(self):
        return self._text

    def set_text(self, value):
        if self._text == value:
            return
        self._text = value

    text = Property(str, fget=get_text, fset=set_text)

class CustomHelpFormatter(HelpFormatter):

    def _format_action_invocation(self, action):
        if not action.option_strings:
            # Use default methods for positional arguments
            default = self._get_default_metavar_for_positional(action)
            metavar, = self._metavar_formatter(action, default)(1)
            return metavar

        else:
            parts = []
            if action.nargs == 0:
                # Just add options, if they expects no values (like --help)
                parts.extend(action.option_strings)
            else:
                default = self._get_default_metavar_for_optional(action)
                args_string = self._format_args(action, default)
                for option_string in action.option_strings:
                    parts.append(option_string)
                # Join the argument names (like -p --param ) and add the metavar at the end
                return '%s %s' % (', '.join(parts), args_string)

            return ', '.join(parts)
        
""" 
With the custom formatter the metavar does not get displayed twice.
With the max_help_position you can decide how long the parameters + metavar should be before a line break gets inserted,
additionally the width parameter defines the maximum length of a line.
The difference can be seen here:
https://github.com/alex1701c/Screenshots/blob/master/PythonArgparseCLI/default_output.png
https://github.com/alex1701c/Screenshots/blob/master/PythonArgparseCLI/customized_output_format.png
"""


asked_question = [0, 0] # [Column, Number]
global_jeopardy = ""
jeopardys = []
active_jeopardy = ""

class Bridge(QObject):
    
    @Slot(str, int, int, result=bool)
    def get_is_question(self, jeopardy, points, collumn):
        with open('jeopardys/' + jeopardy + '.json') as json_file:
            data = json.load(json_file)["questions"]
        question_number = 0
        if points == 200:
            question_number = 1
        if points == 400:
            question_number = 2
        if points == 600:
            question_number = 3
        if points == 800:
            question_number = 4
        if points == 1000:
            question_number = 5
        return bool(data["categorie" + str(collumn)]["question" + str(question_number)]["isQuestion"])
    
    @Slot(str, int, int)
    def set_asked_question(self, jeopardy, points, collumn):
        question_number = 0
        if points == 200:
            question_number = 1
        if points == 400:
            question_number = 2
        if points == 600:
            question_number = 3
        if points == 800:
            question_number = 4
        if points == 1000:
            question_number = 5
        global asked_question
        global global_jeopardy
        global_jeopardy = jeopardy
        asked_question = [collumn, question_number]
        
    @Slot(str, int, int, result=bool)
    def get_question_exists(self, jeopardy, points, collumn):
        question_number = 0
        if points == 200:
            question_number = 1
        if points == 400:
            question_number = 2
        if points == 600:
            question_number = 3
        if points == 800:
            question_number = 4
        if points == 1000:
            question_number = 5
        with open('jeopardys/' + jeopardy + '.json') as json_file:
            data = json.load(json_file)["questions"]
        if not "categorie" + str(collumn) in data:
            return False
        if not "question" + str(question_number) in data["categorie" + str(collumn)]:
            return False
        return True
        
    @Slot(result=str)
    def get_task_title(self):
        global asked_question
        global global_jeopardy
        collumn, question = asked_question
        with open('jeopardys/' + global_jeopardy + '.json') as json_file:
            data = json.load(json_file)["questions"]
        data = data["categorie" + str(collumn)]["question" + str(question)]
        return data["text"]
    
    @Slot(int, result=str)
    def get_answer(self, answer_number):
        global global_jeopardy
        global asked_question
        with open('jeopardys/' + global_jeopardy + '.json') as json_file:
            data = json.load(json_file)["questions"]
        collumn, question = asked_question
        data = data["categorie" + str(collumn)]["question" + str(question)]
        answer_char = "0"
        if answer_number == 1:
            answer_char = "a"
        if answer_number == 2:
            answer_char = "b"
        if answer_number == 3:
            answer_char = "c"
        if answer_number == 4:
            answer_char = "d"
            
        return data["answers"][answer_char]
    
    @Slot(result=str)
    def get_game_description(self):
        global global_jeopardy
        global asked_question
        with open('jeopardys/' + global_jeopardy + '.json') as json_file:
            data = json.load(json_file)["questions"]
        collumn, question = asked_question
        data = data["categorie" + str(collumn)]["question" + str(question)]
        return data["description"]
    
    @Slot(result=int)
    def get_correct_answer(self):
        global global_jeopardy
        global asked_question
        with open('jeopardys/' + global_jeopardy + '.json') as json_file:
            data = json.load(json_file)["questions"]
        collumn, question = asked_question
        data = data["categorie" + str(collumn)]["question" + str(question)]
        correct_char = data["answers"]["correct"]
        correct_int = 0
        if correct_char == "a":
            correct_int = 1
        if correct_char == "b":
            correct_int = 2
        if correct_char == "c":
            correct_int = 3
        if correct_char == "d":
            correct_int = 4
        return correct_int
    
    @Slot(result=list)
    def get_files(self):
        filepath = os.path.dirname(__file__)
        filepath = filepath.split("/")
        del filepath[0]
        del filepath[-1]
        filepath.append("jeopardys")
        directory = ""
        for entry in filepath:
            if directory == "":
                directory = "/" + entry
            else:
                directory = directory + "/" + entry
        global jeopardys
        jeopardys = []
        for filename in os.listdir(directory):
            if filename.endswith(".json"):
                jeopardys.append(filename)
        print(jeopardys)
        return [jeopardys]
    
    @Slot(str)
    def printf(self, string):
        print(string) # For debugging purposes
        
    @Slot(int, result=str)
    def get_jeopardy_title(self, fileid):
        with open('jeopardys/' + jeopardys[fileid]) as json_file:
            data = json.load(json_file)
        return data["title"]
    
    @Slot(int, result=str)
    def get_jeopardy_description(self, fileid):
        with open('jeopardys/' + jeopardys[fileid]) as json_file:
            data = json.load(json_file)
        return data["description"]

    @Slot(int, result=str)
    def get_jeopardy_image(self, fileid):
        with open('jeopardys/' + jeopardys[fileid]) as json_file:
            data = json.load(json_file)
        return data["banner"]
    
    @Slot(int, result=str)
    def get_jeopardy_filename(self, fileid):
        return jeopardys[fileid]
    
    @Slot(str)
    def set_jeopardy(self, jeopardy):
        global global_jeopardy
        global_jeopardy = jeopardy.replace(".json", "")
    
    @Slot(result=str)
    def get_jeopardy(self):
        global global_jeopardy
        return global_jeopardy
    
    @Slot(int, result=str)
    def get_head(self, i):
        global global_jeopardy
        with open('jeopardys/' + global_jeopardy + '.json') as json_file:
            data = json.load(json_file)
        return data["categories"][i]
    
    @Slot(result=str)
    def get_jeopardy_title_global(self):
        global global_jeopardy
        with open('jeopardys/' + global_jeopardy + '.json') as json_file:
            data = json.load(json_file)
        return data["title"]
    
    @Slot(str)
    def openWebBrowser(self, url):
        webbrowser.open(url)
if __name__ == "__main__":
    # Command line stuff
    parser = argparse.ArgumentParser(description='Opensource Jeopardy programm written in Python with KDE Frameworks 5.', formatter_class=CustomHelpFormatter)
    parser.add_argument('-v', '--version', action='version', version='kjeopardy 1.0')
    args = parser.parse_args()
    # Parse JSON
    #with open('jeopardys/52d4e1b4-1d2a-4596-b8b1-5621bfe3c4c0.json') as json_file:
    #    data = json.load(json_file)
    #title = data["title"]
    #description = data["description"]
    #head0 = data["categories"][0]
    #head1 = data["categories"][1]
    #head2 = data["categories"][2]
    #head3 = data["categories"][3]
    #Qtitle = Transporter()
    #Qdescription = Transporter()
    #Qhead0 = Transporter()
    #Qhead1 = Transporter()
    #Qhead2 = Transporter()
    #Qhead3 = Transporter()
    #Qtitle.text = title
    #Qdescription.text = description
    #Qhead0.text = head0
    #Qhead1.text = head1
    #Qhead2.text = head2
    #Qhead3.text = head3
    bridge = Bridge()
    
    
    # Launch application
    app = QApplication()
    app.setWindowIcon(QIcon(os.path.dirname(os.path.abspath(__file__)) + "/../content/img/kjeopardy.svg"))
    versionObj = Transporter()
    versionObj.text = "0.1"
    engine = QQmlApplicationEngine()
    #engine.rootContext().setContextProperty("ver", versionObj)
    #engine.rootContext().setContextProperty("jtitle", Qtitle)
    #engine.rootContext().setContextProperty("jdescription", Qdescription)
    #engine.rootContext().setContextProperty("head0", Qhead0)
    #engine.rootContext().setContextProperty("head1", Qhead1)
    #engine.rootContext().setContextProperty("head2", Qhead2)
    #engine.rootContext().setContextProperty("head3", Qhead3)
    engine.rootContext().setContextProperty("bridge", bridge)
    context = engine.rootContext()
    engine.load("content/ui/main.qml")
    if len(engine.rootObjects()) == 0:
        quit()
    win = engine.rootObjects()[0]
    #connect_slots(win)
    
    app.exec_()
