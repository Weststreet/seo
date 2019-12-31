#import "SoePlugin.h"
#import "iFly.h"

@implementation SoePlugin
iFly *fly;
FlutterMethodChannel* channel;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    //init message channele
    channel = [FlutterMethodChannel
               methodChannelWithName:@"youban_ifly"
               binaryMessenger:[registrar messenger]];



    SoePlugin* instance = [[SoePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    //init fly
    fly =  [[iFly alloc] init];
    //init eventchannel
    FLTSentenceRecognizeStreamHandler* sentenceRecognizeStreamHandler = [[FLTSentenceRecognizeStreamHandler alloc] init];
    FlutterEventChannel* sentenceRecognizeChannel =
    [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/gyroscope"
                              binaryMessenger:[registrar messenger]];
    [sentenceRecognizeChannel setStreamHandler:sentenceRecognizeStreamHandler];




}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"startRecord" isEqualToString:call.method]) {
        NSLog(@"starttttttrocord");
        [fly onRecord:call.arguments[@"sentence"] :call.arguments[@"appId"] :call.arguments[@"secretId"] :call.arguments[@"secretKey"]];

        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"stopRecord" isEqualToString:call.method]) {
        [fly stopRecord];
        NSLog(@"stopRecordstopRecord");
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else {
        result(FlutterMethodNotImplemented);
    }
}



@end



@implementation FLTSentenceRecognizeStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
NSLog(@"结果？%@",@"dddddd");
    [fly addRecognizeResultHandler:^(NSString * _Nonnull result) {
    NSLog(@"结果？%@",result);
    NSLog(@"！！！！");
        eventSink(result);
    }];
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    return nil;
}

@end
