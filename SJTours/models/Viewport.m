//
//  Viewport.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/21/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "Viewport.h"
#import "ViewportImage.h"


@implementation Viewport

@dynamic id;
@dynamic time;
@dynamic vtitle;
@dynamic vsmallImage;
@dynamic vcontent;
@dynamic vprice;
@dynamic vaddress;
@dynamic vhomepage;
@dynamic vphoneNumber;
@dynamic vlabel;
@dynamic lng;
@dynamic lat;
@dynamic vtype;
@dynamic vbigImage;

- (void)setData:(NSDictionary*)dict
{
    [self setId:[NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]]];
    [self setVtitle:[dict objectForKey:@"vtitle"]];
    [self setTime:[NSDate date]];
    [self setVsmallImage:[dict objectForKey:@"vsmallImage"]];
    [self setVcontent:[dict objectForKey:@"vcontent"]];
    [self setVprice:[dict objectForKey:@"vprice"]];
    [self setVaddress:[dict objectForKey:@"vaddress"]];
    [self setVhomepage:[dict objectForKey:@"vhomepage"]];
    [self setVphoneNumber:[dict objectForKey:@"vphoneNumber"]];
    [self setVlabel:[dict objectForKey:@"vlabel"]];
    [self setLat:[NSNumber numberWithDouble:[[dict objectForKey:@"lat"] doubleValue]]];
    [self setLng:[NSNumber numberWithDouble:[[dict objectForKey:@"lng"] doubleValue]]];
    
    NSDictionary *typeDict=[dict objectForKey:@"vtype"];
    [self setVtype:[NSNumber numberWithLong:[[typeDict objectForKey:@"id"] longValue]]];
}

- (NSMutableDictionary*)getData{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:self.id forKey:@"id"];
    [dict setObject:self.vtitle forKey:@"vtitle"];
    [dict setObject:self.vsmallImage forKey:@"vsmallImage"];
    [dict setObject:self.vcontent forKey:@"vcontent"];
    [dict setObject:self.vprice forKey:@"vprice"];
    [dict setObject:self.vaddress forKey:@"vaddress"];
    [dict setObject:self.vhomepage forKey:@"vhomepage"];
    [dict setObject:self.vphoneNumber forKey:@"vphoneNumber"];
    [dict setObject:self.vlabel forKey:@"vlabel"];
    [dict setObject:[self.lng stringValue] forKey:@"lng"];
    [dict setObject:[self.lat stringValue] forKey:@"lat"];
    NSMutableArray *images=[[NSMutableArray alloc] init];
    for (ViewportImage *image in self.vbigImage) {
        [images addObject:[image getData]];
    }
    [dict setObject:images forKey:@"vbigImage"];
    
    NSDictionary *type=[NSDictionary dictionaryWithObject:self.vtype forKey:@"id"];
    [dict setObject:type forKey:@"vtype"];
    return dict;
}
@end
