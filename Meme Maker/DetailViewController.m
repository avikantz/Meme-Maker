//
//  DetailViewController.m
//  Meme Maker
//
//  Created by Avikant Saini on 1/20/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImage+ImageEffects.h"
#import "FontTableViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
	UITextView *topTextView, *bottomTextView;
	UIFont *defaultFont;
	
	NSData *dataOfLastEditedImage;
	NSString *imagePathOfLastEditedImage;
	
	UIImage *imagex;
	
	FontTableViewController *fontTableVC;
	
	BOOL shouldDisplayFontView;
	
	float keyboardHeight;
	
	CGRect topTextRect;
	CGRect bottomTextRect;
	
	UITapGestureRecognizer *tapImage;
	UISwipeGestureRecognizer *swipeFromBottom;
	UISwipeGestureRecognizer *swipeFromTop;
	
	UIPanGestureRecognizer *panGesture;
	
	UIPinchGestureRecognizer *pinchImage;
	
	int textAlignment;
	NSTextAlignment align;
	
	float topfontsize;
	float bottomfontsize;
	
	float strokeWidth;
	
	UIFont *cookingFont;
	
	UIColor *textColor;
	UIColor *outlineColor;
	
	UIDocumentInteractionController *documentController;
	
	UISwipeGestureRecognizer *swipeTextView;
	UISwipeGestureRecognizer *swipeTextView2;
	
	CGPoint topTextFrameOffset;
	CGPoint bottomTextFrameOffset;
	
	BOOL moveTop;
	
//	GADBannerView *bannerView;
}

-(void)viewWillDisappear:(BOOL)animated {
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_topField text]] forKey:@"lastEditedTopText"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_bottomField text]] forKey:@"lastEditedBottomText"];
}

-(void)viewDidAppear:(BOOL)animated {
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
												  forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
																	NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]};
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	
	defaultFont = [[UIFont alloc] init];
	defaultFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"] size:18.0f];
	[_topField setFont:defaultFont];
	[_bottomField setFont:defaultFont];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LoadingLastEdit"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"LibCamPickUp"]) {
		[_topField setText: [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedTopText"]];
		[_bottomField setText: [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedBottomText"]];
	}
	
	shouldDisplayFontView = YES;
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoDismiss"]) {
		[UIView animateWithDuration:0.3 animations:^{
			_twoSidedArrow.layer.transform = CATransform3DMakeTranslation(self.twoSidedArrow.frame.origin.x, [UIScreen mainScreen].bounds.size.height, 0);
			[self.twoSidedArrow setAlpha:0.0];
		}completion:nil];
	}
	
	textAlignment = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"TextAlignment"];
	switch (textAlignment) {
		case 0:
			align = NSTextAlignmentCenter;
			break;
		case 1:
			align = NSTextAlignmentJustified;
			break;
		case 2:
			align = NSTextAlignmentLeft;
			break;
		case 3:
			align = NSTextAlignmentRight;
			break;
		default:
			align = NSTextAlignmentCenter;
			break;
	}
	
	topfontsize = [[NSUserDefaults standardUserDefaults] floatForKey:@"RelativeFontScale"];
	bottomfontsize = [[NSUserDefaults standardUserDefaults] floatForKey:@"RelativeFontScale"];
	
	strokeWidth = -(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"StrokeWidth"];
	
	cookingFont = [[UIFont alloc] init];
	cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"] size:topfontsize];
	
	NSString *textColorName = [[NSUserDefaults standardUserDefaults] objectForKey:@"TextColor"];
	if ([textColorName isEqualToString:@"White (default)"])
		textColor = [UIColor whiteColor];
	else if ([textColorName isEqualToString:@"Black"])
		textColor = [UIColor blackColor];
	else if ([textColorName isEqualToString:@"Yellow"])
		textColor = [UIColor yellowColor];
	else if ([textColorName isEqualToString:@"Green"])
		textColor = [UIColor greenColor];
	else if ([textColorName isEqualToString:@"Cyan"])
		textColor = [UIColor cyanColor];
	else if ([textColorName isEqualToString:@"Purple"])
		textColor = [UIColor purpleColor];
	else if ([textColorName isEqualToString:@"Magenta"])
		textColor = [UIColor magentaColor];
	else if ([textColorName isEqualToString:@"Clear Color"])
		textColor = [UIColor clearColor];
	else
		textColor = [UIColor whiteColor];
	
	NSString *outlineColorName = [[NSUserDefaults standardUserDefaults] objectForKey:@"OutlineColor"];
	if ([outlineColorName isEqualToString:@"Black (default)"])
		outlineColor = [UIColor blackColor];
	else if ([outlineColorName isEqualToString:@"White"])
		outlineColor = [UIColor whiteColor];
	else if ([outlineColorName isEqualToString:@"Yellow"])
		outlineColor = [UIColor yellowColor];
	else if ([outlineColorName isEqualToString:@"Green"])
		outlineColor = [UIColor greenColor];
	else if ([outlineColorName isEqualToString:@"Brown"])
		outlineColor = [UIColor brownColor];
	else if ([outlineColorName isEqualToString:@"Purple"])
		outlineColor = [UIColor purpleColor];
	else if ([outlineColorName isEqualToString:@"Magenta"])
		outlineColor = [UIColor magentaColor];
	else if ([outlineColorName isEqualToString:@"No Outline"])
		outlineColor = [UIColor clearColor];
	else
		outlineColor = [UIColor blackColor];
	
	[self.view addGestureRecognizer:pinchImage];
	[self Cook];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ResetSettingsOnLaunch"]) {
		[[NSUserDefaults standardUserDefaults] setFloat:64.0f forKey:@"RelativeFontScale"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TextAlignment"];
		[[NSUserDefaults standardUserDefaults] setObject:@"Impact" forKey:@"FontName"];
		[[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"StrokeWidth"];
		[[NSUserDefaults standardUserDefaults] setObject:@"Black (default)" forKey:@"OutlineColor"];
		[[NSUserDefaults standardUserDefaults] setObject:@"White (default)" forKey:@"TextColor"];
	}
	
	self.view.backgroundColor = [UIColor blackColor];
	self.BlackBlurredImage.alpha = 0;	
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LibCamPickUp"]) {
		NSString *imagePath = [[NSUserDefaults standardUserDefaults] objectForKey:@"ImagePath"];
		if (imagePath)
			self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
		self.navigationItem.title = [NSString stringWithFormat:@"Custom Image"];
		self.backgroundImage.image = [self blur:self.imageView.image];
	}
	else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LoadingLastEdit"]) {
		self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedImagePath"]]];
		self.backgroundImage.image = [self blur:self.imageView.image];
		self.navigationItem.title = @"Last Edit";
		[_topField setText: [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedTopText"]];
		[_bottomField setText: [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedBottomText"]];
	}
	else {
		self.navigationItem.title = [NSString stringWithFormat:@"%@", self.meme.Name];
		self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.meme.Image]];
		self.backgroundImage.image = [self blur:self.imageView.image];
	}

	_backgroundImage.alpha = 0.0;
	[UIView animateWithDuration:1.0 animations:^{
		_backgroundImage.alpha = 1.0;
	}];
	
	imagex = self.imageView.image;
	
	UIInterpolatingMotionEffect* horinzontalMotionEffectBg = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horinzontalMotionEffectBg.minimumRelativeValue = @(20);
	horinzontalMotionEffectBg.maximumRelativeValue = @(-20);
	[self.backgroundImage addMotionEffect:horinzontalMotionEffectBg];
	
	UIInterpolatingMotionEffect* verticalMotionEffectBg = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	verticalMotionEffectBg.minimumRelativeValue = @(20);
	verticalMotionEffectBg.maximumRelativeValue = @(-20);
	[self.backgroundImage addMotionEffect:verticalMotionEffectBg];
	
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
												  forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
																	NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]};
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	[self.topOrBottomButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
											  NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]} forState:UIControlStateNormal];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
	[backButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
										 NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]} forState:UIControlStateNormal];
	[self.navigationItem setBackBarButtonItem:backButton];
	
	[_topField setDelegate:self];
	[_bottomField setDelegate:self];
	
	[_topField setFont:defaultFont];
	[_bottomField setFont:defaultFont];
	
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: _shareButton, _topOrBottomButton, nil];
	
	topTextRect = CGRectMake(_imageView.frame.origin.x + (_imageView.frame.size.width - imagex.size.width)/2,
							 _imageView.frame.origin.y + (_imageView.frame.size.height - imagex.size.height)/2,
							 imagex.size.width,
							 40);
	bottomTextRect = CGRectMake(_imageView.frame.origin.x + (_imageView.frame.size.width - imagex.size.width)/2,
								_imageView.frame.origin.y + (_imageView.frame.size.height + imagex.size.height)/2,
								imagex.size.width,
								40);
	
	tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
	
	keyboardHeight = 216.0f;
	
//	[self.view addGestureRecognizer:tapImage];
	
	[self.twoSidedArrow setAlpha:0.0];
	
	swipeFromBottom = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fontAction:)];
	[swipeFromBottom setDirection:UISwipeGestureRecognizerDirectionUp];
	[swipeFromBottom setDelegate:self];
	[self.view addGestureRecognizer:swipeFromBottom];
	
	swipeFromTop = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissChild:)];
	[swipeFromTop setDirection:UISwipeGestureRecognizerDirectionDown];
	[swipeFromTop setDelegate:self];
	[self.view addGestureRecognizer:swipeFromTop];
	
	swipeTextView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTextView:)];
	[swipeTextView setDirection:UISwipeGestureRecognizerDirectionRight];
	[self.bottomField addGestureRecognizer:swipeTextView];
	
	swipeTextView2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTextView:)];
	[swipeTextView2 setDirection:UISwipeGestureRecognizerDirectionRight];
	[self.topField addGestureRecognizer:swipeTextView2];
	
	pinchImage = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	self.topField.alpha = 0;
	self.bottomField.alpha = 0;
	self.topField.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
	self.bottomField.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
	
	[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.topField.alpha = 1;
		self.bottomField.alpha = 1;
		self.topField.layer.transform = CATransform3DIdentity;
		self.bottomField.layer.transform = CATransform3DIdentity;
	}completion:nil];
	
	
	
	panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[panGesture setMinimumNumberOfTouches:2];
	[self.view addGestureRecognizer:panGesture];
	topTextFrameOffset = CGPointZero;
	bottomTextFrameOffset = CGPointZero;
	
	moveTop = YES;
	
	/*
	bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, self.view.frame.size.height - 50)];
	
	bannerView.adUnitID = @"ca-app-pub-2382647790089267/4722597634";
	bannerView.rootViewController = self;
	
	GADRequest *request = [GADRequest request];
	request.testDevices = @[ GAD_SIMULATOR_ID, @"MY_TEST_DEVICE_ID" ];
	
	[bannerView loadRequest:request];
	
	[self.view addSubview:bannerView];
	*/
	
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
	CGPoint translation = [recognizer translationInView:self.imageView];
	if (moveTop)
		topTextFrameOffset = CGPointMake(topTextFrameOffset.x + [recognizer velocityInView:self.imageView].x/60,
								  topTextFrameOffset.y + [recognizer velocityInView:self.imageView].y/60);
	else
		bottomTextFrameOffset = CGPointMake(bottomTextFrameOffset.x + [recognizer velocityInView:self.imageView].x/60,
								  bottomTextFrameOffset.y + [recognizer velocityInView:self.imageView].y/60);
	[recognizer setTranslation:translation inView:self.imageView];
	[self Cook];
}

- (void)keyboardWasShown:(NSNotification *)notification {
	NSDictionary* d = [notification userInfo];
	CGRect rect = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	rect = [self.view convertRect:rect fromView:nil];
	
	keyboardHeight = rect.size.height;
}

-(void)swipeTextView :(UISwipeGestureRecognizer *)gesture {
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_topField text]] forKey:@"lastEditedTopText"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_bottomField text]] forKey:@"lastEditedBottomText"];
	if (gesture.view == self.topField) {
		if (self.meme.Name)
			[self.topField setText:self.meme.Name];
	}
	else if (gesture.view == self.bottomField) {
		if (self.meme.Name)
			[self.bottomField setText:self.meme.Name];
	}
	[self Cook];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Save {
	[self.view endEditing:YES];
	[self makeMemeWithTopText:[[_topField text] uppercaseString] andBottomText:[[_bottomField text] uppercaseString]];
	UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved!" message:@"The Image has successfully been saved to the Camera Roll." delegate:self cancelButtonTitle:@"Awwwww Yeah!" otherButtonTitles:nil, nil];
	[alert show];
	AudioServicesPlaySystemSound (1006);
}

#pragma mark - Cooking Methods

-(void)makeMemeWithTopText: (NSString *)topText andBottomText :(NSString *)bottomText {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LibCamPickUp"])
		[self Cook];
	else {
//		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ConnectedToInternet"]) {
//			topText = [topText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//			bottomText = [bottomText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//			_imageView.image = [[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&top=%@&bottom=%@", _meme.URL, topText, bottomText]]]];
//		}
//		else
			[self Cook];
	}
}

- (void)Cook {
	[self.view endEditing:YES];
//	_imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _meme.Image]];
//	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LibCamPickUp"]) {
//		_imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImagePath"]]];
//	}
//	else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LoadingLastEdit"]) {
//		_imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastEditedImagePath"]]];
//	}
	
	_imageView.image = imagex;
	
	_imageView.image = [self drawTextTop:[_topField.text uppercaseString]
												 inImage:_imageView.image
												 atPoint:CGPointMake(20, 0)];
	_imageView.image = [self drawTextBottom:[_bottomField.text uppercaseString]
													inImage:_imageView.image
													atPoint:CGPointMake(20, 220)];
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:_topField.text] forKey:@"lastEditTopText"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString:_bottomField.text] forKey:@"lastEditBottomText"];
}

-(UIImage*) drawTextTop:(NSString*) text inImage:(UIImage*)  image atPoint:(CGPoint)   point{
	UIGraphicsBeginImageContext(image.size);
	[image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
	
	UITextView *myText = [[UITextView alloc] init];
	
	NSShadow *shadow = [[NSShadow alloc] init];
	shadow.shadowColor = outlineColor;
	shadow.shadowBlurRadius = 1.0;
	shadow.shadowOffset = CGSizeMake(1.0, 1.0);
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = align;

	cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]	size:topfontsize];
	myText.font = cookingFont;
	myText.textColor = textColor;
	myText.textAlignment = align;
	myText.text = [NSString stringWithString:text];
	
	NSDictionary *textAttributes = @{NSForegroundColorAttributeName : textColor,
									 NSFontAttributeName: cookingFont,
									 NSShadowAttributeName: shadow,
									 NSParagraphStyleAttributeName: paragraphStyle,
									 NSStrokeWidthAttributeName: [NSNumber numberWithFloat:strokeWidth],
									 NSStrokeColorAttributeName:outlineColor};
	
	CGSize maximumLabelSize = CGSizeMake(image.size.width, image.size.height/2 - 5);
	CGRect textRect = [text boundingRectWithSize:maximumLabelSize
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:textAttributes
										 context:nil];
	
	myText.frame = CGRectMake(0, 0, image.size.width, image.size.height/2);
	topTextRect = myText.frame;
	
	while (ceilf(textRect.size.height) >= ceilf(maximumLabelSize.height)){
		topfontsize --;
		cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]	size:topfontsize];
		[myText setFont:cookingFont];
		myText.text = [NSString stringWithString:text];
		textAttributes = @{NSForegroundColorAttributeName : textColor,
						   NSFontAttributeName: cookingFont,
						   NSShadowAttributeName: shadow,
						   NSParagraphStyleAttributeName: paragraphStyle,
						   NSStrokeWidthAttributeName: [NSNumber numberWithFloat:strokeWidth],
						   NSStrokeColorAttributeName:outlineColor};
		textRect = [text boundingRectWithSize:maximumLabelSize
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:textAttributes
										 context:nil];
	}
//	if (moveTop)
		[myText.text drawInRect:CGRectMake(myText.frame.origin.x + topTextFrameOffset.x, myText.frame.origin.y + topTextFrameOffset.y, myText.frame.size.width, myText.frame.size.height) withAttributes:textAttributes];
//	else
//		[myText.text drawInRect:myText.frame withAttributes:textAttributes];
	
	UIImage *NewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return NewImage;
}

-(UIImage*) drawTextBottom:(NSString*) text inImage:(UIImage*)  image atPoint:(CGPoint)  point{
	UIGraphicsBeginImageContext(image.size);
	[image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
	
	UITextView *myText = [[UITextView alloc] init];
	
	NSShadow *shadow = [[NSShadow alloc] init];
	shadow.shadowColor = outlineColor;
	shadow.shadowBlurRadius = 1.0;
	shadow.shadowOffset = CGSizeMake(1.0, 1.0);
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = align;
	
	cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]	size:bottomfontsize];
	myText.font = cookingFont;
	myText.textColor = textColor;
	myText.textAlignment = align;
	myText.text = [NSString stringWithString:text];
	
	NSDictionary *textAttributes = @{NSForegroundColorAttributeName : textColor,
									 NSFontAttributeName: cookingFont,
									 NSShadowAttributeName: shadow,
									 NSParagraphStyleAttributeName: paragraphStyle,
									 NSStrokeWidthAttributeName: [NSNumber numberWithFloat:strokeWidth],
									 NSStrokeColorAttributeName:outlineColor};
	
	CGSize maximumLabelSize = CGSizeMake(image.size.width, image.size.height/2 - 5);
	CGRect textRect = [text boundingRectWithSize:maximumLabelSize
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:textAttributes
										 context:nil];
	
	CGSize expectedLabelSize = textRect.size;
	myText.frame = CGRectMake(0, (image.size.height) - (expectedLabelSize.height), image.size.width, image.size.height/2);
	bottomTextRect = myText.frame;
	
	while (ceilf(textRect.size.height) >= ceilf(maximumLabelSize.height)){
		bottomfontsize --;
		cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]	size:bottomfontsize];
		[myText setFont:cookingFont];
		myText.text = [NSString stringWithString:text];
		textAttributes = @{NSForegroundColorAttributeName : textColor,
						   NSFontAttributeName: cookingFont,
						   NSShadowAttributeName: shadow,
						   NSParagraphStyleAttributeName: paragraphStyle,
						   NSStrokeWidthAttributeName: [NSNumber numberWithFloat:strokeWidth],
						   NSStrokeColorAttributeName:outlineColor};
		textRect = [text boundingRectWithSize:maximumLabelSize
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:textAttributes
										 context:nil];
		CGSize expectedLabelSize = textRect.size;
		myText.frame = CGRectMake(0, (image.size.height) - (expectedLabelSize.height), image.size.width, image.size.height/2);
	}
	
//	if (moveTop)
//		[myText.text drawInRect:myText.frame withAttributes:textAttributes];
//	else
		[myText.text drawInRect:CGRectMake(myText.frame.origin.x + bottomTextFrameOffset.x, myText.frame.origin.y + bottomTextFrameOffset.y, myText.frame.size.width, myText.frame.size.height) withAttributes:textAttributes];
	
	UIImage *NewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return NewImage;
}

-(void)pinchImage :(UIPinchGestureRecognizer *)gestureRecognizer {
	CGFloat fontscale = 0.3f * gestureRecognizer.velocity;
	if (moveTop) {
		if (gestureRecognizer.scale > 1) {
			if (topfontsize < 150.0f)
				topfontsize += fontscale;
			else
				topfontsize = 150.0f;
		}
		else if (gestureRecognizer.scale < 1) {
			if (topfontsize > 20.0f)
				topfontsize += fontscale;
			else
				topfontsize = 20.0f;
		}
	}
	else {
		if (gestureRecognizer.scale > 1) {
			if (bottomfontsize < 150.0f)
				bottomfontsize += fontscale;
			else
				bottomfontsize = 150.0f;
		}
		else if (gestureRecognizer.scale < 1) {
			if (bottomfontsize > 20.0f)
				bottomfontsize += fontscale;
			else
				bottomfontsize = 20.0f;
		}
	}
	[self Cook];
}

#pragma mark - Text Field Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField == _topField) {
		[_topField resignFirstResponder];
		[_bottomField becomeFirstResponder];
	}
	else if (textField == _bottomField){
		[_bottomField resignFirstResponder];
		AudioServicesPlaySystemSound (1113);
		[self makeMemeWithTopText:[[_topField text] uppercaseString] andBottomText:[[_bottomField text] uppercaseString]];
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_topField text]] forKey:@"lastEditedTopText"];
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_bottomField text]] forKey:@"lastEditedBottomText"];
		
		[self Cook];
		
		NSData *dataOfImage = UIImageJPEGRepresentation(_imageView.image, 0.8);
		NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"MemeMaker_Edit.jpg"]];
		[dataOfImage writeToFile:imagePath atomically:YES];
	}
	return  YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
	UIImage *image2 = self.imageView.image;
	CGFloat imgheight = ((image2.size.height)/(image2.size.width))*(self.view.frame.size.width);
	if (imgheight > self.imageView.frame.size.height)
		imgheight = self.imageView.frame.size.height;
	if (textField == self.bottomField) {
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.imageView.layer.transform = CATransform3DMakeTranslation(0, 50 - (imgheight - self.imageView.frame.size.height)/2 - keyboardHeight, 0);
			_BlackBlurredImage.alpha = 0.8;
		}completion:nil];
		
	}
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.imageView.layer.transform = CATransform3DIdentity;
		_BlackBlurredImage.alpha = 0;
	}completion:nil];
}

- (IBAction)textFieldTextChanged:(id)sender {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ContinuousEditing"]) {
		_imageView.image = imagex;
		_imageView.image = [self drawTextTop:[_topField.text uppercaseString]
									 inImage:_imageView.image
									 atPoint:CGPointMake(20, 0)];
		_imageView.image = [self drawTextBottom:[_bottomField.text uppercaseString]
										inImage:_imageView.image
										atPoint:CGPointMake(20, 220)];
	}
}

- (IBAction)fontAction:(id)sender {
	if (shouldDisplayFontView) {
		fontTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FontView"];
		[fontTableVC.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 270)];
		
		[self addChildViewController:fontTableVC];
		[self.view addSubview:fontTableVC.view];
		
		
		[fontTableVC didMoveToParentViewController:self];
		
		_twoSidedArrow.layer.transform = CATransform3DMakeScale(0.0, 0.8, 0.8);
		[self.twoSidedArrow setAlpha:0.0];
		
		[UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			[fontTableVC.view setFrame:CGRectMake(5, self.view.frame.size.height - 275, self.view.frame.size.width - 10, 270)];
			fontTableVC.view.alpha = 0.5;
			_twoSidedArrow.layer.transform = CATransform3DIdentity;
			[self.twoSidedArrow setAlpha:0.5];
		}completion:nil];
		
		shouldDisplayFontView = NO;
	}
}

-(void)dismissChild :(UIGestureRecognizer *)gestureRecognizer {
	[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		[fontTableVC.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 270)];
		fontTableVC.view.alpha = 0.0;
		_twoSidedArrow.layer.transform = CATransform3DMakeScale(0.0, 0.8, 0.8);
		[self.twoSidedArrow setAlpha:0.0];
	}completion:^(BOOL finished) {
		[fontTableVC.view removeFromSuperview];
		[fontTableVC removeFromParentViewController];
		shouldDisplayFontView = YES;
	}];
}

-(void)tapImage :(UIGestureRecognizer *)gestureRecognizer {
	CGPoint point = [gestureRecognizer locationInView:self.view];
	if (CGRectContainsPoint(topTextRect, point))
		[self.topField becomeFirstResponder];
	else if (CGRectContainsPoint(bottomTextRect, point))
		[self.bottomField becomeFirstResponder];
}

#pragma mark - Sharing Action

- (IBAction)shareAction:(id)sender {
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_topField text]] forKey:@"lastEditedTopText"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_bottomField text]] forKey:@"lastEditedBottomText"];
	NSString *texttoshare = [NSString stringWithFormat:@"Hey, check this funny meme that I made!"];
	UIImage *imagetoshare = _imageView.image;
	NSArray *activityItems = @[texttoshare, imagetoshare];
	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
	[self presentViewController:activityVC animated:TRUE completion:nil];
}

- (IBAction)saveAction:(id)sender {
	[self Save];
}

#pragma mark - Other Methods

- (UIImage*) blur:(UIImage*)theImage{
	return [theImage applyDarkEffect];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[_topField resignFirstResponder];
	[_bottomField resignFirstResponder];
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.imageView.layer.transform = CATransform3DIdentity;
		_BlackBlurredImage.alpha = 0;
	}completion:nil];
}


- (IBAction)openInAction:(id)sender {
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_topField text]] forKey:@"lastEditedTopText"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [_bottomField text]] forKey:@"lastEditedBottomText"];
	NSData *dataOfImage = UIImageJPEGRepresentation(_imageView.image, 0.8);
	NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"MemeMaker_Edit.jpg"]];
	[dataOfImage writeToFile:imagePath atomically:YES];
	[self openDocumentIn];
}

-(void)openDocumentIn {
	documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[self documentsPathForFileName:[NSString stringWithFormat:@"MemeMaker_Edit.jpg"]]]];
	[documentController setDelegate:self];
	documentController.UTI = @"public.jpg";
	[documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller
	   willBeginSendingToApplication:(NSString *)application {
 
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller
		  didEndSendingToApplication:(NSString *)application {
 
}

-(void)documentInteractionControllerDidDismissOpenInMenu:
(UIDocumentInteractionController *)controller {
}

- (NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:name];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		topTextFrameOffset = CGPointZero;
		bottomTextFrameOffset = CGPointZero;
		[self Cook];
	}
}

- (IBAction)topOrBottom:(id)sender {
	if (moveTop) {
		moveTop = NO;
		_topOrBottomButton.image = [UIImage imageNamed:@"BottomEdit"];
	}
	else {
		moveTop = YES;
		_topOrBottomButton.image = [UIImage imageNamed:@"TopEdit"];
		
	}
}
@end
