//
//  NetSSComposite.h
//  NetworkSlideShow
//
//  Created by systemp on 9/16/13.
//  Copyright (c) 2013 systemp. All rights reserved.
//

#import "NetSSComponentObject.h"

@interface NetSSComposite : NetSSComponentObject
@property(strong,atomic)NSMutableArray* children;
@end
