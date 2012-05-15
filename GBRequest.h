//
//  GBRequest.h
//  
//
//  Created by Mark Lubin on 5/14/12.
//  Copyright (c) 2012 Mark Lubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BASE_URL @"http://api.giantbomb.com"
#define REQUEST_FORMAT @"JSON"

 //#define your GB_API_KEY in that file as an NSString
#include "GiantBombAPIKey.h"


typedef NSString* GBEntity;
typedef int GBGameID;

@interface GBRequest : NSObject

@property BOOL debug;
@property  (nonatomic) NSUInteger resultsPerPage;

//basic request all defaults
-(void)requestForEntityName:(GBEntity)name;

//set up request with options
-(void)requestForEnitityName:(GBEntity)name
                        withOptions:(NSArray *)options;

//set up request for option for debugging to console
-(void)requestForEnitityName:(GBEntity)name
                        withOptions:(NSArray *)options
                              debug:(BOOL)debug;

//return the results
-(NSArray *)requestResults;


//return the nextpage
-(NSArray *)nextPage;






@end
