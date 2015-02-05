//
//  AppDelegate.m
//  Meme Maker
//
//  Created by Avikant Saini on 1/20/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
	DetailViewController *dvc;
	UIStoryboard *storyboard;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	BOOL connectedToInternet = false;
//	NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://google.com"] encoding:NSUTF8StringEncoding error:nil];
//	if (connect != NULL)
//		connectedToInternet = true;
	[[NSUserDefaults standardUserDefaults] setBool:connectedToInternet forKey:@"ConnectedToInternet"];

	[[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"TimesLaunched"]+1 forKey:@"TimesLaunched"];
	NSLog(@"Times Launched = %i", (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"TimesLaunched"]);
	if ([[NSUserDefaults standardUserDefaults] integerForKey:@"TimesLaunched"] < 2) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ContinuousEditing"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AutoDismiss"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ResetSettingsOnLaunch"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DarkMode"];
		
		[[NSUserDefaults standardUserDefaults] setFloat:64.0f forKey:@"RelativeFontScale"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TextAlignment"];
		[[NSUserDefaults standardUserDefaults] setObject:@"Impact" forKey:@"FontName"];
		[[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"StrokeWidth"];
		[[NSUserDefaults standardUserDefaults] setObject:@"Black (default)" forKey:@"OutlineColor"];
		[[NSUserDefaults standardUserDefaults] setObject:@"White (default)" forKey:@"TextColor"];
	}
	
	UIPageControl *pageControl = [UIPageControl appearance];
	pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
	pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
	pageControl.backgroundColor = [UIColor whiteColor];
	
	return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	if (url != nil && [url isFileURL]) {
		NSData *imageData = [NSData dataWithContentsOfURL:url];
		UIImage *image = [UIImage imageWithData:imageData];
		
		NSData *dataOfImage = UIImageJPEGRepresentation(image, 0.8);
		NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image.jpg"]];
		[dataOfImage writeToFile:imagePath atomically:YES];
		[[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:@"ImagePath"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LibCamPickUp"];
		
		storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		dvc = [storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
		[dvc presentViewController:dvc animated:YES completion:^{
			NSLog(@"Finished Loading");
		}];
		
	}
	return YES;
}


- (NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:name];
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
