//
//  ViewController.m
//  SOAP Test
//
//  Created by Yang on 12-8-29.
//  Copyright (c) 2012年 Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize phoneNumber;
@synthesize urlIn;
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;
@synthesize resut;
@synthesize putin;
@synthesize matnr;
@synthesize desc;
@synthesize werks;
@synthesize stor;
@synthesize num;

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setPhoneNumber:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
// 开始查询
- (IBAction)doQuery:(id)sender {
   NSString *number = phoneNumber.text;
    [number dataUsingEncoding:NSUTF8StringEncoding];
  NSString *ul = urlIn.text;
    matchingElement = @"T";
    // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
    if (![number isEqual: @""]) {
          matchingElement = number;
    }
    else
        matchingElement = @"T";
    NSLog(@"LOG:%@",matchingElement);
    // 创建SOAP消息，内容格式就是网站上提示的请求报文的主体实体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>\n"
                         "<n0:ZWEB003 xmlns:n0=\"urn:sap-com:document:sap:rfc:functions\">\n"
                         "<T>"
                         "<item>"
                         "<MANDT> </MANDT>"
                         "<MATNR> </MATNR>"
                         "<SPRAS> </SPRAS>"
                         "<MAKTX> </MAKTX>"
                         "<MAKTG> </MAKTG>"
                         "</item>"
                         "<item>"
                         "<MANDT> </MANDT>"
                         "<MATNR> </MATNR>"
                         "<SPRAS> </SPRAS>"
                         "<MAKTX> </MAKTX>"
                         "<MAKTG> </MAKTG>"
                         "</item>"
                         "</T>"
                         "<T1>%@</T1>"
                         "</n0:ZWEB003>\n"
                         "</soap12:Body>\n"
                         "</soap12:Envelope>",putin.text];
    
    
    
     NSLog(@"INPUT:%@",number);
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMsg);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
  /*
  NSURL *url = [NSURL URLWithString: @"http://192.168.1.102:8000/sap/bc/srt/rfc/sap/zmmweb001/800/service/binding"];
   http://lrp-erp.com.cn:8000/sap/bc/srt/rfc/sap/zweb002/800/service/binding
   
   http://lrp-erp.com.cn:8000/sap/bc/srt/rfc/sap/zmmweb01/800/service/binding
*/
    if (![ul isEqual: @""]) {
         ul = urlIn.text;
    }
    else
     ul = @"http://192.168.1.102:8000/sap/bc/srt/rfc/sap/zweb003/800/service/binding";
    
    
    
    NSURL *url = [NSURL URLWithString:ul];
    // 根据上面的URL创建一个请求

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    // 创建连接
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
        NSLog(@"conect");
    }
    else
        NSLog(@"time out");
}

#pragma mark -
#pragma mark URL Connection Data Delegate Methods

// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData setLength: 0];
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    [webData appendData:data];
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn = nil;
    webData = nil;
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
                                                length:[webData length]
                                              encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML);
    self.log.text = theXML;
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    
}

#pragma mark -
#pragma mark XML Parser Delegate Methods

// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    if ([elementName isEqualToString:matchingElement]) {
        if (!soapResults) {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
    
}

// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    if (elementFound) {
       
        [soapResults appendString: string];
        [soapResults appendString:@","];
    }
    NSString *str = [soapResults copy];
NSArray *array = [str componentsSeparatedByString:@","];
    
  NSLog(@"array:%@",array);
   
    resut.text = [NSString stringWithFormat:@"%@",soapResults];
    matnr.text = [NSString stringWithFormat:@"%@",array[0]];

//   num.text  = [NSString stringWithFormat:@"%@",array[2]];
  // werks.text = [NSString stringWithFormat:@"%@",array[3]];
 //  stor.text =  [NSString stringWithFormat:@"%@",array[4]];
     
  
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

// 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:matchingElement]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SAP返回信息"
                                                        message:[NSString stringWithFormat:@"%@",soapResults]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        elementFound = FALSE;
        // 强制放弃解析
        [xmlParser abortParsing];
    }
}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (soapResults) {
        soapResults = nil;
    }
}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (soapResults) {
        soapResults = nil;
    }
}

@end
