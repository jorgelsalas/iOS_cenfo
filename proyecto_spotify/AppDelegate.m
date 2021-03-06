//
//  AppDelegate.m
//  proyecto_spotify
//
//  Created by Jorge Salas C on 8/15/15.
//  Copyright (c) 2015 Jorge Salas C. All rights reserved.
//
#import <Spotify/Spotify.h>
#import "SpotifyHelper.h"
#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SpotifyHelper requestSessionUsingApplication:application];
    return YES;
}

// Handle auth callback
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    
    BOOL result = [SpotifyHelper handleAuthRequestWithUrl:url];
    if(result){
        //Do something if it was successful, in this case start playing
        //[self playUsingSession:[SpotifyHelper getSession]];
        //[self searchForArtistUsingSession:[SpotifyHelper getSession]];
        [SpotifyHelper searchForArtist];
    }
    else{
    
    }
    return result;
}

-(void)playUsingSession:(SPTSession *)session {
    //[self searchForArtistUsingSession:session];
    
    //[SpotifyHelper searchForArtist];
    
    // Create a new player if needed
    if (self.player == nil) {
        self.player = [[SPTAudioStreamingController alloc] initWithClientId:[SPTAuth defaultInstance].clientID];
    }
    
    [self.player loginWithSession:session callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** Logging in got error: %@", error);
            return;
        }
        
        NSURL *trackURI = [NSURL URLWithString:@"spotify:track:58s6EuEYJdlb0kO7awm3Vp"];
        [self.player playURIs:@[ trackURI ] fromIndex:0 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** Starting playback got error: %@", error);
                return;
            }
        }];
    }];
}

-(void) searchForArtistUsingSession:(SPTSession *) session {
    [SPTSearch performSearchWithQuery:@"incubus" queryType:SPTQueryTypeArtist accessToken:session.accessToken callback:^(NSError *error, id object) {
        if (error != nil || [(SPTListPage*)object items].count <= 0) {
            NSLog(@"*** error while searching for Incubus %@", error);
            return;
            
        }
        NSArray* results = [(SPTListPage*)object items];
        NSLog(@"SEARCH RESULTS: \n%@", results);
        SPTArtist* artist = [results objectAtIndex:0];
        
        NSLog(@"ARTIST[0] NAME: \n%@", [artist name]);
        
        
        NSLog(@"ARTIST[0] ID: \n%@", [artist identifier]);
        //NSLog(@"ARTIST[0] Genres: \n%@", [[artist genres]objectAtIndex:0]);
        //NSLog(@"ARTIST[0] followers: \n%ld", [artist followerCount]);
        
        
        for (SPTArtist* artist2 in results) {
            NSLog(@"ARTIST2 Name: \n%@", [artist2 name]);
            NSLog(@"ARTIST2 ID: \n%@", artist2.identifier);
            NSLog(@"ARTIST2 playable URL: \n%@", artist2.playableUri);
            NSLog(@"ARTIST2 sharing URL: \n%@", artist2.sharingURL);
        }
        
        
        //SPTPartialArtist* fullArtist;
    }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
