//
//  ViewportImage.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/21/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "ViewportImage.h"
#import "Viewport.h"


@implementation ViewportImage

@dynamic id;
@dynamic imageUrl;
@dynamic viewport;

- (void)setData:(NSDictionary*)dict
{
    [self setId:[NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]]];
    [self setImageUrl:[dict objectForKey:@"imageUrl"]];
}

- (NSMutableDictionary*)getData{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[self.id stringValue] forKey:@"id"];
    [dict setObject:self.imageUrl forKey:@"imageUrl"];
    return dict;
}
@end
