//
//  MemeProtocol.h
//  Meme Maker
//
//  Created by Avikant Saini on 2/12/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MemeObject;
@protocol MemeProtocol <NSObject>

-(void)selectedMeme:(MemeObject*)meme;


@end
