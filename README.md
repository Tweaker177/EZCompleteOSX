# EZCompleteOSX
A working, highly customizable GPT-3 client for use on any command line interface on Mqc computers. Works inside any Mac shell / bash / zsh environment, including inside VSCode Studio.  Choose from a variety of models and configure to your liking, reusing the same settings or optionally changing on a per prompt basis.  Apple's speech framework is used to speak the responses, which are also logged in the console.

Makefile and a couple other files need configured to make a rootless build. This version is extra verbose,
since I used NSLog statements
for debugging and kept some of the extras for now. Oh yeah, this is written entirely in Objective C, no python, no node.js, that would be too easy, they have libraries with convenience functions.


You'll need an OpenAI API key for the requests to be processed.  If you dont have one you can get one at https://beta.openai.com

Any issues, or suggestions for improvements feel free to open a Pull Request or create an issue..  

