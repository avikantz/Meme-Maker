//
//  FontTableViewController.m
//  Meme Maker
//
//  Created by Avikant Saini on 1/22/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "FontTableViewController.h"
#import "FontTableViewCell.h"
#import "DetailViewController.h"

@interface FontTableViewController ()

@end

@implementation FontTableViewController {
	NSMutableArray *fontBook;
	NSMutableArray *fontNames;
	
	NSMutableArray *alignmentNames;
	NSMutableArray *relativeFontSizeNames;
	
	NSMutableArray *textColorNames;
	NSMutableArray *outlineColorNames;
	NSMutableArray *strokeWidthNames;
	NSMutableArray *opacityNames;
	
	UISwipeGestureRecognizer *swipeGRight;
	UISwipeGestureRecognizer *swipeGLeft;
	
	UISwipeGestureRecognizer *swipeDown;
	UIPinchGestureRecognizer *pinch;
	
	int table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	fontBook = [[NSMutableArray alloc] initWithObjects:
				@"Impact",
				@"AppleSDGothicNeo-SemiBold",
				@"Futura-CondensedExtraBold",
				@"AvenirNext-Bold",
				@"AvenirCondensedHand",
				@"Arabella",
				@"Copperplate",
				@"GillSans-Bold",
				@"Kailasa-Bold",
				@"TrebuchetMS-Bold",
				@"HelveticaNeue-Bold",
				@"ArialHebrew-Bold",
				@"Righteous-Regular",
				@"Absender",
				@"LeagueGothic-Regular",
				@"LeagueGothic-Italic",
				@"MarkerFelt-Wide",
				@"Menlo-Bold",
				@"EtelkaNarrowTextPro",
				@"LithosPro-Black",
				@"PoplarStd",
				@"StencilStd",
				@"Darkwoman",
				@"angelina",
				@"TrashHand",
				@"JennaSue",
				@"HoneyScript-Light",
				@"Skipping_Stones",
				@"daniel",
				@"TobagoPoster",
				@"Subway-Black",
				@"RollingNoOne-ExtraBold",
				@"MarketingScript",
				@"Artbrush",
				@"Bolina",
				@"LouisaCP",
				@"Prisma",
				@"Karate",
				nil];
	
	fontNames = [[NSMutableArray alloc] initWithObjects:
				 @"Default",
				 @"Apple Gothic",
				 @"Futura",
				 @"Avenir Next",
				 @"Avenir Next - Hand",
				 @"Arabella",
				 @"Copperplate",
				 @"Gill Sans",
				 @"Kailasa",
				 @"Trebuchet MS",
				 @"Helvetica Neue",
				 @"Arial Hebrew",
				 @"Righteous",
				 @"Absender",
				 @"League Gothic",
				 @"League Gothic Italic",
				 @"Marker Felt",
				 @"Menlo",
				 @"Etelka Narrow Text",
				 @"Lithos Pro",
				 @"Poplar",
				 @"Stencil",
				 @"Darkwoman",
				 @"Angelina",
				 @"Trashand",
				 @"Jenna Sue",
				 @"Honey Script",
				 @"Skipping Stones",
				 @"Daniel",
				 @"Tobago Poster",
				 @"Subway",
				 @"Rolling No One",
				 @"Marketing Script",
				 @"Art Brush",
				 @"Bolina",
				 @"Louisa CP",
				 @"Prisma",
				 @"Karate",
				 nil];
	
	alignmentNames = [[NSMutableArray alloc] initWithObjects:
					  @"Center (Default)",
					  @"Justify",
					  @"Left",
					  @"Right", nil];
	
	relativeFontSizeNames = [[NSMutableArray alloc] initWithObjects:
							 @"Extra Small",
							 @"Small",
							 @"Medium (Default)",
							 @"Large",
							 @"Extra Large", nil];
	
	textColorNames = [[NSMutableArray alloc] initWithObjects:
					  @"White (Default)",
					  @"Black",
					  @"Yellow",
					  @"Green",
					  @"Cyan",
					  @"Purple",
					  @"Magenta",
					  @"Clear Color",
					  nil];
	
	outlineColorNames = [[NSMutableArray alloc] initWithObjects:
					  @"Black (Default)",
					  @"White",
					  @"Yellow",
					  @"Green",
					  @"Brown",
					  @"Purple",
					  @"Magenta",
					  @"No Outline",
					  nil];
	
	strokeWidthNames = [[NSMutableArray alloc] initWithObjects:
						@"4pt (default)",
						@"3pt",
						@"2pt",
						@"1pt",
						@"0pt",
						@"5pt",
						@"6pt",
						@"7pt", nil];
	
	
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
	self.navigationController.view.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:51/255.0 green:104.0/265 blue:0 alpha:1], NSFontAttributeName : [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f]};
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:104.0/265 blue:0 alpha:1];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	self.fontsTableView = [[UITableView alloc] initWithFrame:self.view.frame];
	self.alignmentTableView = [[UITableView alloc] initWithFrame:self.view.frame];
	self.relativeFontSizeTableView = [[UITableView alloc] initWithFrame:self.view.frame];
	
	self.fontsTableView.delegate = self;
	self.alignmentTableView.delegate = self;
	self.relativeFontSizeTableView.delegate = self;
	self.textColorTableView.delegate = self;
	self.outlineColorTableView.delegate = self;
	self.strokeWidthTableView.delegate = self;
	
	self.fontsTableView.dataSource = self;
	
	table = 1;
	[self.tableView reloadData];
	
	swipeGRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
	swipeGLeft  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
	
	[swipeGRight setDirection:UISwipeGestureRecognizerDirectionRight];
	[swipeGLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
	
	[self.view addGestureRecognizer:swipeGRight];
	[self.view addGestureRecognizer:swipeGLeft];
	
	UIInterpolatingMotionEffect* horinzontalMotionEffectBg = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horinzontalMotionEffectBg.minimumRelativeValue = @(10);
	horinzontalMotionEffectBg.maximumRelativeValue = @(-10);
	
	UIInterpolatingMotionEffect* verticalMotionEffectBg = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	verticalMotionEffectBg.minimumRelativeValue = @(10);
	verticalMotionEffectBg.maximumRelativeValue = @(-10);
	
	[self.view.layer setCornerRadius:5.0];
	[self.view addMotionEffect:horinzontalMotionEffectBg];
	[self.view addMotionEffect:verticalMotionEffectBg];
	
	pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAll:)];
	
	swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAll:)];
	[swipeDown setNumberOfTouchesRequired:2];
	[swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
	
	[self.view addGestureRecognizer:pinch];
//	[self.view addGestureRecognizer:swipeDown];
	
}

- (void)dismissAll:(UIGestureRecognizer *)recognizer {
	[self.parentViewController performSelector:@selector(viewDidAppear:)];
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, self.view.frame.size.height);
	}completion:^(BOOL finished) {
		[self.view removeFromSuperview];
	}];
 
}

//-(void)viewWillDisappear:(BOOL)animated {
//	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//		self.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, self.view.frame.size.height);
//	}completion:^(BOOL finished) {
//		[self.view removeFromSuperview];
//	}];
//}

-(void) swipeRight {
	if (table == 6) {
		table = 5;
		self.strokeWidthTableView.dataSource = self;
	}
	else if (table == 5) {
		table = 4;
		self.outlineColorTableView.dataSource = self;
	}
	else if (table == 4) {
		table = 3;
		self.textColorTableView.dataSource = self;
	}
	else if (table == 3) {
		table = 2;
		self.alignmentTableView.dataSource = self;
	}
	else if (table == 2) {
		table = 1;
		self.fontsTableView.dataSource = self;
	}
	else if (table == 1) {
		table = 6;
		self.relativeFontSizeTableView.dataSource = self;
	}
	else {
		table = 1;
		self.fontsTableView.dataSource = self;
	}
	[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		[self.view setTransform:CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0)];
	}completion:^(BOOL finished) {
		[self.view setTransform:CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0)];
		[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			[self.view setTransform:CGAffineTransformIdentity];
		}completion:nil];
	}];
	[self.tableView reloadData];
}
	 
 -(void) swipeLeft {
	 if (table == 1) {
		 table = 2;
		 self.alignmentTableView.dataSource = self;
	 }
	 else if (table == 2) {
		 table = 3;
		 self.textColorTableView.dataSource = self;
	 }
	 else if (table == 3) {
		 table = 4;
		 self.outlineColorTableView.dataSource = self;
	 }
	 else if (table == 4) {
		 table = 5;
		 self.strokeWidthTableView.dataSource = self;
	 }
	 else if (table == 5) {
		 table = 6;
		 self.relativeFontSizeTableView.dataSource = self;
	 }
	 else if (table == 6) {
		 table = 1;
		 self.fontsTableView.dataSource = self;
	 }
	 else {
		 table = 1;
		 self.fontsTableView.dataSource = self;
	 }
	 [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		 [self.view setTransform:CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0)];
	 }completion:^(BOOL finished) {
		 [self.view setTransform:CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0)];
		 [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			 [self.view setTransform:CGAffineTransformIdentity];
		 }completion:nil];
	 }];

	 [self.tableView reloadData];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (table == 1)
		return [fontBook count];
	else if (table == 2)
		return [alignmentNames count];
	else if (table == 3)
		return [textColorNames count];
	else if (table == 4)
		return [outlineColorNames count];
	else if (table == 5)
		return [strokeWidthNames count];
	else if (table == 6)
		return [relativeFontSizeNames count];
	return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FontTableViewCell *cell = (FontTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"FontCellID"];
	if(cell == nil)
		cell = [[FontTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FontCellID"];
	
	cell.tickMark.alpha = 0;
	
	if (table == 1) {
		cell.fontLabel.text = [fontNames objectAtIndex:indexPath.row];
		cell.fontLabel.textColor = [UIColor blackColor];
		UIFont *font = [[UIFont alloc] init];
		font = [UIFont fontWithName:[fontBook objectAtIndex:indexPath.row] size:25.0f];
		cell.fontLabel.font = font;
		if ([[fontBook objectAtIndex:indexPath.row] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]])
			cell.tickMark.alpha = 1;
	}
	
	else if (table == 2) {
		cell.fontLabel.text = [alignmentNames objectAtIndex:indexPath.row];
		UIFont *font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:25.0f];
		cell.fontLabel.font = font;
		cell.fontLabel.textColor = [UIColor blackColor];
		NSString *TextAlignmentName;
		switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"TextAlignment"]){
			case 0: TextAlignmentName = @"Center (Default)";
				break;
			case 1: TextAlignmentName = @"Justify";
				break;
			case 2: TextAlignmentName = @"Left";
				break;
			case 3: TextAlignmentName = @"Right";
				break;
			default:TextAlignmentName = @"Center (Default)";
				break;
		}
		if ([[alignmentNames objectAtIndex:indexPath.row] isEqualToString:TextAlignmentName])
			cell.tickMark.alpha = 1;
	}
	
	else if (table == 3) {
		cell.fontLabel.text = [textColorNames objectAtIndex:indexPath.row];
		UIFont *font = [UIFont fontWithName:@"Impact" size:25.0f];
		cell.fontLabel.font = font;
		NSString *textColorName = [textColorNames objectAtIndex:indexPath.row];
		if ([textColorName isEqualToString:@"White (default)"])
			cell.fontLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
		else if ([textColorName isEqualToString:@"Black"])
			cell.fontLabel.textColor = [UIColor blackColor];
		else if ([textColorName isEqualToString:@"Yellow"])
			cell.fontLabel.textColor = [UIColor yellowColor];
		else if ([textColorName isEqualToString:@"Green"])
			cell.fontLabel.textColor = [UIColor greenColor];
		else if ([textColorName isEqualToString:@"Cyan"])
			cell.fontLabel.textColor = [UIColor cyanColor];
		else if ([textColorName isEqualToString:@"Purple"])
			cell.fontLabel.textColor = [UIColor purpleColor];
		else if ([textColorName isEqualToString:@"Magenta"])
			cell.fontLabel.textColor = [UIColor magentaColor];
		else
			cell.fontLabel.textColor = [UIColor blackColor];
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"TextColor"] isEqualToString:textColorName])
			cell.tickMark.alpha = 1;
	}
	
	else if (table == 4) {
		cell.fontLabel.text = [outlineColorNames objectAtIndex:indexPath.row];
		UIFont *font = [UIFont fontWithName:@"Impact" size:25.0f];
		cell.fontLabel.font = font;
		NSString *textColorName = [outlineColorNames objectAtIndex:indexPath.row];
		if ([textColorName isEqualToString:@"Black (default)"])
			cell.fontLabel.textColor = [UIColor blackColor];
		else if ([textColorName isEqualToString:@"White"])
			cell.fontLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
		else if ([textColorName isEqualToString:@"Yellow"])
			cell.fontLabel.textColor = [UIColor yellowColor];
		else if ([textColorName isEqualToString:@"Green"])
			cell.fontLabel.textColor = [UIColor greenColor];
		else if ([textColorName isEqualToString:@"Brown"])
			cell.fontLabel.textColor = [UIColor brownColor];
		else if ([textColorName isEqualToString:@"Purple"])
			cell.fontLabel.textColor = [UIColor purpleColor];
		else if ([textColorName isEqualToString:@"Magenta"])
			cell.fontLabel.textColor = [UIColor magentaColor];
		else
			cell.fontLabel.textColor = [UIColor blackColor];
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"OutlineColor"] isEqualToString:textColorName])
			cell.tickMark.alpha = 1;
	}

	else if (table == 5) {
		cell.fontLabel.text = [strokeWidthNames objectAtIndex:indexPath.row];
		UIFont *font = [UIFont fontWithName:@"Impact" size:25.0f];
		cell.fontLabel.font = font;
		cell.fontLabel.textColor = [UIColor blackColor];
		NSString *strokeWidthName;
		int outlineSize = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"StrokeWidth"];
		switch (outlineSize) {
			case 4: strokeWidthName = @"4pt (default)";
				break;
			case 3: strokeWidthName = @"3pt";
				break;
			case 2: strokeWidthName = @"2pt";
				break;
			case 1: strokeWidthName = @"1pt";
				break;
			case 0: strokeWidthName = @"0pt";
				break;
			case 5: strokeWidthName = @"5pt";
				break;
			case 6: strokeWidthName = @"6pt";
				break;
			case 7: strokeWidthName = @"7pt";
				break;
			default: strokeWidthName = @"4pt (default)";
				break;
		}
		if ([[strokeWidthNames objectAtIndex:indexPath.row] isEqualToString:strokeWidthName])
			cell.tickMark.alpha = 1;
	}
	
	else if (table == 6) {
		cell.fontLabel.text = [relativeFontSizeNames objectAtIndex:indexPath.row];
		UIFont *font = [[UIFont alloc] init];
		switch (indexPath.row) {
			case 0:
				font = [UIFont fontWithName:@"Impact" size:15.0f];
				break;
			case 1:
				font = [UIFont fontWithName:@"Impact" size:20.0f];
				break;
			case 2:
				font = [UIFont fontWithName:@"Impact" size:25.0f];
				break;
			case 3:
				font = [UIFont fontWithName:@"Impact" size:32.0f];
				break;
			case 4:
				font = [UIFont fontWithName:@"Impact" size:40.0f];
				break;
			default:
				font = [UIFont fontWithName:@"Impact" size:25.0f];
				break;
		}
		cell.fontLabel.font = font;
		cell.fontLabel.textColor = [UIColor blackColor];
		float textsize = [[NSUserDefaults standardUserDefaults] floatForKey:@"RelativeFontScale"];
		NSString *RelativeFontScaleName;
		if (textsize == 36.0f)
			RelativeFontScaleName = @"Extra Small";
		else if (textsize == 48.0f)
			RelativeFontScaleName = @"Small";
		else if (textsize == 64.0f)
			RelativeFontScaleName = @"Medium (Default)";
		else if (textsize == 80.0f)
			RelativeFontScaleName = @"Large";
		else if (textsize == 96.0f)
			RelativeFontScaleName = @"Extra Large";
		else
			RelativeFontScaleName = @"Medium";
		if ([[relativeFontSizeNames objectAtIndex:indexPath.row] isEqualToString:RelativeFontScaleName])
			cell.tickMark.alpha = 1;
	}
	
	else {
		cell.fontLabel.text = [fontNames objectAtIndex:indexPath.row];
		UIFont *font = [[UIFont alloc] init];
		font = [UIFont fontWithName:[fontBook objectAtIndex:indexPath.row] size:25.0f];
		cell.fontLabel.font = font;
		if ([[fontBook objectAtIndex:indexPath.row] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"FontName"]])
			cell.tickMark.alpha = 1;
	}
	
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (table == 1) {
		[[NSUserDefaults standardUserDefaults] setObject:[fontBook objectAtIndex:indexPath.row] forKey:@"FontName"];
		if ([[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Avenir Next - Hand"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Etelka Narrow Text"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Darkwoman"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Angelina"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Trashand"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Jenna Sue"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Honey Script"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Skipping Stones"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Marketing Script"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Arabella"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Daniel"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Marketing Script"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Bolina"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Louisa CP"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Prisma"])
			[[NSUserDefaults standardUserDefaults] setObject:@"No Outline" forKey:@"OutlineColor"];
		
		if ([[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Avenir Next"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Futura"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Kaliasa"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Helvectica Neue"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Poplar"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Rolling No One"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Art Brush"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Tobago Poster"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Subway"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Gill Sans"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Marker Felt"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Lithos Pro"] ||
			[[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Karate"])
			[[NSUserDefaults standardUserDefaults] setObject:@"Black (Default)" forKey:@"OutlineColor"];
		
		if ([[fontNames objectAtIndex:indexPath.row] isEqualToString:@"Default"]) {
			[[NSUserDefaults standardUserDefaults] setFloat:64.0f forKey:@"RelativeFontScale"];
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TextAlignment"];
			[[NSUserDefaults standardUserDefaults] setObject:@"Impact" forKey:@"FontName"];
			[[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"StrokeWidth"];
			[[NSUserDefaults standardUserDefaults] setObject:@"Black (default)" forKey:@"OutlineColor"];
			[[NSUserDefaults standardUserDefaults] setObject:@"White (default)" forKey:@"TextColor"];
		}
	}
	
	else if (table == 2) {
		NSString *title = [alignmentNames objectAtIndex:indexPath.row];
		if ([title isEqualToString:@"Center (Default)"])
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TextAlignment"];
		else if ([title isEqualToString:@"Justify"])
			[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"TextAlignment"];
		else if ([title isEqualToString:@"Left"])
			[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"TextAlignment"];
		else if ([title isEqualToString:@"Right"])
			[[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"TextAlignment"];
		else
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TextAlignment"];
	}
	
	else if (table == 3) {
		[[NSUserDefaults standardUserDefaults] setObject:[textColorNames objectAtIndex:indexPath.row] forKey:@"TextColor"];
	}
	
	else if (table == 4) {
		[[NSUserDefaults standardUserDefaults] setObject:[outlineColorNames objectAtIndex:indexPath.row] forKey:@"OutlineColor"];
	}
	
	else if (table == 5) {
		NSString *title = [strokeWidthNames objectAtIndex:indexPath.row];
		if ([title isEqualToString:@"4pt (default)"])
			[[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"StrokeWidth"];
		else if ([title isEqualToString:@"3pt"])
			[[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"StrokeWidth"];
		else if ([title isEqualToString:@"2pt"])
			[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"StrokeWidth"];
		else if ([title isEqualToString:@"1pt"])
			[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"StrokeWidth"];
		else if ([title isEqualToString:@"0pt"])
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"StrokeWidth"];
		else if ([title isEqualToString:@"5pt"])
			[[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"StrokeWidth"];
		else if ([title isEqualToString:@"6pt"])
			[[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"StrokeWidth"];
		else if ([title isEqualToString:@"7pt"])
			[[NSUserDefaults standardUserDefaults] setInteger:7 forKey:@"StrokeWidth"];
		else
			[[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"StrokeWidth"];
	}
	
	else if (table == 6) {
		NSString *title= [relativeFontSizeNames objectAtIndex:indexPath.row];
		if ([title isEqualToString:@"Extra Large"])
			[[NSUserDefaults standardUserDefaults] setFloat:96.0f forKey:@"RelativeFontScale"];
		else if ([title isEqualToString:@"Large"])
			[[NSUserDefaults standardUserDefaults] setFloat:80.0f forKey:@"RelativeFontScale"];
		else if ([title isEqualToString:@"Medium (Default)"])
			[[NSUserDefaults standardUserDefaults] setFloat:64.0f forKey:@"RelativeFontScale"];
		else if ([title isEqualToString:@"Small"])
			[[NSUserDefaults standardUserDefaults] setFloat:48.0f forKey:@"RelativeFontScale"];
		else if ([title isEqualToString:@"Extra Small"])
			[[NSUserDefaults standardUserDefaults] setFloat:36.0f forKey:@"RelativeFontScale"];
	}
	
	else {
		[[NSUserDefaults standardUserDefaults] setObject:[fontBook objectAtIndex:indexPath.row] forKey:@"FontName"];
	}
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoDismiss"]) {
		[self.parentViewController performSelector:@selector(viewDidAppear:)];
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, self.view.frame.size.height);
		}completion:^(BOOL finished) {
			[self.view removeFromSuperview];
		}];
	}
	else
		[self.parentViewController performSelector:@selector(viewDidAppear:)];
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	} completion:^(BOOL finished) {
		[self.tableView reloadData];
	}];
//	[self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//	cell.alpha = 0.4;
//	cell.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.3);
//	[UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//		cell.alpha = 1;
//		cell.layer.transform = CATransform3DIdentity;
//	}completion:nil];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *header = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 30)];
	header.backgroundColor = [UIColor whiteColor];
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 20)];
	lbl.backgroundColor = [UIColor whiteColor];
	switch (table) {
		case 1:
			lbl.text = [NSString stringWithFormat:@"FONTS"];
			break;
		case 2:
			lbl.text = [NSString stringWithFormat:@"TEXT ALIGNMENT"];
			break;
		case 3:
			lbl.text = [NSString stringWithFormat:@"TEXT COLOR"];
			break;
		case 4:
			lbl.text = [NSString stringWithFormat:@"OUTLINE COLOR"];
			break;
		case 5:
			lbl.text = [NSString stringWithFormat:@"OUTLINE THICKNESS"];
			break;
		case 6:
			lbl.text = [NSString stringWithFormat:@"RELATIVE FONT SIZE"];
			break;
		default:
			break;
	}
	lbl.alpha = 1;
	[lbl setTextAlignment:NSTextAlignmentCenter];
	[lbl setFont: [UIFont fontWithName:@"Impact" size:15.0f]];
	[lbl setTextColor:[UIColor blackColor]];
	[header addSubview:lbl];
	[self tableView:tableView titleForHeaderInSection:section];
	return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
