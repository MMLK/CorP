//
//  WriterViewController.m
//  Bbs
//
//  Created by Hyeonu on 10. 5. 11..
//  Copyright 2010 CORDIAL. All rights reserved.c
//

#import "WriterMViewController.h"
#import "WriterViewController.h"
#import "BbsDetailViewController.h"
#import "TreeNode.h"
#import "XMLParser.h"
#import "eGateMobileIF.h"

@implementation WriterMViewController

@synthesize subjectField;
@synthesize textView;
@synthesize Bbs_string;
@synthesize parent_string;
@synthesize DocID;
@synthesize m_title;
@synthesize root,treeselected, returnData;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void)setupTextView
{
	self.textView = [[[UITextView alloc] initWithFrame:CGRectMake(0.0, 43.0, 320.0, 196.0)] autorelease];
	self.textView.textColor = [UIColor blackColor];
	self.textView.font = [UIFont fontWithName:@"AppleMyungjo" size:20];
	self.textView.delegate = self;
	self.textView.backgroundColor = [UIColor whiteColor];
//	self.textView.text = @"", DocID;
//	NSLog(@"Bbs_string = %@",DocID);
	self.textView.returnKeyType = UIReturnKeyDefault;
	self.textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	self.textView.scrollEnabled = YES;
	
	// this will cause automatic vertical resize when the table is resized
	self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	// note: for UITextView, if you don't like autocompletion while typing use:
	// myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
	[self.textView becomeFirstResponder];
	[self.view addSubview: self.textView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self setupTextView];

	self.root = [[XMLParser sharedInstance] parseXMLFromData:self.returnData];
	
	TreeNode *child = [[self.root children] objectAtIndex:1];
	
	self.subjectField.text = self.m_title;

	self.textView.text = [[[child children] objectAtIndex:7] leafvalue];
	
    [super viewDidLoad];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
									initWithTitle:@"등록"
									style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];


}


-(void)save {
	
	eGMIF = [eGateMobileIF sharedInstance];
	
	eGMIF.app = @"BBS";
	
	eGMIF.xmlArg1 = Bbs_string;				// BBS ID
	eGMIF.xmlArg2 = @"";						// Parent ID
	eGMIF.xmlArg3 = DocID;						// Doc ID
	eGMIF.xmlArg4 = subjectField.text;	// Subject
	eGMIF.xmlArg5 = @"";						// 게시유형 넣기
	eGMIF.xmlArg6 = @"";						// 게시종료일 -  Null 일때 서버 디폴트값 
	eGMIF.xmlArg7 = self.textView.text ; // 내용
		
	[eGMIF doGenRequestXML:@"BBS0005"];
	
	[self.navigationController popViewControllerAnimated:YES];
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
