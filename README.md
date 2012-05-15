#GBRequest - Giant Bomb API wrapper for Objective-C and iOS
####GBRequest is a very simple wrapper for API calls to [Giant Bomb](giantbomb.com) that I developed for a project.

An example of usage:
 `
 
    GBRequest *request = [[GBRequest alloc]init];  
        NSArray *options = [NSArray arrayWithObject:@"genre=Action"];  
        [request requestForEnitityName:@"games" withOptions:options debug:YES];  
        request.resultsPerPage = 10; //API limit is 100  
    	NSArray *results = [request requestResults];  
    	for(NSDictionary *result in results){  
        	NSLog(@"Game Title: %@", [result valueForKey:@"name"]);  
    	}  
    	results = [request nextPage]; // get the next page of 10  
    	
`