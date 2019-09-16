package com.youban.soe;


import java.util.List;

class SoeResult {
    List<Words> words;
    double pronCompletion;
    double pronAccuracy;
    double pronFluency;
    String audioUrl;

    public List<Words> getWords() {
        return words;
    }

    public void setWords(List<Words> words) {
        this.words = words;
    }

    public double getPronCompletion() {
        return pronCompletion;
    }

    public void setPronCompletion(double pronCompletion) {
        this.pronCompletion = pronCompletion;
    }

    public double getPronAccuracy() {
        return pronAccuracy;
    }

    public void setPronAccuracy(double pronAccuracy) {
        this.pronAccuracy = pronAccuracy;
    }

    public double getPronFluency() {
        return pronFluency;
    }

    public void setPronFluency(double pronFluency) {
        this.pronFluency = pronFluency;
    }

    public String getAudioUrl() {
        return audioUrl;
    }

    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }
}

/// matchTag : "0"
/// word : "good"

class Words {
    String matchTag;
    String word;

    public String getMatchTag() {
        return matchTag;
    }

    public void setMatchTag(int matchTag) {
        this.matchTag = String.valueOf(matchTag);
    }

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }
}