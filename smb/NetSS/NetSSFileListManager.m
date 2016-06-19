//
//  NetSSFileListManager.m
//  NetworkSlideShow
//
//  Created by systemp on 9/16/13.
//  Copyright (c) 2013 systemp. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "NetSSFileListManager.h"
#import "NetSSComposite.h"
#import "NetSSLeaf.h"

@interface NetSSFileListManager()
@property (strong, atomic)NetSSComposite* root;
@property (strong, atomic)NSMutableArray* fileList;
@property (assign, atomic)bool isCollecting;
@property (assign, atomic)bool cancel;
@end

@implementation NetSSFileListManager
- (id)init
{
    self = [super init];
    if (self) {
        _root = nil;
        _excludedFileExtensionList = [NSArray array];
        _excludedDirectoryNameList = [NSArray array];
        _fileList = [NSMutableArray array];
        _isCollecting = NO;
        _cancel = NO;
    }
    return self;
}

-(void)dealloc
{
    _excludedFileExtensionList = nil;
    _excludedDirectoryNameList = nil;
    _root = nil;
    _fileList = nil;
}

-(void)collectTree:(NSString*)url
{
    self.root = [[NetSSComposite alloc ]init];
    self.fileList = [NSMutableArray array];
    self.cancel = NO;
    
    self.isCollecting = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getDirectoryList:[self makeRootUrlPath:url] for:self.root];
        
        NSLog(@"collecting DONE");
        self.isCollecting = NO;
        self.cancel = NO;
        if( self.onCollectingCompletion != nil )
        {
            self.onCollectingCompletion();
        }
    });
}

-(NSString*)makeRootUrlPath:(NSString*)url
{
    NSString *suffix = [url hasSuffix:@"/"] ? @"" :@"/";
    NSString *formattedRoot = [NSString stringWithFormat:@"%@%@", url, suffix];
    return formattedRoot;
}

-(void)cancelCollecting
{
    self.cancel = YES;
}

-(void)getDirectoryList:(NSString*)url for:(NetSSComposite*)composite
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* contents = [fm contentsOfDirectoryAtPath:url error:nil];
    void (^block)(NSString*, NSUInteger, BOOL*) = ^(NSString* content, NSUInteger idx, BOOL* stop){
        BOOL isDir = NO;
        NSString* contentFullpath = [NSString stringWithFormat:@"%@%@", url, content];
        [fm fileExistsAtPath:contentFullpath isDirectory:&isDir];
        
        if(isDir && [self isValidDirectoryName:contentFullpath])
        {
            NetSSComposite* obj = [self addDirectoryWith:contentFullpath toNode:composite];
            [self getDirectoryList:obj.fullPath for:obj];
        }
        else if( [self isImageFile:contentFullpath])
        {
            [self addImageFileWith:contentFullpath toNode:composite];
        }
    };
    [contents enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:block];

    return;
}
-(void)addImageFileWith:(NSString*)fullpath toNode:(NetSSComposite*)node
{
    NetSSLeaf* obj = [[NetSSLeaf alloc]init];
    obj.fullPath = fullpath;
    [node.children addObject:obj];
    @synchronized(self) {
        [self.fileList addObject:obj.fullPath];
    }
}
-(NetSSComposite*)addDirectoryWith:(NSString*)fullpath toNode:(NetSSComposite*)node
{
    NetSSComposite* obj = [[NetSSComposite alloc]init];
    NSString *suffix = [fullpath hasSuffix:@"/"] ? @"" :@"/";
    obj.fullPath = [NSString stringWithFormat:@"%@%@", fullpath, suffix];
    [node.children addObject:obj];
    
    return obj;
}
-(BOOL)isValidDirectoryName:(NSString*)fullpath
{
    NSString* directoryName = [[fullpath pathComponents] lastObject];
    return (![self.excludedDirectoryNameList containsObject:directoryName]);
}

-(BOOL)isImageFile:(NSString*)fullpath
{
    BOOL isImage = NO;
    
    NSString* uti=[[NSWorkspace sharedWorkspace] typeOfFile:fullpath error:nil];
    isImage = [[NSWorkspace sharedWorkspace] type:uti conformsToType:@"public.image"];
    
    NSString* extension = [fullpath pathExtension];

    if(isImage && ![self.excludedFileExtensionList containsObject:extension])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSString*)getImagePathAtRandom
{
    NSString *result = nil;
    @synchronized(self) {
        if(self.fileList.count==0)
        {
            return result;
        }
        NSUInteger max = self.fileList.count;
        
        srandom((unsigned)time(NULL));
        long randomNumber = random() % max;
        result = [self.fileList objectAtIndex:randomNumber];
    }
    return result;
}

@end
