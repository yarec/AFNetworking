// AFNetworkActivityManagerTests.m
// Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFTestCase.h"

#import "AFURLSessionManager.h"

@interface AFURLSessionManagerTests : AFTestCase
@property (readwrite, nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation AFURLSessionManagerTests

- (void)setUp {
    [super setUp];
    self.manager = [[AFURLSessionManager alloc] init];
}

#pragma mark -

- (void)testUploadTasksProgressBecomesPartOfCurrentProgress {
    NSProgress *overallProgress = [NSProgress progressWithTotalUnitCount:100];

    [overallProgress becomeCurrentWithPendingUnitCount:80];
    NSProgress *uploadProgress = nil;

    [self.manager uploadTaskWithRequest:[NSURLRequest requestWithURL:self.baseURL]
                               fromData:[NSData data]
                                 progress:&uploadProgress
                        completionHandler:nil];
    [overallProgress resignCurrent];

    expect(overallProgress.fractionCompleted).to.equal(0);

    uploadProgress.totalUnitCount = 1;
    uploadProgress.completedUnitCount = 1;


    expect(overallProgress.fractionCompleted).to.equal(0.8);
}

- (void)testDownloadTasksProgressBecomesPartOfCurrentProgress {
    NSProgress *overallProgress = [NSProgress progressWithTotalUnitCount:100];

    [overallProgress becomeCurrentWithPendingUnitCount:80];
    NSProgress *downloadProgress = nil;

    [self.manager downloadTaskWithRequest:[NSURLRequest requestWithURL:self.baseURL]
                                 progress:&downloadProgress
                              destination:nil
                        completionHandler:nil];
    [overallProgress resignCurrent];

    expect(overallProgress.fractionCompleted).to.equal(0);

    downloadProgress.totalUnitCount = 1;
    downloadProgress.completedUnitCount = 1;


    expect(overallProgress.fractionCompleted).to.equal(0.8);
}

//- (void)testDidResumeNotificationIsReceivedByDataTaskAfterResume {
//    NSURL *delayURL = [self.baseURL URLByAppendingPathComponent:@"delay/1"];
//    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:[NSURLRequest requestWithURL:delayURL]
//                                                 completionHandler:nil];
//    [task resume];
//    [task suspend];
//    [self expectationForNotification:@"com.alamofire.networking.task.resume"
//                              object:nil
//                             handler:nil];
//    [task resume];
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    [task cancel];
//}
//
//- (void)testDidSuspendNotificationIsReceivedByDataTaskAfterSuspend {
//    [self expectationForNotification:@"com.alamofire.networking.task.suspend"
//                              object:nil
//                             handler:nil];
//    NSURL *delayURL = [self.baseURL URLByAppendingPathComponent:@"delay/1"];
//    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:[NSURLRequest requestWithURL:delayURL]
//                                                 completionHandler:nil];
//    [task resume];
//    [task suspend];
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    [task cancel];
//}
//
//- (void)testDidResumeNotificationIsReceivedByUploadTaskAfterResume {
//    NSURL *delayURL = [self.baseURL URLByAppendingPathComponent:@"delay/1"];
//    NSURLSessionUploadTask *task = [self.manager uploadTaskWithRequest:[NSURLRequest requestWithURL:delayURL]
//                                                              fromData:nil
//                                                              progress:nil
//                                                     completionHandler:nil];
//    [task resume];
//    [task suspend];
//    [self expectationForNotification:@"com.alamofire.networking.task.resume"
//                              object:nil
//                             handler:nil];
//    [task resume];
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    [task cancel];
//}
//
//- (void)testDidSuspendNotificationIsReceivedByUploadTaskAfterSuspend {
//    [self expectationForNotification:@"com.alamofire.networking.task.suspend"
//                              object:nil
//                             handler:nil];
//    NSURL *delayURL = [self.baseURL URLByAppendingPathComponent:@"delay/1"];
//    NSURLSessionUploadTask *task = [self.manager uploadTaskWithRequest:[NSURLRequest requestWithURL:delayURL]
//                                                              fromData:nil
//                                                              progress:nil
//                                                     completionHandler:nil];
//    [task resume];
//    [task suspend];
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    [task cancel];
//}
//
//- (void)testDidResumeNotificationIsReceivedByDownloadTaskAfterResume {
//    NSURL *delayURL = [self.baseURL URLByAppendingPathComponent:@"delay/1"];
//    NSURLSessionUploadTask *task = [self.manager uploadTaskWithRequest:[NSURLRequest requestWithURL:delayURL]
//                                                              fromData:nil
//                                                              progress:nil
//                                                     completionHandler:nil];
//    [task resume];
//    [task suspend];
//    [self expectationForNotification:@"com.alamofire.networking.task.resume"
//                              object:nil
//                             handler:nil];
//    [task resume];
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    [task cancel];
//}
//
//- (void)testDidSuspendNotificationIsReceivedByDownloadTaskAfterSuspend {
//    [self expectationForNotification:@"com.alamofire.networking.task.suspend"
//                              object:nil
//                             handler:nil];
//    NSURL *delayURL = [self.baseURL URLByAppendingPathComponent:@"delay/1"];
//    NSURLSessionDownloadTask *task = [self.manager downloadTaskWithRequest:[NSURLRequest requestWithURL:delayURL]
//                                                                progress:nil
//                                                             destination:nil
//                                                       completionHandler:nil];
//    [task resume];
//    [task suspend];
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    [task cancel];
//}
//
//- (void)testSwizzlingIsWorkingAsExpected {
//    [self expectationForNotification:@"com.alamofire.networking.task.suspend"
//                              object:nil
//                             handler:nil];
//    NSURL *delayURL = [self.baseURL URLByAppendingPathComponent:@"delay/1"];
//    NSURLSessionDownloadTask *task = [self.manager downloadTaskWithRequest:[NSURLRequest requestWithURL:delayURL]
//                                                                progress:nil
//                                                             destination:nil
//                                                       completionHandler:nil];
//    [task resume];
//    [task suspend];
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    [task cancel];
//    
//    
//    [self expectationForNotification:@"com.alamofire.networking.task.suspend"
//                              object:nil
//                             handler:nil];
//    
//    NSURLSessionDataTask *uploadTask = [self.manager uploadTaskWithRequest:[NSURLRequest requestWithURL:delayURL]
//                                                                  fromData:nil
//                                                                  progress:nil
//                                                         completionHandler:nil];
//    [uploadTask resume];
//    [uploadTask suspend];
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    [uploadTask cancel];
//}

@end
