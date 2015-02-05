//
//  MemeObject.m
//  Meme Maker
//
//  Created by Avikant Saini on 1/20/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "MemeObject.h"

@implementation MemeObject

-(id) initWithName: (NSString *)theName image: (NSString *)theImage tags: (NSString *)theTags url: (NSString *)theURL {
	MemeObject *meme = [MemeObject new];
	meme.Name = theName;
	meme.Image = theImage;
	meme.Tags = theTags;
	meme.URL = theURL;
	return meme;
}

@end
