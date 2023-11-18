import json
import os

class EmulatedShell:
    version = "0.0.1-J-Custom-PyShell (JCPS)"
    developers = ["JossDeVT", "Techlm77"]

    def __init__(self):
        self.current_directory = "(.main)"
        self.history = []
        self.file_system = {'(.main)': ['file1', 'file2', 'file3']}

    def run_command(self, command):
        self.history.append(command)

        # Split the command into words
        args = command.split()

        # Check for specific commands
        if args[0] == 'hp':
            self.help_msg()
            return
        
        if args[0] == 'cd':
            self.change_directory(args[1] if len(args) > 1 else '(.main)')
            return

        if args[0] == 'sd':
            self.list_directory()
            return

        if args[0] == 'pwd':
            print(self.current_directory)
            return

        if args[0] == 'luc':
            self.show_history()
            return

        if args[0] == 'mkd':
            self.make_directory(args[1] if len(args) > 1 else '')
            return

        if args[0] == 'ctl':
            self.clear_console()
            return

        if args[0] == 'sfs':
            self.save_file_system()
            return

        if args[0] == 'rm':
            self.remove_file(args[1] if len(args) > 1 else '')
            return

        if args[0] == 'info':
            self.get_info()
            return

        if args[0] == 'edit':
            self.nano_editor(args[1] if len(args) > 1 else '')
            return

        if args[0] == 'mkf':
            self.make_file(args[1] if len(args) > 1 else '')
            return

        # If the command is not recognized
        print(f"Command not found on database: {args[0]}")

    def change_directory(self, path):
        # Simulate changing directories
        full_path = self.current_directory + '.' + path
        if full_path in self.file_system:
            if self.is_directory(full_path):
                self.current_directory = full_path
            else:
                # Check if the path represents a file with a recognized extension
                if self.is_file_with_extension(path):
                    print(f"Error: '{path}' is a file, not a directory.")
                    print("Try with command 'nano' or create the directory manually: Error code: FS=0")
                else:
                    print(f"Error: '{path}' is not a recognized file or directory.")
        elif path == '(.main)':
            self.current_directory = path
        else:
            print(f"Warning: Folder '{path}' doesn't exist.")

    def is_directory(self, path):
        # Check if the given path is a directory
        return isinstance(self.file_system.get(path), list)

    def list_directory(self):
        # Simulate listing files and directories in the current directory
        current_content = self.file_system.get(self.current_directory, [])
        print("Content in", self.current_directory)
        for item in current_content:
            if self.is_directory(self.current_directory + '.' + item):
                print(f"Directory: {item}")
            else:
                print(f"File: {item}")

    def show_history(self):
        # Display command history
        print("Command Recently Used:")
        for i, command in enumerate(self.history, start=1):
            print(f"{i}. {command}")

    def make_directory(self, directory_name):
        # Simulate creating a new directory
        new_directory = self.current_directory + '.' + directory_name
        self.file_system[new_directory] = []
        print(f"Created directory: {new_directory}")
        
    def clear_console(self):
        # Clear the console screen
        os.system('clear')

    def save_file_system(self):
        # Save the file system to fs.json
        with open('fs.json', 'w') as f:
            json.dump(self.file_system, f)
        print("File system saved to fs.json")

    def remove_file(self, file_name):
        # Simulate removing a file or directory
        full_path = self.current_directory + '.' + file_name
        if full_path in self.file_system:
            del self.file_system[full_path]
            print(f"Removed: {full_path}")
        else:
            print(f"File or directory not found: {file_name}")

    def get_info(self):
        # Display version and developer information
        print(f"Emulated Shell Version: {self.version}")
        print("Developers:")
        for developer in self.developers:
            print(f"- {developer}")
    
    def help_msg(self):
        #displays the help screen and the available commands for the PyShell
        print(f"this Shell simulator is made to simulate the J-OS Term(J-Term) as much as possible")
        print("Available commands are:")
        print(" ")
        print("exit === Exits the shell (WARNING!: It does NOT save the changes you made to the shell or the filesystem.)")
        print(" ")
        print("cd === Changes the directory you are in at the moment by the one you specify, example 'cd .a'")
        print(" ")
        print("sd === Shows the directory you are in at the moment, example: sd")
        print("file1,txt   .a   file2,txt")
        print("mkd === Makes a directory with the name you specify, example: 'mkd b' output will be: 'Directory b created succesfully! on the' directory you specified")
        print("mkf === creates a empty file for you to edit using 'nano' keep in mind this is NOT a nano fork, we just wrote a basic layout of I/O of words")
        print("nano === Edits a file with ',txt' termination, you can write whatever you want and save it by pressing enter!")
        print("info === Prints info about the system, like the version and the developers who worked on it")
        print("cls === Clears the screen, everyone likes to focus on what are they writting!")
        print("rm === Removes files and folders with only specifying the name!")
        print("sfs === Saves the FileSystem you created for later use on future sessions!")
        print("luc === Lists the Used Commands, just in case you forgotrn what you used!")
        print("This terminal emilator is part of the J-OS_OSFS project, and it can be used as a tool to learn how to use J-OS_OSFS correctly in early stages")
        print("With love, The J-OS Devs <3")

    def nano_editor(self, file_name):
        # Simulate a basic text editor (nano) for reading, writing, and saving .txt files
        file_path = self.current_directory + '.' + file_name
        if file_path in self.file_system:
            print(f"Opening file: {file_path}")
            content = input("Enter text (Ctrl-D to save and exit):\n")
            self.file_system[file_path] = content.split('\n')
            print(f"File saved: {file_path}")
        else:
            print(f"File not found: {file_name}")

    def make_file(self, file_name):
        # Simulate creating an empty file
        file_path = self.current_directory + '.' + file_name
        if not file_name.endswith(('.txt', ',bin', ',sh', ',exe')):
            print("Sorry, binaries are not supported yet.")
        elif file_path not in self.file_system:
            self.file_system[file_path] = []
            print(f"Created empty file: {file_path}")
        else:
            print(f"File already exists: {file_path}")

# Emulated Shell Loop
shell = EmulatedShell()
while True:
    user_input = input(f"{shell.current_directory}> ")
    if user_input.lower() == 'exit':
        break
    shell.run_command(user_input)
