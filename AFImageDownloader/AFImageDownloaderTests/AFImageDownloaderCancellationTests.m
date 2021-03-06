//
//  AFImageDownloaderSCancellationTests.m
//  AFImageDownloader
//
//  Created by Ash Furrow on 2013-01-14.
//  Copyright 2013 Ash Furrow. All rights reserved.
//

#import "Kiwi.h"

#import "AFImageDownloader.h"

@interface AFImageDownloader (UnitTestAdditions)

-(void)setState:(AFImageDownloaderState)state;
-(void)setConnection:(NSURLConnection *)connection;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *mutableData;

@end

SPEC_BEGIN(AFImageDownloaderCancellationTests)

describe(@"Image downloader", ^{
    NSString *urlString = @"http://example.com/image.jpeg";
    __block AFImageDownloader *imageDownloader;
    
    context(@"has been newly created", ^{
        beforeEach(^{
            imageDownloader = [[AFImageDownloader alloc] initWithURLString:urlString autoStart:NO completion:nil];
        });
        
        it (@"should call cancel on its URL Connection", ^{
            NSURLConnection *urlConnectionMock = [NSURLConnection mock];
            [[urlConnectionMock should] receive:@selector(cancel)];
            [imageDownloader setConnection:urlConnectionMock];
            
            [imageDownloader cancel];
            
            [[theValue(imageDownloader.state) should] equal:@(AFImageDownloaderStateCompleted)];
        });
        
        it (@"should set its state to completed when cancelled", ^{
            NSURLConnection *urlConnectionMock = [NSURLConnection mock];
            [[urlConnectionMock should] receive:@selector(cancel)];
            [imageDownloader setConnection:urlConnectionMock];
            
            [[imageDownloader should] receive:@selector(setState:) withArguments:theValue(AFImageDownloaderStateCompleted), nil];
            
            [imageDownloader cancel];  
        });
        
        it (@"should set the mutable data and connection to nil when completed.", ^{
            [imageDownloader setState:AFImageDownloaderStateCompleted];
            
            [imageDownloader.connection shouldBeNil];
            [imageDownloader.mutableData shouldBeNil];
        });
        
    });
});

SPEC_END
