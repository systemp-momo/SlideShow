//
//  NetSSCompositeTests.m
//  SPSmbSlideshow
//
//  Created by systemp on 2016/06/26.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetSSLeaf.h"
#import "NetSSComponentObject.h"
#import "NetSSComposite.h"

@interface NetSSCompositeTests : XCTestCase

@end

@implementation NetSSCompositeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNetSSCompositeInit
{
    @autoreleasepool {
        NetSSComposite *composite = [[NetSSComposite alloc]init];
        XCTAssertNotNil(composite);
        XCTAssertEqual([composite.children count], 0);
    }
}

- (void)testNetSSComponentObjectProperty
{
    @autoreleasepool {
        NetSSComponentObject* obj = [[NetSSComponentObject alloc]init];
        XCTAssertNotNil(obj);
        NSString* expected = @"abc";
        obj.fullPath = expected;
        XCTAssertTrue([expected isEqualToString:obj.fullPath]);
    }
}
- (void)testNetSSLeafInit
{
    @autoreleasepool {
        NetSSLeaf *leaf = [[NetSSLeaf alloc]init];
        XCTAssertNotNil(leaf);
    }
}
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
