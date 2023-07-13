#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AppKit/AppKit.h> //needed for mac
#import "OpenAIKeyManager.h"

#define davinci003 @"text-davinci-003"
//davinci003 is the default model, and the best for completions
//Need to implement chat format to use the 3.5 GPT model and 4 for those who have access to it.

#define davincitext002 @"text-davinci-002"
#define curie @"text-curie-001"
#define babbage @"text-babbage-001"
#define ada @"text-ada-001"
#define DALLE @"DaLLE"

 NSString *urlString;

NSString *imageURL;
 NSString *tokenString = @"";

static unsigned long nCompletions = 1;

unsigned long numberOFIMAGES = 4;
//refs_setObjectForKey(@4, @"n");

static NSString *IMAGE_SIZE = @"1024x1024";
//Prefs_setStringForKey(IMAGE_SIZE, @"size");
//IMAGE_SIZE = Prefs_getString(@"size");
NSString *temperatureString = @"1";
NSString *frequency_penaltyString = @"0.4";
float temperature = 0.9f;
float frequency_penalty = 0.2f;
static NSString *kOPENAI_API_KEY = nil;
static NSString *input = nil;
static NSString *stringToBeUttered;

static NSString *model = @"text-davinci-003";
static NSString *stopSequence = @"D^D^D^D^D";
static NSString *inputText = @"";

static unsigned long MAX_TOKENS = 2000;
static NSString *AIreponseText=@"";

static NSString *baseUrl = @"https://api.openai.com/v1/";
//Prefs_setStringForKey(baseUrl, @"baseUrl");



    //preliminary setup to allow for user selected model and compatible baseurl


//Prefs_setObjectForKey(model, @"model");
//saving to user defaults with convenience method defined in header file

/***
 NSString *inputText= @"";
 long int i= 0;
 while (![inputText isEqualToString:@"exit"] && (i<10)) {
     
     
     NSString *newText = @"The quick brown fox jumped over the lazy dog, it was quite a sight to see. I am so amazed I can even tell you this story it was so incredible..";
     long int tmp = i;
     newText = [newText stringByAppendingString:[NSString stringWithFormat:@"%li\n", (long)tmp]];
     i++; // Increment the integer value
    
         
         // Create an utterance.
 NSString *utteranceString = newText;
 
     AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:utteranceString];
     
         // Configure the utterance.
     utterance.rate = 0.57;
     utterance.pitchMultiplier = 0.8;
     utterance.postUtteranceDelay = 1.5;
     utterance.volume = 0.8;
     
         // Retrieve the British English voice.
     AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
     
         // Assign the voice to the utterance.
     utterance.voice = voice;
     
         // Create a speech synthesizer.
     AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
     
         // Tell the synthesizer to speak the utterance.
     [synthesizer speakUtterance:utterance];
 
     NSLog(@"has the speech finished?\n");
     char temp[75];
     scanf("%s", temp);
     inputText = [NSString stringWithUTF8String: temp];
     if([inputText containsString:@"exit"]) {
         break;
     }

         // Keep the program running to allow speech synthesis to complete.
     //[[NSRunLoop mainRunLoop] run];
 }
}
return 0;
}

 
 */

static void getAndSpeakCompletion(NSString* newText) {
  //  NSString *tmpText = newText;
    
   // while((![inputText isEqualToString:@"exit"] ) && (tmpText != nil) && ![newText isEqualToString:stopSequence]) {
     //   newText = [newText stringByAppendingString: tmpText];
    if(newText!=nil && ![newText isEqualToString:@""]) {
        NSString *utteranceString = newText;
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:utteranceString];
        
            // Configure the utterance.
        utterance.rate = 0.49;
        utterance.pitchMultiplier = 0.8;
        utterance.postUtteranceDelay = 0.95;
        utterance.volume = 0.8;
            // utterance.utteranceString = utteranceString;
            // Retrieve the British English voice.
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        //en-GB
            // Assign the voice to the utterance.
        utterance.voice = voice;
        
            // Create a speech synthesizer.
        AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
        
            //let system audio deal with that BS
            //API UNAVAILABLE MACOS, iOS>13  [synthesizer setUsesApplicationAudioSession: NO];
        @try {
            [utteranceString writeToFile:@"/Users/i0stweak3r/Library/Application Support/EZComplete/utterance.txt" atomically: YES encoding:NSUTF8StringEncoding error: nil ];
            
            //try to write to file, to later be able to reference to cure goldfish memory
            
        }
       
        @catch (NSError *error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }

        
        
    //Display the output before the speech starts so if it's long or too slow the user can read while listening or waiting.
        NSLog(@"Utterance = %@\n", utteranceString);
            
                // Tell the synthesizer to speak the utterance.
            [synthesizer speakUtterance:utterance];
       

            NSLog(@"Utterance has been spoken.\n");
            NSLog(@"Did you want to copy to clipboard the spoken completion?\n");
        //    [synthesizer speakUtterance:utterance];
            
            
            char temp[75];
            scanf("%s", temp);
            inputText = [NSString stringWithUTF8String: temp];
        if([inputText containsString:@"exit"] || [inputText isEqualToString:@"y"] || ([inputText containsString:@"yes"] || [inputText containsString:@"YES"])) {
                    //copy to clipboard
                NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
                [pasteboard clearContents];
                [pasteboard setString:utteranceString forType:NSPasteboardTypeString];
                    //log that pasteboard has been copied
                NSLog(@"Completion has been copied to pasteboard.\n");
                    //log on screen
               
                    // Keep the program running to allow speech synthesis to complete.
           // break;
                return;
           
        }
        return;
        
    }
        
        return;
        
    }

    

    /***
    }
    else { return;  }
}
**/

static void getNewModel(void) {
    //this function handles the input output for changing the model and saves the change
    //to user defaults  so it will be used in the next session.
   
    NSLog(@"\nWanna try a new Model?  Ok.  Don't upset Fabel though.\nDo you want (1)Ada (2)Babbage (3)davinci003 (4)curie or (5)davinci002 or (6) for DallE image generations.");
        
        char temp[75];
        scanf("%s", temp);
        model = [NSString stringWithUTF8String: temp];
        if ([model  isEqualToString:@"1"]) {
            model = ada;
           
            
        }
        else if([model isEqualToString:@"2"]) {
            model = babbage;
            
        }
        else if([model isEqualToString:@"3"]) {
            model  = davinci003;
           
        }
        else if([model isEqualToString:@"4"]) {
            model  = curie;
        }
        else if([model isEqualToString:@"5"]) {
            model  = davincitext002;
        }
            //NSNumber *NumberForInt = [NSNumber numberWithInt:numberOFIMAGES];
            else if([model isEqualToString:@"6"]) {
                model = DALLE;
            unsigned long long numberOFIMAGES = 4;
            Prefs_setObjectForKey(@(numberOFIMAGES), @"n");
            //NString* imageSize = @"1024x1024";
           // Prefs_setStringForKey(imageSize, IMAGE_SIZE);
            NSString *imageURL = [NSString stringWithFormat:@"%@images/generations", baseUrl];
       //     if([Prefs_getString(@"urlString") isEqualToString:imageURL]) {
                NSLog(@"URL for images endpoint is: %@", imageURL);
          //  }
            imageURL= @"https://api.openai.org/v1/images/generations";
            urlString = imageURL;
            Prefs_setStringForKey(imageURL, @"urlString");
           // Prefs_setObjectForKey(@(4), n);
            Prefs_setStringForKey(model, @"model");
            NSLog(@"Images endpoint set to %@ model = %@\n", imageURL, model);
        }
     else {
         model = davinci003;
      
         
     }
       // continue;
    Prefs_setStringForKey(model, @"model");
    NSLog(@"\nModel has been set to %@", model);
  //  return;
}

static void getMaxTokens(void) {
        //Prefs_setObjectForKey(@(MAX_TOKENS), @"max_tokens");

        //this function allows users to limit token use on a per prompt basis
    NSLog(@"\nHow many tokens do you want to set as the max?\n Enter a number from 20 to 2020: \n");
    NSString *tokenString = @"";
    NSNumber *max_tokenz;
    char freq[75];
    scanf("%s", freq);
    if(freq[1]!='\n') {
        tokenString = [NSString stringWithUTF8String: freq]; //NSUTF8StringEncoding];
        
        
            //Use NSNumberFormatter to switch from string to NSNumber and to float values
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        max_tokenz = [formatter numberFromString:tokenString];
        MAX_TOKENS = [max_tokenz integerValue];
        NSLog(@"\nMax tokens has been set to: %@ = %lu \n", tokenString, MAX_TOKENS);
        Prefs_setObjectForKey(@(MAX_TOKENS), @"max_tokens");
            //   return;
    }
    else {
        tokenString = [NSString stringWithUTF8String: freq];
        NSLog(@"invalid input for max tokens. Input was: %@\n", tokenString);
        return;
        
    }
}

static void getTemperatureString(void) {
        //this function handles the input output for changing the temperature and saves the change
        //to user defaults  so it will be used in the next session.
        //tecnically it is saving a string, but it is converted to a float when it is used in the completion request.
        //I created this as a string for debugging purposes, but it could be changed to a float.

             NSLog(@"\nHow creatively do you want ur model cooked,(1)rare,(2)medium, or (3)smoking hot? (Anything else=default)\n");
         //Need to change this to user inputting exact value they want. I noticed the models hallucinate a LOT with higher
         //temperature values.  For now this works tho with the default settihng being a little creative, the rare and medium
         //settings more deterministic
             char temp[75];
             scanf("%s", temp);
             temperatureString = [NSString stringWithUTF8String: temp];
             if ([temperatureString  isEqualToString:@"1"]) {
                 temperatureString = @"0.3";
                 temperature = 0.3;
                 
             }
             else if([temperatureString isEqualToString:@"2"]) {
                 temperatureString = @"0.95";
                 temperature = 0.95;
                 
             }
             else if([temperatureString isEqualToString:@"3"]) {
                 temperatureString  = @"1.35";
                 temperature = 1.35;
                 
             }
          else {
              temperatureString = @"0.75";
              temperature = 0.75;
          }
            // continue;
         Prefs_setObjectForKey(@(temperature), @"temperature");
         NSLog(@"\nTemperature has been set to %f = %@\n", temperature, temperatureString);
       //  return;
     }

static void getFrequencyPenalty(void) {
    NSLog(@"\nHow much do you want to penalize repitition?\n Enter a number from 0 to 2: \n");
    
    char freq[75];
    scanf("%s", freq);
    frequency_penaltyString = [NSString stringWithUTF8String: freq]; //NSUTF8StringEncoding];
    
    
        //Use NSNumberFormatter to switch from string to NSNumber and to float values
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *frequency_pen = [formatter numberFromString:frequency_penaltyString];
    frequency_penalty = [frequency_pen floatValue];
    NSLog(@"\nFrequency Penalty has been set to: %@ = %f \n", frequency_penaltyString, frequency_penalty);
    Prefs_setObjectForKey(@(frequency_penalty), @"frequency_penalty");
 //   return;
}


int main(int argc, const char * argv[]) {
        // log.info("Starting main")
        // ...
    
    @autoreleasepool
{
        
    
    OpenAIKeyManager *keyManager = [[OpenAIKeyManager alloc] init];
    //Fetch the key using OpenAIKeyManager class's convenience function, that calls a few other functions to either retrieve key from
    //User Defaults, then it checks the environment variable, and if not set up the most common reccommended way then it prompts user for key
    // Only issue is it doens't validate with OpenAI if the key is active, so if a key is saved it assumes it's good and moves on.
    kOPENAI_API_KEY = [keyManager getOpenAI_API_Key];
    //Added this to solve above issue for now, giving option to mention if say you leak your API key on Github sharing your CLI based chat program
NSLog(@"Would you like to set up a new API Key(@'Y/N?') \n");
    NSFileHandle *console = [NSFileHandle fileHandleWithStandardInput];
    input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
    input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      if(([input isEqualToString:@"YES"] || [input containsString:@"yes"]) || ([input isEqualToString:@"Y"] || [input isEqualToString:@"y"])) {
        kOPENAI_API_KEY = [keyManager promptUserForKey];
        
          }
        
       // OpenAIKeyManager *keyManager = [[OpenAIKeyManager alloc] init];
        
       // kOPENAI_API_KEY = [keyManager getOpenAI_API_Key];
            
    if([kOPENAI_API_KEY containsString:@"sk-"] && kOPENAI_API_KEY.length > 9) {
                //OPENAI_API_KEY in userdefaults is set or environment worked
               
            NSLog(@"\nSweet! Found your API Key. We're all set to have some fun.\n");
           // NSLog(@"\nYour API key= %@", kOPENAI_API_KEY);
            
        }
        
    if(!kOPENAI_API_KEY || ![kOPENAI_API_KEY containsString:@"sk-"]) {
            NSLog(@"Thanks for installing EZComplete.\nTo connect to OpenAI enter your API key: ");
                //Users should only have to enter their API Key the first time using program, then it will be stored in user defaults.
                //They should never see this unless they had an issue twice setting it up already in the same session.
            
            kOPENAI_API_KEY = [keyManager getOpenAI_API_Key];
           
            Prefs_setStringForKey(kOPENAI_API_KEY, @"OPENAI_API_KEY");
            
        }
        
        
        BOOL isValidInput = NO;
        NSString *prompt = nil;
        input = nil;
        
        
            //this while loop is a bad habit, should probably replace with something less likely to get stuck
            //in a neverending loop as project grows and loops are nested.
    while (YES) {
        input = nil;
            // Prompt user for input
        NSLog(@"\nEnter ('Max') for Max token limit, (T) for Temper change; (F) for frequency change, (M) for new Model OR (P) to enter a prompt. Type 'exit' to quit): \n");
        NSFileHandle *console = [NSFileHandle fileHandleWithStandardInput];
        input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
        input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        if(input.length > 80) {
            isValidInput = NO;
            NSLog(@"\nInvalid input. Spray. You've been sanitized.\n");
            input = @""; //clear the existing input and then skip to the start of the loop
            continue;
        }
        
        
        if ([input isEqualToString:@"exit"]) {
            break;
        }
            //handle first prompt and options screen
        if([input isEqualToString:@"T"])
        {
            NSLog(@"\nThe current temperature setting is: %f", temperature);
            getTemperatureString();
            Prefs_setObjectForKey(@(temperature), @"temperature");
            NSLog(@"\nTEMP HAS BEEN SET TO %f = %@ \n",  temperature, temperatureString);
            
            input = @"";
            
            NSLog(@"\n\nEnter (F) for frequency change, (M) for new model, (P) to enter a prompt, ('Max')for MAX_TOKENS,  OR type (exit) to quit): \n");
            console = [NSFileHandle fileHandleWithStandardInput];
            input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
            input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(input.length > 40) {
                isValidInput = NO;
                NSLog(@"\nInvalid input. Spray. You've been sanitized.\n");
                input= @""; //clear the existing input and then skip to the start of the loop
                continue;
            }
            NSLog(@"%@", input);
            
            
        }
        
        
        if ([input isEqualToString:@"exit"]) {
            break; //exit the program
        }
        
        if([input isEqualToString:@"M"] || [input isEqualToString:@"m"]) {
            model = Prefs_getString(@"model");
            NSLog(@"\nThe current model in use is:%@\n", model);
            /*****************************************************************************************  Custom Model  ******************************/
                //Output the current model in use, then use the getNewModel function to prompt for a new model  and set it.
            getNewModel();
            model = Prefs_getString(@"model");
            NSLog(@"\nThe model has been changed to: %@\n",model);
            input = @"";
                //So we don't have to go back to the start of the loop, we'll get another input
            NSLog(@"\n\nType (T) for Temperature change, (P) for a prompt, ('MAX') for MAX_TOKENS, OR type (exit) to quit): \n");
            console = [NSFileHandle fileHandleWithStandardInput];
            input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
            input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(input.length > 40) {
                isValidInput = NO;
                NSLog(@"\nInvalid input. Spray. You've been sanitized.\n");
                    //clear the existing input and then skip to the start of the loop
                input = @"";
                continue;
            }
            
            NSLog(@"%@", input);
        }
        
        if([input isEqualToString:@"Max"] || [input isEqualToString:@"max"] || [input isEqualToString:@"MAX"])
        {
            /****************************************************************************************max_tokens*****************************/
            MAX_TOKENS = [[Prefs objectForKey:@"max_tokens"] integerValue];
            NSLog(@"\nThe current MAX_TOKENS is set at: %lu\n", MAX_TOKENS);
            getMaxTokens();
            NSLog(@"\nMax Tokens has been set to: %@ = %lu\n", tokenString, MAX_TOKENS);;
            input = @"";
            
            NSLog(@"\n\nType (T) for Temperature change, (F) for frequency penalty, (M) for Model, ('MAX') for max tokens,\nor (P) for a prompt. Type (exit) to quit): \n");
            console = [NSFileHandle fileHandleWithStandardInput];
            input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
            input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(input.length > 40) {
                isValidInput = NO;
                NSLog(@"\nInvalid input. Spray. You've been sanitized.\n");
                input = @""; //clear the existing input and then skip to the start of the loop
                continue;
            }
            
            NSLog(@"%@", input);
        }
        
        if ([input isEqualToString:@"exit"]) {
            break;
        }
        
        //if([input isEqualToString:@"M"] || [input isEqualToString:@"MAX"] || [input isEqualToString:@"m"]) {
     //       continue;   //since we already checked for model and max tokens, continue back to beginning of the loop, to call the desired option
     //   }
        if([input isEqualToString:@"F"] || [input isEqualToString:@"f"])
        {
            /***********************************************************************************************FREQ******************************/
            NSLog(@"\nThe current frequency penalty is set at: %f\n", frequency_penalty);
            getFrequencyPenalty();
            NSLog(@"\nFrequency penalty has been set to: %@ = %f\n",frequency_penaltyString, frequency_penalty);
            input = @"";
            
            NSLog(@"\n\nType (T) for Temperature change, (P) for a prompt, OR type (exit) to quit): \n");
            console = [NSFileHandle fileHandleWithStandardInput];
            input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
            input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(input.length > 40) {
                isValidInput = NO;
                NSLog(@"\nInvalid input. Spray. You've been sanitized.\n");
                input = @""; //clear the existing input and then skip to the start of the loop
                continue;
            }
            
            NSLog(@"%@", input);
        }
        
        if ([input isEqualToString:@"exit"]) {
            break;
        }
        
        if([input isEqualToString:@"T"]) {
            NSLog(@"\nThe current temperature setting is: %f", temperature);
            getTemperatureString();
            NSLog(@"\nTEMP HAS BEEN SET TO %f \n", temperature);
            input = @"";
            NSLog(@"\n\nType (P) for a prompt, OR type (exit) to quit): \n");
            console = [NSFileHandle fileHandleWithStandardInput];
            input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
            input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(input.length > 40) {
                isValidInput = NO;
                NSLog(@"\nInvalid input. Spray. You've been sanitized.\n");
                input = @""; //clear the existing input and then skip to the start of the loop
                continue;
            }
            NSLog(@"%@", input);
            
        }
        
            //debating removing this check to see if prompt is chosen
            //It's nice because it gives you control of the conversation at all times
            //but it's also annoying because you have to type P every time you want to enter a prompt
            //I think I'll leave it in for now
        
        if(!([input isEqualToString:@"P"] || [input isEqualToString:@"p"])) {
            if ([input isEqualToString:@"exit"]) {
                break;
            }
            continue;
        }  //start over if not a prompt
        
            //Finally, lets enter a prompt or GTFO
        NSLog(@"\n\nEnter a prompt OR type (exit) to quit): \n");
        console = [NSFileHandle fileHandleWithStandardInput];
        input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
        prompt  = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([prompt isEqualToString:@"exit"]) {
            break;
        }
            //This display of the prompt to be sent was mainly for debugging purposes
            //        NSLog(@"\nPrompt to be sent: %@", prompt);
        
        
        
        if (((prompt.length > 0) && (prompt.length <= MAX_TOKENS)) && (![prompt isEqualToString:@""] && ![prompt containsString:stopSequence]))
        {          //D^D^D^D^ is some sort of escape sequence that causes an overflow if enough are repeated fast enough
                   //changed this to MAX_TOKENS, not exactly equal but at least it's customizable
            
            isValidInput = YES;
                //  NSString* boolString = isValidInput ? @"true" : @"false";
                // NSLog(@"\nIs input valid? %@\n prompt: %@", boolString, prompt);
        }
        else {
            isValidInput = NO;
            while (isValidInput == NO && ![input isEqualToString:@"exit"]) {
                NSLog(@"\nError: input is too large or other problem exists\n");
                input = @"";
                prompt = @"";
                NSLog(@"\nEnter a prompt (or type 'exit'\n");
                NSFileHandle *console = [NSFileHandle fileHandleWithStandardInput];
                input = [[NSString alloc] initWithData:[[console availableData] mutableCopy] encoding:NSUTF8StringEncoding];
                prompt = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                isValidInput = ((0 < prompt.length) && ![prompt containsString:@"D^D^D^D^"] && (prompt.length <= MAX_TOKENS)) ? YES : NO;
                if(isValidInput) {
                        //prompt = input;
                    NSLog(@"Prompt to be sent: %@", prompt);
                }
            } //end of while not valid input and not exit
        }  //end of else- error handling for too big an input
        
            // ---------------------------------------------------------------------------------------/
        baseUrl = @"https://api.openai.com/v1/";
        NSString *urlString;
        //Prefs_getString(@"urlString");
       // if((urlString.length < 2) || !urlString) {
           
          //  urlString = baseUrl;
            Prefs_setStringForKey(baseUrl, @"baseUrl");
       // }
        
        urlString = baseUrl;
        kOPENAI_API_KEY = Prefs_getString(@"OPENAI_API_KEY");
            // NSLog(@"\nOpenAIKey before starting post = %@\n", kOPENAI_API_KEY);
        NSURLSession *session = [NSURLSession sharedSession];
            // Send prompt to OpenAI API
     
        urlString = [NSString stringWithFormat:@"%@completions", baseUrl];
            NSLog(@"\nURL string is for text completions endpoint %@\n", urlString);
       // }
        model = Prefs_getString(@"model");
        if([model isEqualToString:@"DALLE"])
         {
            urlString = imageURL;
            Prefs_setStringForKey(imageURL, @"urlString");
        }
            //make sure to check baseUrl compatibility with other models endpoints
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request addValue:[NSString stringWithFormat:@"Bearer %@", kOPENAI_API_KEY] forHTTPHeaderField:@"Authorization"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            //  temperature = [temperatureString floatValue];
        
        NSDictionary *parameters1 = nil;
        if([model isEqualToString:@"DALLE"]) {
            parameters1 = @{
                @"prompt":prompt,
                @"size":IMAGE_SIZE,
                @"n":@(numberOFIMAGES)
            };
            NSLog(@"\nIMG Parameters have been entered; model= %@  prompt= %@  size = %@ number of IMGS=%lu\n", model, prompt, IMAGE_SIZE, numberOFIMAGES);
                                                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters1 options:0 error:nil];
                                                [request setHTTPBody:postData];
                                                }
        else {
            NSDictionary *parameters = @{
                @"model": model,
                @"prompt": prompt,
                @"max_tokens": @(MAX_TOKENS),
                @"temperature": @(temperature),  //higher values give more variety default= 0.8
                @"frequency_penalty": @(frequency_penalty),
                @"presence_penalty": @0.05,
                @"n": @(nCompletions),    //number of completions requested per prompt
                @"stop": stopSequence   //chose this because the model used to crash the terminal with bombs of this sequence
            };
            
            NSLog(@"\nParameters have been entered model= %@  prompt= %@ temp = %f frequency= %f max_tokens= %lu\n", model, prompt, temperature, frequency_penalty, MAX_TOKENS);
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
            [request setHTTPBody:postData];
        }  //end of else
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error) {
                        NSLog(@"\nError: %@", error.localizedDescription);
                    }
                    else {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        NSArray *completions = json[@"choices"];
                        for (NSDictionary *completion in completions) {
                            NSString *text = completion[@"text"];
                            //NSString  *newText = nil;
                            if((text != nil) && ![text containsString:stopSequence]) {
                        
                   AIreponseText = [AIreponseText stringByAppendingString:text];
                                NSLog(@"\n%@\n", AIreponseText);  //moved this up a couple lines so it outputs to console b4 speaking
                                
                     getAndSpeakCompletion(AIreponseText);
                       
                            
                     
                                   }
                            /****
                            NSLog(@"has the speech finished?\n");
                            char temp[75];
                            scanf("%s", temp);
                            inputText = [NSString stringWithUTF8String:temp];
                            if([inputText containsString:@"exit"] || [inputText containsString:@"No"]) {
                                break;
                            }
                            else {
                             ***/
                                AIreponseText= @"";
                                continue;
                                
                           // }

                            
                            
                   } //end of completion for loop
                       
                } //end of else
            }];  //end of completion handler
            [task resume];
            input=@"";
       
           // utteranceString = @" ";
        }        //end of main loop, while YES
        
    //[dataTask terminate];
  } //end of @autoreleasepool
   
    
    return 0;
} //end of main.  That wasn't so hard... now time to make her talk in any language, with custom voices

