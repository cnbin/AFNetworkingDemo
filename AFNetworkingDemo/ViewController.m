//
//  ViewController.m
//  AFNetworkingDemo
//
//  Created by Apple on 8/15/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 上传图片
-(void)Upload{
    
    UIImage * image = [UIImage imageNamed:@"iphone.png"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@", str];
    NSDictionary *parameters = @{@"filename":fileName};
    
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://192.168.40.10/IOSUPLOAD/WebForm1.aspx" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"img" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark 下载图片
-(void)Download{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://192.168.40.10/FileDownload/WebForm1.aspx"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
