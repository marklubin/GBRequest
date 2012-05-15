//
//  GBRequest.m
// 
//
//  Created by Mark Lubin on 5/14/12.
//  Copyright (c) 2012 Mark Lubin. All rights reserved.
//

#import "GBRequest.h"

@interface GBRequest()
@property (nonatomic,strong) NSURL *currentRequestURL;
@property (nonatomic,strong) GBEntity entity;
@property (nonatomic,strong) NSArray *requestOptions;
@property  (nonatomic) NSUInteger numResultsAtGiantBomb;
@property  (readonly)  NSUInteger offset;
@property (nonatomic)  NSUInteger page;


@end

@implementation GBRequest
@synthesize debug = _debug;
@synthesize currentRequestURL = _currentRequestURL;
@synthesize entity = _entity;
@synthesize requestOptions = _requestOptions;
@synthesize numResultsAtGiantBomb = _numResultsAtGiantBomb;
@synthesize page = _page;
@synthesize resultsPerPage = _resultsPerPage;

-(NSUInteger)offset{
    return self.numResultsAtGiantBomb - (self.page * self.resultsPerPage);
}


-(void)setEntity:(GBEntity)entity{
    _entity = entity;
    //if the type of request changes need fetch numResults again
    self.numResultsAtGiantBomb = 0;
}

-(NSUInteger)page{
    //default value for page is 1
    if(!_page) return 1;
    else return _page;
}

-(NSUInteger)resultsPerPage{
    if(!_resultsPerPage) return 20;
    else return _resultsPerPage;
}

-(void)constructURL{
    NSString *query = 
    [NSString stringWithFormat:@"%@/%@/?api_key=%@&offset=%i&&limit=%i&format=%@",BASE_URL,self.entity,GB_API_KEY,self.offset,self.resultsPerPage,REQUEST_FORMAT];
    
    for(NSString *option in self.requestOptions){
        query = [query stringByAppendingFormat:@"&%@",option];
    }
    
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.currentRequestURL = [NSURL URLWithString:query];
    if(self.debug) NSLog(@"%@",[self.currentRequestURL description]);
    
}


-(void)requestForEntityName:(GBEntity)name{
    self.entity = name;
    [self constructURL];
}
-(void)requestForEnitityName:(GBEntity)name
                        withOptions:(NSArray *)options
{
     self.requestOptions = options;
    [self requestForEntityName:name];
   
}

//initalizer with debug for logging
-(void)requestForEnitityName:(GBEntity)name
                 withOptions:(NSArray *)options
                       debug:(BOOL)debug
{
    self.debug = debug;
    [self requestForEnitityName:name withOptions:options];
    
}

-(void)updateNumResults{
    NSString *query = [NSString stringWithFormat:@"%@/%@/?api_key=%@&limit=1&format=%@",BASE_URL,self.entity,GB_API_KEY,REQUEST_FORMAT];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *results = [self executeRequestWithQuery:[NSURL URLWithString:query]];
    self.numResultsAtGiantBomb = [[results valueForKey:@"number_of_total_results"] intValue];
    [self constructURL]; //update url
    
}

-(NSArray *)requestResults{
    if(!self.numResultsAtGiantBomb){//get the total number of results to sort descending
        [self updateNumResults];
    }
    NSDictionary *results = [self executeRequestWithQuery:self.currentRequestURL];
    return [results valueForKey:@"results"];
}


-(NSDictionary *)executeRequestWithQuery:(NSURL *)query{
    NSData *jsonData = [[NSString stringWithContentsOfURL:query
                                                 encoding:NSUTF8StringEncoding 
                                                    error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    return results;
}


-(NSArray *)nextPage{
    ++self.page;
    [self constructURL];
    return [self requestResults];
}



@end
