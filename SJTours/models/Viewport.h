//
//  Viewport.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/21/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Viewport : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * vtitle;
@property (nonatomic, retain) NSString * vsmallImage;
@property (nonatomic, retain) NSString * vcontent;
@property (nonatomic, retain) NSString * vprice;
@property (nonatomic, retain) NSString * vaddress;
@property (nonatomic, retain) NSString * vhomepage;
@property (nonatomic, retain) NSString * vphoneNumber;
@property (nonatomic, retain) NSString * vlabel;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * vtype;
@property (nonatomic, retain) NSSet *vbigImage;

- (void)setData:(NSDictionary*)dict;
- (NSMutableDictionary*)getData;
@end

@interface Viewport (CoreDataGeneratedAccessors)

- (void)addVbigImageObject:(NSManagedObject *)value;
- (void)removeVbigImageObject:(NSManagedObject *)value;
- (void)addVbigImage:(NSSet *)values;
- (void)removeVbigImage:(NSSet *)values;

@end
