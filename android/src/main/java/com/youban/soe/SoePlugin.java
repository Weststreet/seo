package com.youban.soe;

import android.Manifest;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import com.tencent.taisdk.TAIError;
import com.tencent.taisdk.TAIOralEvaluation;
import com.tencent.taisdk.TAIOralEvaluationCallback;
import com.tencent.taisdk.TAIOralEvaluationData;
import com.tencent.taisdk.TAIOralEvaluationEvalMode;
import com.tencent.taisdk.TAIOralEvaluationFileType;
import com.tencent.taisdk.TAIOralEvaluationListener;
import com.tencent.taisdk.TAIOralEvaluationParam;
import com.tencent.taisdk.TAIOralEvaluationRet;
import com.tencent.taisdk.TAIOralEvaluationServerType;
import com.tencent.taisdk.TAIOralEvaluationStorageMode;
import com.tencent.taisdk.TAIOralEvaluationWord;
import com.tencent.taisdk.TAIOralEvaluationWorkMode;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * SoePlugin
 */
public class SoePlugin implements MethodCallHandler {
    private TAIOralEvaluation oral;
    private static EventChannel.EventSink eventSink;
    private Registrar registrar;
    final int REQUEST_RECORD_AUDIO_CODE=1;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "youban_ifly");
        channel.setMethodCallHandler(new SoePlugin(registrar));

        final EventChannel eventChannel =
                new EventChannel(registrar.messenger(), "plugins.flutter.io/sensors/gyroscope");

        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink sink) {
                eventSink = sink;
            }

            @Override
            public void onCancel(Object o) {

            }
        });

    }

    private SoePlugin(final Registrar registrar) {
        this.registrar = registrar;
        oral = new TAIOralEvaluation();
        oral.setListener(new TAIOralEvaluationListener() {
            @Override
            public void onEvaluationData(final TAIOralEvaluationData data, final TAIOralEvaluationRet result, final TAIError error) {
                //数据和结果回调（只有data.bEnd为true，result有效）
                if (data.bEnd&&result!=null) {
                    SoeResult soeResult = new SoeResult();
                    soeResult.setAudioUrl(result.audioUrl);
                    soeResult.setPronAccuracy(result.pronAccuracy);
                    soeResult.setPronCompletion(result.pronCompletion);
                    soeResult.setPronFluency(result.pronFluency);
                    ArrayList<Words> wordsList = new ArrayList<>();
                    for (TAIOralEvaluationWord taiOralEvaluationWord : result.words) {
                        if (taiOralEvaluationWord != null) {
                            Words words = new Words();
                            words.setMatchTag(taiOralEvaluationWord.matchTag);
                            words.setWord(taiOralEvaluationWord.word);
                            wordsList.add(words);
                        }
                    }
                    soeResult.setWords(wordsList);
                    eventSink.success(soeResult);
                }
            }
        });
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("startRecord")) {
            int permissionCheck = ContextCompat.checkSelfPermission(registrar.activity(),
                    Manifest.permission.RECORD_AUDIO);
            if(permissionCheck== PackageManager.PERMISSION_GRANTED){
                Log.d("TAG", "startRecordddd");
                onRecord((String) call.argument("sentence"), (String) call.argument("appId"), (String) call.argument("secretId"), (String) call.argument("secretKey"));
            }else{
                ActivityCompat.requestPermissions(registrar.activity(),
                        new String[]{Manifest.permission.RECORD_AUDIO}, REQUEST_RECORD_AUDIO_CODE);
            }

        } else if (call.method.equals("stopRecord")) {
            onStopRecord();
        } else {
            result.notImplemented();
        }
    }

    private void checkPermission() {

    }

    private void onRecord(String text, String appid, String secretId, String secretKey) {
        //1.初始化参数
        TAIOralEvaluationParam param = new TAIOralEvaluationParam();
        param.context = registrar.context();
        param.appId = appid;
        param.sessionId = UUID.randomUUID().toString();
        param.workMode = TAIOralEvaluationWorkMode.ONCE;
        param.evalMode = TAIOralEvaluationEvalMode.SENTENCE;
        param.storageMode = TAIOralEvaluationStorageMode.DISABLE;
        param.serverType = TAIOralEvaluationServerType.ENGLISH;
        param.fileType = TAIOralEvaluationFileType.MP3;//只支持mp3
        param.scoreCoeff = 1.0;
        param.refText = text;
        param.secretId = secretId;
        param.secretKey = secretKey;
        //2.开始录制
        oral.startRecordAndEvaluation(param, new TAIOralEvaluationCallback() {
            @Override
            public void onResult(final TAIError error) {
                //结果返回
            }
        });

    }

    private void onStopRecord() {
        //3.结束录制
        oral.stopRecordAndEvaluation(new TAIOralEvaluationCallback() {
            @Override
            public void onResult(final TAIError error) {
                Log.d("TAg","onStopRecord");
                //结果返回
            }
        });
    }


}
