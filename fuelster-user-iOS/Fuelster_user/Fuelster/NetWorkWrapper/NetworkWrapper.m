//
//  NetworkWrapper.m
//  ESCMS
//
//  Created by srachha on 19/05/14.
//  Copyright (c) 2014 Srachha. All rights reserved.

#import "NetworkWrapper.h"
//#import "NSMutableURLRequest+SSLAuthentication.h"
#import "NSMutableURLRequest+NSMutableRequestHeaders.h"
#import "UIDevice+Hardware.h"

NSString *const kNetworkUtilitiesErrorDomain = @"kBrandErrorDomain";
NSInteger const kNetworkUtilitiesHttpErrorCode = 5;
//NSString * const Fuelster_BaseUrl = @"http://192.168.3.127:3002";
//NSString * const Fuelster_BaseUrl = @"http://fuelster-local-dev.rapidbizapps.com:3005";
NSString * const Fuelster_BaseUrl = @"http://fuelster-api-test.rapidbizapps.com";
//NSString * const Fuelster_BaseUrl = @"http://192.168.3.153:3000";
//NSString * const Fuelster_BaseUrl = @"http://fuelster-api-test.rapidbizapps.com";

 // NSString * const Fuelster_BaseUrl = @"https://app.fuelster.co/api";


//@"http://fuelster-api-test.rapidbizapps.com";

//@"http://fuelster-local-dev.rapidbizapps.com:3005";
//@"http://fuelster-api-test.rapidbizapps.com";
//@"http://fuelster-local-dev.rapidbizapps.com";


@implementation NetworkWrapper

@synthesize serviceType;

+(void)connectWithURLString:(NSDictionary *)body method:(NSString *)method service:(NSString *)service  successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock

{
    
    dispatch_queue_t default_queuet = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 2);
    dispatch_async(default_queuet, ^{
        
        NSString *urlString = Fuelster_BaseUrl;
        
        // Set the Request
        urlString = [urlString stringByAppendingFormat:@"%@",service];
        NSURL *serviceUrl;
        NSMutableURLRequest *request;
        if ([method isEqualToString:@"GET"]){
            NSString *bodyStr = [NSString stringWithFormat:@"%@",body?body:@""];
            if ([bodyStr length]>0) {
                urlString = [urlString stringByAppendingFormat:@"%@",bodyStr];
            }
            serviceUrl = [NSURL URLWithString:urlString];
            request = [NSMutableURLRequest requestWithURL:serviceUrl];
            
            request.HTTPMethod = method;
            
        } else {
            
            serviceUrl = [NSURL URLWithString:urlString];
            request = [NSMutableURLRequest requestWithURL:serviceUrl];
            //NSLog(@"%@",urlString);
            //NSLog(@"Post Body %@",body);
            request.HTTPMethod = method;
            [request setupPostBodyHeader:body];
        }
        NSLog(@"%@",urlString);

        //NSLog(@"all header %@",request.allHTTPHeaderFields);
        if ([service rangeOfString:@"register"].location != NSNotFound || [service rangeOfString:@"login"].location != NSNotFound || [service rangeOfString:@"forgot-password"].location != NSNotFound || [service rangeOfString:@"reset-password"].location != NSNotFound) {
            [request setupRequestHeadersAllowSession:NO multiPart:NO];
        }
        else {
            [request setupRequestHeadersAllowSession:YES multiPart:NO];
        }
        
        [[self class] sendAsynchronousRequest:request successBlock:successBlock failureBlock:failureBlock];
    });
    
}

+(NSDictionary *)getAuthInfo
{
    
    return @{};
}
+(void)connectWithMultiformBody:(NSArray *)body withNames:(NSArray *)nameKeys method:(NSString *)method service:(NSString *)service dataType:(NSString *)type successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock
{
    
    dispatch_queue_t default_queuet = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 2);
    dispatch_async(default_queuet, ^{
        
        NSString *urlString = Fuelster_BaseUrl;
        urlString = [urlString stringByAppendingFormat:@"%@",service];
        NSURL *serviceUrl;
        NSString *filename = @"filename";
        serviceUrl = [NSURL URLWithString:urlString];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:serviceUrl];
        request.HTTPMethod = method;
        //create boundary and contentType mulitpart formdata
        //NSLog(@"%@",serviceUrl);
        NSString *boundary = @"---011000010111000001101001";
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        [request addValue:contentType forHTTPHeaderField: @"content-type"];
        
        NSMutableData *postbody = [NSMutableData data];
        //NSData *videoData = [body lastObject];
        
        //append all Other parameter  as text,setting boundary to it
        for (int i = 0; i<[body  count]; i++) {
           [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            if ([body[i] isKindOfClass:[NSData class]]) {
                NSData *videoData = body[i];
                [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;name=%@;filename=\"%@\"\r\n",nameKeys[i],filename] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [postbody appendData:videoData];
            }
            else {
                [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n",[nameKeys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [postbody appendData:[[NSString stringWithFormat:@"%@",[body objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
        //finally setBody
        [request setHTTPBody:postbody];
        [request setupRequestHeadersAllowSession:YES multiPart:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postbody length]];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        [[self class] sendAsynchronousRequest:request successBlock:successBlock failureBlock:failureBlock];
        
    });
    
}


+(void)downLoadImageWithURL:(NSURL*)url successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock {
    
    dispatch_queue_t default_queuet = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 2);
    dispatch_async(default_queuet, ^{
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (connectionError == nil)
            {
                // check the response code..
                if ([response isKindOfClass:[ NSHTTPURLResponse class] ] )
                {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    //NSLog(@" header fields %@",[httpResponse allHeaderFields]);
                    if ( [ httpResponse statusCode ] != 200 )
                    {
                        NSError *httpError = [NetworkWrapper errorWithResponse:httpResponse withData:data];
                        failureBlock(response, httpError);
                        
                    } else {
                        successBlock(response,data);
                    }
                }
                
            } else {
                failureBlock(response, connectionError);
            }
            
        }];
    });
}


+(void)sendAsynchronousRequest:(NSURLRequest *) request successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock
{
    if (![[UIDevice currentDevice] versionLessThaniOS8]) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *connectionError) {
            if (connectionError == nil)
            {
                if ([response isKindOfClass:[ NSHTTPURLResponse class] ] )
                {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    //NSLog(@" header fields %@",[httpResponse allHeaderFields]);
                    if ( [ httpResponse statusCode ] != 200 )
                    {
                        NSError *httpError = [NetworkWrapper errorWithResponse:httpResponse withData:data];
                        failureBlock(response, httpError);
                    } else {
                        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        NSLog(@"reuslt %@",result);
                        successBlock(response,result);
                    }
                }
            } else {
               
                failureBlock(response, connectionError);
            }
        }];
        [task resume];
    } else{
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (connectionError == nil)
            {
                // check the response code..
                if ([response isKindOfClass:[ NSHTTPURLResponse class] ] )
                {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
 
                    //NSLog(@" header fields %@",[httpResponse allHeaderFields]);
 
                    NSLog(@" header fields %@",[httpResponse allHeaderFields]);
                    
                    if ([httpResponse statusCode] == 426)
                    {
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"NotificationIdentifier"
                         object:self];

                    }
 
                    if ( [ httpResponse statusCode ] != 200 )
                    {
                        NSError *httpError = [NetworkWrapper errorWithResponse:httpResponse withData:data];
                        failureBlock(response, httpError);
                    } else {
                        // we are good.. so continue and run the completion block
                        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        successBlock(response,result);
                    }
                }
            } else {
                failureBlock(response, connectionError);
            }
        }];
    }
}



+(NSError *)errorWithResponse:(NSHTTPURLResponse *)response withData:(NSData *)data
{
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //NSLog(@"status code%@ %ld",result,(long)[ response statusCode ]);
    //NSLog(@"error description %@",[NSHTTPURLResponse localizedStringForStatusCode:[ response statusCode ]]);

    NSDictionary *userInfoDict = nil;
    if (result) {
        if ([[result allKeys] containsObject:@"result"]) {
            userInfoDict = [NSDictionary dictionaryWithObject:result[@"result"][@"error"] forKey:NSLocalizedDescriptionKey];
        }
        else {
            userInfoDict = [NSDictionary dictionaryWithObject:result[@"message"] forKey:NSLocalizedDescriptionKey];
        }
    }
    else
    {
        userInfoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld-%@",(long)[ response statusCode ],[NSHTTPURLResponse localizedStringForStatusCode:[ response statusCode ]]]forKey:NSLocalizedDescriptionKey];
        // create an error..
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:userInfoDict];
    [dict setObject:[NSNumber numberWithInteger:[ response statusCode ]] forKey:@"statusCode"];
    NSError *httpError = [ [ NSError alloc ] initWithDomain:kNetworkUtilitiesErrorDomain code:kNetworkUtilitiesHttpErrorCode userInfo:dict];

    
    return httpError;
}


@end
