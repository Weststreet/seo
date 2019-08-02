//
//  iFly.m
//  Runner
//
//  Created by sunxy on 2019/6/26.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "iFly.h"
#import <TAISDK/TAIOralEvaluation.h>
#import "PrivateInfo.h"


@interface iFly() <TAIOralEvaluationDelegate>

@property (nonatomic, strong) completionHandler completionHandlers; // array of completionHandler objects.
@property (strong, nonatomic) TAIOralEvaluation *oralEvaluation;
@property (strong, nonatomic) NSString *fileName;

@end

@implementation iFly


- (void)onRecord:(NSString*)text :(NSString*)appId :(NSString*)secretId :(NSString*)secretKey {
    if([self.oralEvaluation isRecording]){
        
        return;
    }
     NSLog(@"开始录制%@ %@ %@ %@",appId,secretId,secretKey,text);
    _fileName = [NSString stringWithFormat:@"taisdk_%ld.mp3", (long)[[NSDate date] timeIntervalSince1970]];
    
    TAIOralEvaluationParam *param = [[TAIOralEvaluationParam alloc] init];
    param.sessionId = [[NSUUID UUID] UUIDString];
    param.appId = appId;
    param.soeAppId = [PrivateInfo shareInstance].soeAppId;
    param.secretId = secretId;
    param.secretKey = secretKey;
    param.token = [PrivateInfo shareInstance].token;
    param.workMode=TAIOralEvaluationWorkMode_Stream;
   
    param.fileType = TAIOralEvaluationFileType_Mp3;
    param.evalMode = TAIOralEvaluationEvalMode_Sentence;
    param.storageMode = TAIOralEvaluationStorageMode_Enable;
    param.serverType = TAIOralEvaluationServerType_English;
    param.scoreCoeff = 4.0;
    param.fileType = TAIOralEvaluationFileType_Mp3;//
    param.refText = text;
    

    param.timeout = 30;
    param.retryTimes = 5;


 
    [self.oralEvaluation startRecordAndEvaluation:param callback:^(TAIError *error) {
        if(error.code == TAIErrCode_Succ){
           
        }
        NSLog(@"startRecordAndEvaluation:%@", error);
    }];
    
    
}

- (void)stopRecord {
    [self.oralEvaluation stopRecordAndEvaluation:^(TAIError *error) {
        NSLog(@"停止录制%@",error);
    }];
}

- (void)setResponse:(NSString *)string
{

    NSLog(@"录制过程%@",string);
}

#pragma mark - oral evaluation delegate
- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation onEvaluateData:(TAIOralEvaluationData *)data result:(TAIOralEvaluationRet *)result error:(TAIError *)error
{

    if(error.code != TAIErrCode_Succ){
        //        [_recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
    }
    [self writeMP3Data:data.audio fileName:_fileName];
   
    if(result!=nil){
  
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSString stringWithFormat:@"%f",result.pronAccuracy], @"pronAccuracy",
                                    [NSString stringWithFormat:@"%f",result.pronFluency], @"pronFluency",
                                    [NSString stringWithFormat:@"%f",result.pronCompletion], @"pronCompletion",
                                    [NSString stringWithFormat:@"%@",result.audioUrl], @"audioUrl",nil];
   
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:result.words.count];
        for (TAIOralEvaluationWord *word  in result.words){
            NSMutableDictionary *words = [NSMutableDictionary dictionary];
            [words setObject:word.word forKey:@"word"];
            [words setObject:[NSString stringWithFormat:@"%d",word.matchTag] forKey:@"matchTag"];
            [array addObject:words];
        }
        [dic setObject:array forKey:@"words"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:nil];
        NSString *jsonString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString=%@", jsonString);
        if(self.completionHandlers!=nil){
            self.completionHandlers(jsonString);
        }
    }
}

- (void)onEndOfSpeechInOralEvaluation:(TAIOralEvaluation *)oralEvaluation
{
NSLog(@"onEndOfSpeechInOralEvaluation");
    [self setResponse:@"onEndOfSpeech"];
    [self stopRecord];
}

- (void)oralEvaluation:(TAIOralEvaluation *)oralEvaluation onVolumeChanged:(NSInteger)volume
{
    NSLog(@"说话音量变化回调");
}

- (TAIOralEvaluation *)oralEvaluation
{NSLog(@"初始化_oralEvaluation");
    if(!_oralEvaluation){
        _oralEvaluation = [[TAIOralEvaluation alloc] init];
        _oralEvaluation.delegate = self;
    }
    return _oralEvaluation;
}

- (void)writeMP3Data:(NSData *)data fileName:(NSString *)fileName
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *mp3Path = [path stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:mp3Path] == false){
        [[NSFileManager defaultManager] createFileAtPath:mp3Path contents:nil attributes:nil];
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:mp3Path];
    [handle seekToEndOfFile];
    [handle writeData:data];
    NSLog(@"mp3Path=%@",mp3Path);
    
}



-(void) addRecognizeResultHandler:(completionHandler)handler
{
    self.completionHandlers=handler;
}

@end
