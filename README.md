# EZCompleteOSX
A working, highly customizable GPT-3 client for use on any command line interface on Mqc computers. Works inside any Mac shell / bash / zsh environment, including inside VSCode Studio.  Choose from a variety of models and configure to your liking, reusing the same settings or optionally changing on a per prompt basis.  Apple's speech framework is used to speak the responses, which are also logged in the console, and opti0onally copied to clipboard automAGically.

This version is extra verbose, since I used NSLog statements for debugging and kept some of the extras for now. It works great, but still has a little bit of beta and a whole lotta code cleanup to do still.  

Oh yeah, this is written entirely in Objective C, no python, no node.js, that would be too easy, they have libraries with convenience functions.  
I'll be using a better text to speech API soon, I'm debating using ELEVEN Labs, or possibly a much better one I was researchihng today. Either way, I'll implement Apple's nativew SPeech Detection for the initial Speech to Text.  I saw Apple has a Natural Language Model that's been in Private Frameworks since iOS 13 at least.  Apple is doing a lot with AI, they are just being hush hush about a lot of it, and not callijng it "AI" (yet).  Still, if you have an iphone chances are you have been training models for a long time without even realizing it...... The voice right now is pretty lame, but it can be changed just by swapping the location, so instead of "en--US" a change to "en-GB" will give it a British accent. You can configure the utterances as well to your liking.

You'll need an OpenAI API key for the requests to be processed.  If you dont have one you can get one at https://beta.openai.com

Any issues, or suggestions for improvements feel free to open a Pull Request or create an issue..  

