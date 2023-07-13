#import <Foundation/Foundation.h>
#import "OpenAIKeyManager.h"

#define davinci003 @"text-davinci-003"
//davinci003 is the default model, and the best for completions
//Need to implement chat format to use the 3.5 GPT model and 4 for those who have access to it.

#define davincitext002 @"text-davinci-002"
#define curie @"text-curie-001"
#define babbage @"text-babbage-001"
#define ada @"text-ada-001"


NSString *temperatureString = @"1";
NSString *frequency_penaltyString = @"0.4";
float temperature = 0.9f;
float frequency_penalty = 0.2f;
static NSString *kOPENAI_API_KEY = nil;
static NSString *input = nil;

static NSString *model = @"text-davinci-003";
//Prefs_setObjectForKey(model, @"model");
//saving to user defaults with convenience method defined in header file    

static void getNewModel(void) {
    //this function handles the input output for changing the model and saves the change
    //to user defaults  so it will be used in the next session.
   
    NSLog(@"\nWanna try a new Model?  Ok.  Don't upset Fabel though.\nDo you want (1)Ada (2)Babbage (3)davinci003 (4)curie or (5)davinci002");
        
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
     else {
         model = davinci003;
      
         
     }
       // continue;
    Prefs_setStringForKey(model, @"model");
    NSLog(@"\nModel has been set to %@", model);
  //  return;
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
                 temperatureString = @"0.8";
                 temperature = 0.6;
                 
             }
             else if([temperatureString isEqualToString:@"3"]) {
                 temperatureString  = @"1.35";
                 temperature = 1.35;
                 
             }
          else {
              temperatureString = @"0.9";
              temperature = 0.75;
          }
            // continue;
         Prefs_setObjectForKey(@(temperature), @"temperature");
         NSLog(@"\nTemperature has been set to %@", temperatureString);
       //  return;
     }

static void getFrequencyPenalty(void) {
    NSLog(@"\nHow much do you want to penalize repitition?\n Enter a number from 0 to 1: \n");
    
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
            
    if([kOPENAI_API_KEY containsString:@"sk"] && kOPENAI_API_KEY.length > 9) {
                //OPENAI_API_KEY in userdefaults is set or environment worked
               
            NSLog(@"\nSweet! Found your API Key. We're all set to have some fun.\n");
           // NSLog(@"\nYour API key= %@", kOPENAI_API_KEY);
            
        }
        
    if(!kOPENAI_API_KEY || ![kOPENAI_API_KEY containsString:@"sk"]) {
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
            NSLog(@"\nEnter (T) for Temper change; (F) for frequency change, (M) for Model OR (P) enter a prompt OR type 'exit' to quit): \n");
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
                NSLog(@"\nTEMP HAS BEEN SET TO %@ ", temperatureString);
                Prefs_setObjectForKey(@(temperature), @"temperature");
                input = @"";
                
                NSLog(@"\n\nEnter (F) for frequency change, (P) to enter a prompt OR type (exit) to quit): \n");
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
                NSLog(@"\n\nType (T) for Temperature change, (P) for a prompt, OR type (exit) to quit): \n");
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
    
            
        
    if (((prompt.length > 0) && (prompt.length <= 3200)) && (![prompt isEqualToString:@""] && ![prompt containsString:@"D^D^D^D^"]))
        {          //D^D^D^D^ is some sort of escape sequence that causes an overflow if enough are repeated fast enough
                //3200 is arbitrary need to make this customizable
            
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
            isValidInput = ((0 < prompt.length) && ![prompt containsString:@"D^D^D^D^"] && (prompt.length <= 3250)) ? YES : NO;
                if(isValidInput) {
                                     //prompt = input;
                               NSLog(@"Prompt to be sent: %@", prompt);
                            }
            } //end of while not valid input and not exit
        }  //end of else- error handling for too big an input
        
     // ---------------------------------------------------------------------------------------/
           

        
        static NSString *baseUrl = @"https://api.openai.com/v1/";
        Prefs_setObjectForKey(baseUrl, @"baseUrl");
            //preliminary setup to allow for user selected model and compatible baseurl
       
        
        
        kOPENAI_API_KEY = Prefs_getString(@"OPENAI_API_KEY");
       // NSLog(@"\nOpenAIKey before starting post = %@\n", kOPENAI_API_KEY);
        NSURLSession *session = [NSURLSession sharedSession];
            // Send prompt to OpenAI API
        NSString *urlString = [NSString stringWithFormat:@"%@completions", baseUrl];
            //make sure to check baseUrl compatibility with other models endpoints
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request addValue:[NSString stringWithFormat:@"Bearer %@", kOPENAI_API_KEY] forHTTPHeaderField:@"Authorization"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            //  temperature = [temperatureString floatValue];
        NSDictionary *parameters = @{
            @"model": model,
            @"prompt": prompt,
            @"max_tokens": @2000,    //this model can handle up to like 2000
            @"temperature": @(temperature),  //higher values give more variety default=1
            @"frequency_penalty": @(frequency_penalty),
            @"presence_penalty": @0.0,
            @"n": @1,    //number of completions requested per prompt
            @"stop": @"D^D^D^D^D"   //chose this because the model used to crash the terminal with bombs of this sequence
        };
        NSLog(@"\nParameters have been entered model= %@  prompt= %@ temp = %f frequency= %f\n", model, prompt, temperature, frequency_penalty);
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        [request setHTTPBody:postData];
       
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"\nError: %@", error.localizedDescription);
            }
            else {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray *completions = json[@"choices"];
                for (NSDictionary *completion in completions) {
                    NSString *text = completion[@"text"];
                    NSLog(@"\n%@", text);
                }
            }
        }];  //end of completion handler
        [task resume];
        input=@"";
    }        //end of main loop, while YES
   
        
  } //end of @autoreleasepool
    
    return 0;
} //end of main.  That wasn't so hard... now time to make her talk.  Or him. Or they. 

