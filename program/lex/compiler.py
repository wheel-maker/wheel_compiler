import os
import sys
from PyQt5.QtWidgets import QApplication, QAction,QFileDialog, QTextEdit, QLabel, QLineEdit, QMainWindow, QPushButton, QWidget
from PyQt5.QtGui import QIcon,QFont

class Interface(QMainWindow,QWidget):
    def __init__(self):
        super().__init__()
        self.font = QFont("微软雅黑",10,QFont.Bold)
        self.initUI()

    def initUI(self):
        # 设置“输入内容”标签
        label1 = QLabel(self)
        label1.setText("输入内容")
        label1.setFont(self.font)
        label1.move(10,20)

        # 设置“词法分析结果”标签
        label2 = QLabel(self)
        label2.setText("词法分析结果：")
        label2.setFont(self.font)
        label2.move(350,20)

        # 设置输入框
        self.input_text = QTextEdit(self)
        self.input_text.move(10,45)
        self.input_text.setFixedSize(300,400)

        # 设置词法分析结果框
        self.output_text = QTextEdit(self)
        self.output_text.move(350,45)
        self.output_text.setFixedSize(300,400)

        # 创建菜单
        menu = self.menuBar()
        file = menu.addMenu("&文件")
        lex = menu.addAction("&词法分析")

        # 创建文件导入图标
        inFileAction = QAction(QIcon("input.png"),"&导入",self)
        file.addAction(inFileAction)

        # 创建触发机制
        inFileAction.triggered.connect(self.fileSelect)
        lex.triggered.connect(self.lexAnalysis)

        self.setWindowTitle("编译器")
        self.setWindowIcon(QIcon("compile.png"))
        self.setGeometry(300,300,800,600)
        self.show()

    """
    打开文件并将结果显示到输入框
    """
    def fileSelect(self):
        self.infile = QFileDialog.getOpenFileName(self,"选择文件")[0]
        f = open(self.infile,'r')
        self.input_text.setText(f.read())

    """
    词法分析并将结果显示到文本框
    """
    def lexAnalysis(self):
        path = ""
        file = os.path.join(path,"lex.exe")     
        print(file)   
        cmd = file + " " + self.infile
        # 执行命令行的命令
        r = os.popen(cmd)
        self.lexResult = r.read()
        self.output_text.setText(self.lexResult)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    gui = Interface()
    sys.exit(app.exec_())
    """
    outfile = input("Output the file:")
    cmd = file + " " + outfile  + " " + infile
    print(cmd)
    f = os.system(cmd)
    """