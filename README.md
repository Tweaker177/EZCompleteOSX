# EZCompleteOSX
A working, highly customizable GPT-3 client for use on any command line interface on Mqc computers. Works inside any Mac shell / bash / zsh environment, including inside VSCode Studio. (Best reason to avoid Copilot-- API calls are likely cheaper than the subscription for Copilot.  :D  Choose from a variety of models and configure to your liking, reusing the same settings or optionally changing on a per prompt basis.  Apple's speech framework is used to speak the responses, which are also logged in the console, and opti0onally copied to clipboard automAGically.

This version is extra verbose, since I used NSLog statements for debugging and kept some of the extras for now. It works great, but still has a little bit of beta and a whole lotta code cleanup to do still.  

Oh yeah, this is written entirely in Objective C, no python, no node.js, that would be too easy, they have libraries with convenience functions.  (Actually I may make my own Obj C version of the more common API functions).  First, though, this project is part of the 3%.... of projects still using completions instead of chat completions.  This will soon add support for chat completions, since after like 6 months of waiting now I finally have access to GPT 4, (and so will all other API users). Good news also is that they are going to allow fine tunings of GPT 3.5 turbo.)

I'll be using a better text to speech API soon. However, I first plan on using Apple's native Speech Detection for the initial Speech to Text.  Apple has a Natural Language Model that's been in Private Frameworks since iOS 13 at least. The TTS voice right now is pretty lame, but it can be changed just by swapping the location, so instead of "en--US" a change to "en-GB" will give it a British accent. You can configure the utterances as well to your liking.

You'll need an OpenAI API key for the requests to be processed.  If you dont have one you can get one at https://beta.openai.com

Any issues, or suggestions for improvements feel free to open a Pull Request or create an issue..  

[![i0S_tweak3r's GitHub stats](https://github-readme-stats.vercel.app/api?username=tweaker177)](https://github.com/tweaker177/github-readme-stats)

