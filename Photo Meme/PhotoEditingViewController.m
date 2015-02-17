//
//  PhotoEditingViewController.m
//  Photo Meme
//
//  Created by Avikant Saini on 1/25/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "PhotoEditingViewController.h"
#import "FontTableViewController.h"
#import "UIImage+ImageEffects.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface PhotoEditingViewController () <PHContentEditingController>
@property (strong) PHContentEditingInput *input;
@end

@implementation PhotoEditingViewController {
	UITextView *topTextView, *bottomTextView;
	UIFont *defaultFont;
	
	NSData *dataOfLastEditedImage;
	NSString *imagePathOfLastEditedImage;
	
	UIImage *imagex;
	UIImage *fullSizeImage;
	
	FontTableViewController *fontTableVC;
	
	BOOL shouldDisplayFontView;
	
	float keyboardHeight;
	
	CGRect topTextRect;
	CGRect bottomTextRect;
	
	UITapGestureRecognizer *tapImage;
	UISwipeGestureRecognizer *swipeFromBottom;
	UISwipeGestureRecognizer *swipeFromTop;
	
	UIPinchGestureRecognizer *pinchImage;
	
	UIPanGestureRecognizer *panGesture;
	
	int textAlignment;
	NSTextAlignment align;
	
	float fontsize;
	
	float strokeWidth;
	
	UIFont *cookingFont;
	
	UIColor *textColor;
	UIColor *outlineColor;
	
	CGPoint topTextFrameOffset;
	CGPoint bottomTextFrameOffset;
	
	BOOL moveTop;
}

-(void)viewDidAppear:(BOOL)animated {
	defaultFont = [[UIFont alloc] init];
	defaultFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"] size:18.0f];
	[_topField setFont:defaultFont];
	[_bottomField setFont:defaultFont];
	
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
	
	fontsize = 1.5*[[NSUserDefaults standardUserDefaults] floatForKey:@"RelativeFontScale"];
	
	strokeWidth = -(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"StrokeWidth"];
	
	cookingFont = [[UIFont alloc] init];
	cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"] size:fontsize];
	
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
	else if ([outlineColorName isEqualToString:@"Cyan"])
		outlineColor = [UIColor cyanColor];
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
	
	self.BlackBlurredImage.alpha = 0;
	[[NSUserDefaults standardUserDefaults] setFloat:64.0f forKey:@"RelativeFontScale"];
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TextAlignment"];
	[[NSUserDefaults standardUserDefaults] setObject:@"Impact" forKey:@"FontName"];
	[[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"StrokeWidth"];
	[[NSUserDefaults standardUserDefaults] setObject:@"Black (default)" forKey:@"OutlineColor"];
	[[NSUserDefaults standardUserDefaults] setObject:@"White (default)" forKey:@"TextColor"];
	
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
												  forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
																	NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]};
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

	
	_imageView.image = imagex;
	_backgroundImage.image = [self blur:_imageView.image];
	
	UIInterpolatingMotionEffect* horinzontalMotionEffectBg = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horinzontalMotionEffectBg.minimumRelativeValue = @(20);
	horinzontalMotionEffectBg.maximumRelativeValue = @(-20);
	[self.backgroundImage addMotionEffect:horinzontalMotionEffectBg];
	
	UIInterpolatingMotionEffect* verticalMotionEffectBg = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	verticalMotionEffectBg.minimumRelativeValue = @(20);
	verticalMotionEffectBg.maximumRelativeValue = @(-20);
	[self.backgroundImage addMotionEffect:verticalMotionEffectBg];
	
	[_topField setDelegate:self];
	[_bottomField setDelegate:self];
	
	[_topField setFont:defaultFont];
	[_bottomField setFont:defaultFont];
	
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
	
	pinchImage = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	
	panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[panGesture setMinimumNumberOfTouches:2];
	[self.view addGestureRecognizer:panGesture];
	topTextFrameOffset = CGPointZero;
	bottomTextFrameOffset = CGPointZero;
	
	moveTop = YES;

	
    // Do any additional setup after loading the view.
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

-(void)makeMemeWithTopText: (NSString *)topText andBottomText :(NSString *)bottomText {
	[self Cook];
}

- (void)Cook {
	[self.view endEditing:YES];
	_imageView.image = imagex;
	_imageView.image = [self drawTextTop:[_topField.text uppercaseString]
								 inImage:_imageView.image
								 atPoint:CGPointMake(20, 0)];
	_imageView.image = [self drawTextBottom:[_bottomField.text uppercaseString]
									inImage:_imageView.image
									atPoint:CGPointMake(20, 220)];
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
	
	cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]	size:fontsize];
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
		fontsize --;
		cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]	size:fontsize];
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
	
	[myText.text drawInRect:CGRectMake(myText.frame.origin.x + topTextFrameOffset.x, myText.frame.origin.y + topTextFrameOffset.y, myText.frame.size.width, myText.frame.size.height) withAttributes:textAttributes];
	
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
	
	cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]	size:fontsize];
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
		fontsize --;
		cookingFont = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]	size:fontsize];
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
	
	[myText.text drawInRect:CGRectMake(myText.frame.origin.x + bottomTextFrameOffset.x, myText.frame.origin.y + bottomTextFrameOffset.y, myText.frame.size.width, myText.frame.size.height) withAttributes:textAttributes];
	
	UIImage *NewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return NewImage;
}

-(void)pinchImage :(UIPinchGestureRecognizer *)gestureRecognizer {
	CGFloat fontscale = 0.3f * gestureRecognizer.velocity;
	if (gestureRecognizer.scale > 1) {
		if (fontsize < 150.0f)
			fontsize += fontscale;
		else
			fontsize = 150.0f;
	}
	else if (gestureRecognizer.scale < 1) {
		if (fontsize > 20.0f)
			fontsize += fontscale;
		else
			fontsize = 20.0f;
	}
	[self Cook];
}

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
	}
	return  YES;
}	

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	_imageView.image = imagex;
	_imageView.image = [self drawTextTop:[_topField.text uppercaseString]
								 inImage:_imageView.image
								 atPoint:CGPointMake(20, 0)];
	_imageView.image = [self drawTextBottom:[_bottomField.text uppercaseString]
									inImage:_imageView.image
									atPoint:CGPointMake(20, 220)];
}

- (IBAction)fontAction:(id)sender {
	if (shouldDisplayFontView) {
		fontTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FontView"];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			[fontTableVC.view setFrame:CGRectMake(100, self.view.frame.size.height, self.view.frame.size.width - 200, 390)];
		else
			[fontTableVC.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 270)];
		
		[self addChildViewController:fontTableVC];
		[self.view addSubview:fontTableVC.view];
		
		[fontTableVC.view.superview setAutoresizesSubviews:YES];
		
		[fontTableVC didMoveToParentViewController:self];
		
		_twoSidedArrow.layer.transform = CATransform3DMakeScale(0.0, 0.8, 0.8);
		[self.twoSidedArrow setAlpha:0.0];
		
		[UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				[fontTableVC.view setFrame:CGRectMake(100, self.view.frame.size.height - 400, self.view.frame.size.width - 200, 390)];
			else {
				[fontTableVC.view setFrame:CGRectMake(5, self.view.frame.size.height - 275, self.view.frame.size.width - 10, 270)];
				[self.twoSidedArrow setAlpha:0.5];
				_twoSidedArrow.layer.transform = CATransform3DIdentity;
			}
			fontTableVC.view.alpha = 0.5;
		}completion:nil];
		
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
				[fontTableVC.view setFrame:CGRectMake(100, self.view.frame.size.height - 400, self.view.frame.size.width - 200, 390)];
			else
				[fontTableVC.view setFrame:CGRectMake(5, self.view.frame.size.height - 275, self.view.frame.size.width - 10, 270)];
			NSLog(@"Rotated");
			[fontTableVC.tableView reloadData];
			
		}];
		
		shouldDisplayFontView = NO;
	}
}

-(void)dismissChild :(UIGestureRecognizer *)gestureRecognizer {
	[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			[fontTableVC.view setFrame:CGRectMake(100, self.view.frame.size.height, self.view.frame.size.width - 200, 390)];
		else
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

- (UIImage*) blur:(UIImage*)theImage{
	return [theImage applyDarkEffect];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		topTextFrameOffset = CGPointZero;
		bottomTextFrameOffset = CGPointZero;
		[self Cook];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[_topField resignFirstResponder];
	[_bottomField resignFirstResponder];
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.imageView.layer.transform = CATransform3DIdentity;
		_BlackBlurredImage.alpha = 0;
	}completion:nil];
}

- (IBAction)topOrBottom:(id)sender {
	if (moveTop) {
		moveTop = NO;
		[_topOrBottomButton setImage:[UIImage imageNamed:@"BottomEdit.png"] forState:UIControlStateNormal];
	}
	else {
		moveTop = YES;
		[_topOrBottomButton setImage:[UIImage imageNamed:@"TopEdit.png"] forState:UIControlStateNormal];
		
	}
}

#pragma mark - PHContentEditingController

- (BOOL)canHandleAdjustmentData:(PHAdjustmentData *)adjustmentData {
    // Inspect the adjustmentData to determine whether your extension can work with past edits.
    // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
    return NO;
}

- (void)startContentEditingWithInput:(PHContentEditingInput *)contentEditingInput placeholderImage:(UIImage *)placeholderImage {
    // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
    // If you returned YES from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
    // If you returned NO, the contentEditingInput has past edits "baked in".
	imagex = placeholderImage;
	fullSizeImage = placeholderImage;
	self.input = contentEditingInput;
	[self viewDidLoad];
}

- (void)finishContentEditingWithCompletionHandler:(void (^)(PHContentEditingOutput *))completionHandler {
    // Update UI to reflect that editing has finished and output is being rendered.
	
	if (imagex == nil) {
		[self cancelContentEditing];
	}
	
	[self Cook];
	imagex = [self drawTextTop:[_topField.text uppercaseString]
								 inImage:imagex
								 atPoint:CGPointMake(20, 0)];
	imagex = [self drawTextBottom:[_bottomField.text uppercaseString]
									inImage:imagex
									atPoint:CGPointMake(20, 220)];
    
    // Render and provide output on a background queue.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create editing output from the editing input.
        PHContentEditingOutput *output = [[PHContentEditingOutput alloc] initWithContentEditingInput:self.input];
		
		NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(@"Meme")];
		NSString *indetifier = @"com.avikantz.Meme-Maker.Photo-Meme";
        // Provide new adjustments and render output to given location.
		output.adjustmentData = [[PHAdjustmentData alloc] initWithFormatIdentifier:indetifier formatVersion:@"1.1" data:archivedData];
		
         NSData *renderedJPEGData = UIImageJPEGRepresentation(imagex, 1.0);
         [renderedJPEGData writeToURL:output.renderedContentURL atomically:YES];
		
        // Call completion handler to commit edit to Photos.
        completionHandler(output);
        
        // Clean up temporary files, etc.
    });
}

- (BOOL)shouldShowCancelConfirmation {
    // Returns whether a confirmation to discard changes should be shown to the user on cancel.
    // (Typically, you should return YES if there are any unsaved changes.)
    return NO;
}

- (void)cancelContentEditing {
    // Clean up temporary files, etc.
    // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
}

@end
