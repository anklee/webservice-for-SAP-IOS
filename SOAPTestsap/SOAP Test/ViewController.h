//
//  ViewController.h
//  SOAP Test
//
//  Created by anklee on 13.9.8.
//  Copyright (c) 2013年 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "item.h"
#import "sqlite3.h"
@interface ViewController : UIViewController <NSXMLParserDelegate, NSURLConnectionDelegate> 
{
    item *t;
    sqlite3 *database;
}
@property (nonatomic,retain) item *t;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextView *log;
@property (weak, nonatomic) IBOutlet UITextView *resut;
@property (weak, nonatomic) IBOutlet UITextView *sqlresut;
@property (weak, nonatomic) IBOutlet UITextField *putin;
@property (weak, nonatomic) IBOutlet UITextField *urlIn;

@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

- (IBAction)doQuery:(id)sender;
- (IBAction)free:(id)sender;
- (IBAction)opendatabase:(id)sender;
@end
