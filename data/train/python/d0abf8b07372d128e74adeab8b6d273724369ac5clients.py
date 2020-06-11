'''
Created on Nov 29, 2015

@author: Sameer Adhikari
'''

from patterns.command.receivers import Document, Window
from patterns.command.commands import ExitCommand, SaveCommand
from patterns.command.invokers import KeyboardCombination, MenuItem, ToolbarButton

if __name__ == '__main__':
    # Create receivers
    win = Window()
    doc = Document('sample.txt')
    
    # Create commands and connect with receivers
    exit_cmd = ExitCommand(win)
    save_cmd = SaveCommand(doc)

    # Create invokers and set their commands
    save_butn = ToolbarButton('save', 'save.png')
    save_butn.command = save_cmd
    save_combo = KeyboardCombination('s', 'ctrl')
    save_combo.command = save_cmd
    exit_menu = MenuItem('File', 'Exit')
    exit_menu.command = exit_cmd
    
    # Run some of the simulated scenarios
    save_combo.keypress()
    exit_menu.choose()
    print('This line should never get printed')
    
