//
//  MemeObject.h
//  Meme Maker
//
//  Created by Avikant Saini on 1/20/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemeObject : NSObject

@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *Image;
@property (strong, nonatomic) NSString *Tags;
@property (strong, nonatomic) NSString *URL;

@property (strong, nonatomic) NSString *topText;
@property (strong, nonatomic) NSString *bottomText;

-(id) initWithName: (NSString *)theName image: (NSString *)theImage tags: (NSString *)theTags url: (NSString *)theURL;

@end
