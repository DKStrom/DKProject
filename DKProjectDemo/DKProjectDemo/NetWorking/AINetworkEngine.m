//
//  AINetworkEngine.m
//  EWoCartoon
//
//  Created by Crauson on 16/5/1.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "AINetworkEngine.h"
#import "CommonMacro.h"
#import "CommonTool.h"
//#import "UserTokenModel.h"

@implementation AINetworkEngine


+ (AINetworkEngine *)sharedClient {
    static AINetworkEngine *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AINetworkEngine alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_ADDRESS]];
        
    });
    return _sharedClient;
}

+ (AINetworkEngine *)sharedClientWithoutBaseURL{
    static AINetworkEngine *_sharedClientNoBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClientNoBase = [[AINetworkEngine alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    return _sharedClientNoBase;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    /**设置请求超时时间*/
    self.requestSerializer.timeoutInterval = 30;
    /**设置相应的缓存策略*/
    self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    /**分别设置请求以及相应的序列化器*/
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    self.responseSerializer = response;
    [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    /**设置接受的类型*/
    [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    
    if ([[url scheme] isEqualToString:@"https"]) {
        [self setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate]];
    } else {
        [self setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
    }
    return self;
}

// 【get】方式请求数据
- (void)getWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block
{
    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    [self GET:api parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"operation.response.URL:%@",task.response.URL);
        
        NSLog(@"列表请求结果是：%@",responseObject);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"operation.response.URL:%@",task.response.URL);
        if (block) {
            block(nil, error);
        }
    }];
    
}

// 【post】方式请求数据
- (void)postWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block{
    
    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    [self POST:api parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"operation.response.URL:%@",task.response.URL);
        
        NSLog(@"列表请求结果是：%@",responseObject);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"operation.response.URL:%@",task.response.URL);
        if (block) {
            block(nil, error);
        }
        
    }];
    
}

// 【post】方式请求数据 带header
- (void)postWithApi:(NSString *)api headerAndParameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block{
    
//    [self.requestSerializer setValue:[UserTokenModel readFromLocal].authorization forHTTPHeaderField:@"Authorization"];
    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    [self POST:api parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DKLog(@"operation.response.URL:%@",task.response.URL);
        
        DKLog(@"列表请求结果是：%@",responseObject);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DKLog(@"operation.response.URL:%@",task.response.URL);
        if (block) {
            block(nil, error);
        }
        
    }];
    
}

//// 【post】方式上传表单图片
- (void)postImagesWithApi:(NSString *)api parameters:(NSDictionary *)params images:(NSArray *)array CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block
{
    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    
    [self POST:api parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 注意：这个name（我的后台给的字段是file）一定要和后台的参数字段一样 否则不成功
        for (UIImage *photo in array) {
            NSData *imagePNGData = UIImagePNGRepresentation(photo);
            NSData *imageJPEGData = UIImageJPEGRepresentation(photo, 1.0);
            
            if (imagePNGData) {
                [formData appendPartWithFileData:imagePNGData name:@"images" fileName:@"images.png" mimeType:@"image/png"];
            }else{
                [formData appendPartWithFileData:imageJPEGData name:@"images" fileName:@"images.jpg" mimeType:@"image/jpg/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"operation.response.URL:%@",task.response.URL);
        
        NSLog(@"列表请求结果是：%@",responseObject);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"operation.response.URL:%@",task.response.URL);
        NSLog(@"列表请求的错误结果是：%@",error);

        if (block) {
            block(nil, error);
        }
    }];
    
}


// 【post】方式上传表单多张图片
- (void)postDynamicsImagesWithApi:(NSString *)api parameters:(NSDictionary *)params images:(NSArray *)array CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block
{
    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    
    [self POST:api parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 注意：这个name（我的后台给的字段是file）一定要和后台的参数字段一样 否则不成功
        for (UIImage *photo in array) {
            //缩略图压缩
            CGFloat imgBresWidth;
            CGFloat imgBresHeight;
            if (photo.size.width > photo.size.height) {
                imgBresWidth = 300.0f;
                imgBresHeight =  photo.size.height * imgBresWidth / photo.size.width;
            }else{
                imgBresHeight = 300.0f;
                imgBresWidth = photo.size.width * imgBresHeight / photo.size.height;
            }

            UIImage *imgBres = [CommonTool imageByScalingAndCroppingForSize:CGSizeMake(imgBresWidth, imgBresHeight) withSourceImage:photo];

            NSData *imgBresPNGData = UIImagePNGRepresentation(imgBres);
            NSData *imgBresJPEGData = UIImageJPEGRepresentation(imgBres, 1.0);

            if (imgBresPNGData) {
                [formData appendPartWithFileData:imgBresPNGData name:@"imgBres" fileName:@"images.png" mimeType:@"image/png"];
            }else{
                [formData appendPartWithFileData:imgBresJPEGData name:@"imgBres" fileName:@"images.jpg" mimeType:@"image/jpg/jpeg"];
            }

            NSData *imgOrisPNGData = UIImagePNGRepresentation(photo);
            NSData *imgOrisJPEGData = UIImageJPEGRepresentation(photo, 1.0);

            if (imgOrisPNGData) {
                [formData appendPartWithFileData:imgOrisPNGData name:@"imgOris" fileName:@"images.png" mimeType:@"image/png"];
            }else{
                [formData appendPartWithFileData:imgOrisJPEGData name:@"imgOris" fileName:@"images.jpg" mimeType:@"image/jpg/jpeg"];
            }
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"operation.response.URL:%@",task.response.URL);
        
        NSLog(@"列表请求结果是：%@",responseObject);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"operation.response.URL:%@",task.response.URL);
        NSLog(@"列表请求的错误结果是：%@",error);
        if (block) {
            block(nil, error);
        }
    }];
}

// 【post】方式上传表单视频图片
- (void)postVideoWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block
{
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.mp4"];
    
    //上传图片
    UIImage *image = [CommonTool getVideoPreViewImage:[NSURL fileURLWithPath:pathToMovie]];

    NSData *imagePNGData = UIImagePNGRepresentation(image);
    NSData *imageJPEGData = UIImageJPEGRepresentation(image, 1.0);

    api=[[NSString stringWithFormat:@"%@",api] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];

    [self POST:api parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        // 注意：这个name（我的后台给的字段是file）一定要和后台的参数字段一样 否则不成功

        //上传视频
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:pathToMovie] name:@"file" fileName:@"video.mp4" mimeType:@"video/mp4"];

        if (imagePNGData) {
            [formData appendPartWithFileData:imagePNGData name:@"videoImage" fileName:@"images.png" mimeType:@"image/png"];
        }else{
            [formData appendPartWithFileData:imageJPEGData name:@"videoImage" fileName:@"images.jpg" mimeType:@"image/jpg/jpeg"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"operation.response.URL:%@",task.response.URL);

        NSLog(@"列表请求结果是：%@",responseObject);
        @try {
            if (block) {  // 将请求下来的数据放到block块中
                AINetworkResult *resultptr = [AINetworkResult createWithDic:responseObject];
                block(resultptr, nil);
            }
        }
        @catch (NSException *exception) {

        }
        @finally {

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"operation.response.URL:%@",task.response.URL);
        NSLog(@"列表请求的错误结果是：%@",error);
        if (block) {
            block(nil, error);
        }
    }];
}

//-(void)downLoadFile:(NSString *)severPath
//      andOutPutpath:(NSString*)localPath
//    CompletionBlock:(void (^)(NSDictionary *posts, NSError *error))block{
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:severPath]];
//    AFHTTPSessionManager *operation = [[AFHTTPSessionManager alloc] initWithRequest:request];
//    
//    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:localPath append:NO];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        CLog(@"Successfully downloaded file to %@",localPath);
//        if (block) {
//            block ([NSDictionary dictionaryWithObjectsAndKeys:@"200",@"code", nil], nil);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        CLog(@"Error: %@", error);
//        if (block) {
//            block ([NSDictionary dictionary], error);
//        }
//    }];
//    
//    [operation start];
//}

@end
