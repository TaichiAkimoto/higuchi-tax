
import React, { useState, useEffect, useCallback } from 'react';
import { AppStage, MicroStep } from './types';
import { INITIAL_STEPS, VALIDATION_MESSAGES } from './constants';
import { Button } from './components/Button';
import { getEncouragement } from './services/geminiService';

const App: React.FC = () => {
  const [stage, setStage] = useState<AppStage>(AppStage.START);
  const [steps, setSteps] = useState<MicroStep[]>(INITIAL_STEPS);
  const [currentStepIdx, setCurrentStepIdx] = useState(0);
  const [geminiMessage, setGeminiMessage] = useState<string>('');
  const [isLoadingMessage, setIsLoadingMessage] = useState(false);

  const fetchAIEncouragement = async (context: string) => {
    setIsLoadingMessage(true);
    const msg = await getEncouragement(context);
    setGeminiMessage(msg);
    setIsLoadingMessage(false);
  };

  const handleStart = () => {
    setStage(AppStage.VALIDATION);
    fetchAIEncouragement("封筒を開けようとしているけど、腰が重くて動けない。");
  };

  const nextStage = () => {
    if (stage === AppStage.VALIDATION) setStage(AppStage.MISSION_SETUP);
    else if (stage === AppStage.MISSION_SETUP) setStage(AppStage.GUIDE);
  };

  const completeStep = (idx: number) => {
    const newSteps = [...steps];
    newSteps[idx].completed = true;
    setSteps(newSteps);
    
    if (idx < steps.length - 1) {
      setCurrentStepIdx(idx + 1);
      // Fetch dynamic encouragement for next steps sometimes
      if (idx === 2) fetchAIEncouragement("封筒を持ったところ。次はハサミを用意する。");
    } else {
      setStage(AppStage.FINISH);
    }
  };

  const reset = () => {
    setStage(AppStage.START);
    setSteps(INITIAL_STEPS.map(s => ({ ...s, completed: false })));
    setCurrentStepIdx(0);
    setGeminiMessage('');
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-4 text-slate-800">
      <div className="max-w-md w-full bg-white rounded-3xl shadow-xl overflow-hidden border border-slate-100 flex flex-col min-h-[600px]">
        
        {/* Header */}
        <div className="p-6 border-b border-slate-50 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-indigo-100 rounded-lg flex items-center justify-center">
              <span className="text-indigo-600">✉️</span>
            </div>
            <h1 className="font-bold text-lg text-slate-700">Envelope Buddy</h1>
          </div>
          {stage !== AppStage.START && (
            <button onClick={reset} className="text-xs text-slate-400 hover:text-slate-600 transition-colors">
              リセット
            </button>
          )}
        </div>

        {/* Content Area */}
        <div className="flex-grow p-8 flex flex-col">
          
          {stage === AppStage.START && (
            <div className="flex flex-col items-center text-center space-y-6 my-auto animate-in fade-in duration-700">
              <div className="w-24 h-24 bg-indigo-50 rounded-full flex items-center justify-center text-5xl mb-4">
                📬
              </div>
              <h2 className="text-2xl font-bold text-slate-800 leading-tight">
                その封筒、<br/>一緒に開けませんか？
              </h2>
              <p className="text-slate-500 text-sm leading-relaxed">
                「ただの封筒なのに、なぜか手が動かない」<br/>
                それはあなたが怠けているからではなく、<br/>
                脳が少し疲れているだけです。
              </p>
              <Button onClick={handleStart} className="w-full mt-4">
                助けてもらう
              </Button>
            </div>
          )}

          {stage === AppStage.VALIDATION && (
            <div className="flex flex-col space-y-6 animate-in slide-in-from-bottom-4 duration-500">
              <div className="space-y-4">
                <h2 className="text-xl font-bold text-indigo-900">分かります。それは「人間らしい」反応です。</h2>
                <div className="bg-slate-50 p-4 rounded-2xl border border-slate-100 text-sm leading-relaxed text-slate-600">
                  <p className="mb-2 font-medium text-slate-700">脳はこう思っているかもしれません：</p>
                  <ul className="space-y-2">
                    <li className="flex gap-2"><span>😱</span> 中身が怖い（悪い知らせかも）</li>
                    <li className="flex gap-2"><span>🤯</span> 開けたら次の行動が発生しそう</li>
                    <li className="flex gap-2"><span>⚖️</span> 完璧に対応しなきゃいけない</li>
                  </ul>
                </div>
              </div>

              <div className="bg-indigo-50 p-4 rounded-2xl border border-indigo-100 italic text-sm text-indigo-700">
                {isLoadingMessage ? "メッセージを読み込み中..." : `「${geminiMessage}」`}
              </div>

              <Button onClick={nextStage} className="mt-auto">
                次へ進む
              </Button>
            </div>
          )}

          {stage === AppStage.MISSION_SETUP && (
            <div className="flex flex-col space-y-6 animate-in slide-in-from-bottom-4 duration-500">
              <h2 className="text-xl font-bold text-slate-800 text-center">今回の「ルール」</h2>
              <div className="space-y-4">
                <div className="p-4 rounded-2xl bg-emerald-50 border border-emerald-100 flex gap-4 items-start">
                  <span className="text-2xl">✨</span>
                  <div>
                    <h3 className="font-bold text-emerald-900 text-sm">今日は「開けるだけ」</h3>
                    <p className="text-xs text-emerald-700 mt-1">返信もしなくていい。読まなくてもいい。ただ物理的に開くだけをゴールにしましょう。</p>
                  </div>
                </div>
                <div className="p-4 rounded-2xl bg-amber-50 border border-amber-100 flex gap-4 items-start">
                  <span className="text-2xl">🗣️</span>
                  <div>
                    <h3 className="font-bold text-amber-900 text-sm">実況モード</h3>
                    <p className="text-xs text-amber-700 mt-1">「今、ハサミを持ちました」と実況しながら、作業脳に切り替えます。</p>
                  </div>
                </div>
                <div className="p-4 rounded-2xl bg-indigo-50 border border-indigo-100 flex gap-4 items-start">
                  <span className="text-2xl">⏱️</span>
                  <div>
                    <h3 className="font-bold text-indigo-900 text-sm">30秒ミッション</h3>
                    <p className="text-xs text-indigo-700 mt-1">「30秒だけやる。ダメならやめる」という気持ちで始めましょう。</p>
                  </div>
                </div>
              </div>
              <Button onClick={nextStage} className="mt-auto" variant="secondary">
                ミッション開始
              </Button>
            </div>
          )}

          {stage === AppStage.GUIDE && (
            <div className="flex flex-col h-full animate-in fade-in duration-500">
              <div className="mb-6">
                <div className="flex justify-between items-end mb-2">
                  <span className="text-xs font-bold text-indigo-600 tracking-wider">PROGRESS</span>
                  <span className="text-xs text-slate-400">{currentStepIdx + 1} / {steps.length}</span>
                </div>
                <div className="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                  <div 
                    className="bg-indigo-500 h-full transition-all duration-500 ease-out" 
                    style={{ width: `${((currentStepIdx + 1) / steps.length) * 100}%` }}
                  />
                </div>
              </div>

              <div className="flex-grow flex flex-col">
                <div className="bg-slate-50 rounded-3xl p-6 border border-slate-100 flex-grow flex flex-col items-center justify-center text-center space-y-4 mb-6">
                  <span className="text-4xl">
                    {steps[currentStepIdx].id === 'stand' && '🧍'}
                    {steps[currentStepIdx].id === 'approach' && '🚶'}
                    {steps[currentStepIdx].id === 'touch' && '✋'}
                    {steps[currentStepIdx].id === 'tool' && '✂️'}
                    {steps[currentStepIdx].id === 'cut' && '⚡'}
                    {steps[currentStepIdx].id === 'open' && '🎉'}
                  </span>
                  <h3 className="text-xl font-bold text-slate-800">{steps[currentStepIdx].label}</h3>
                  <p className="text-slate-500 text-sm leading-relaxed">{steps[currentStepIdx].description}</p>
                </div>

                <div className="space-y-3">
                  <Button 
                    onClick={() => completeStep(currentStepIdx)} 
                    variant="secondary" 
                    className="w-full py-4 text-lg"
                  >
                    {currentStepIdx === steps.length - 1 ? "完了！" : "やった"}
                  </Button>
                  <p className="text-center text-[10px] text-slate-400">
                    無理だと思ったら、いつでも止めて大丈夫。
                  </p>
                </div>
              </div>
            </div>
          )}

          {stage === AppStage.FINISH && (
            <div className="flex flex-col items-center text-center space-y-6 my-auto animate-in zoom-in-95 duration-500">
              <div className="w-32 h-32 bg-emerald-50 rounded-full flex items-center justify-center text-6xl mb-2 relative">
                🎊
                <div className="absolute inset-0 animate-ping bg-emerald-200 rounded-full opacity-20"></div>
              </div>
              <h2 className="text-3xl font-bold text-slate-800">ミッション完了！</h2>
              <div className="space-y-4">
                <p className="text-slate-600 leading-relaxed font-medium">
                  あなたは封筒を物理的に開けました。<br/>
                  それだけで十分です。
                </p>
                <div className="bg-indigo-50 p-4 rounded-2xl border border-indigo-100 text-xs text-indigo-700 text-left">
                  <p className="font-bold mb-1">🧠 脳のメモリが解放されました：</p>
                  <p>「中身が何かわからない」という不安は消えました。今日はもうこれ以上何もしなくていいです。ゆっくり休みましょう。</p>
                </div>
              </div>
              <Button onClick={reset} variant="outline" className="w-full mt-6">
                もうひとつの封筒も開ける？
              </Button>
            </div>
          )}

        </div>

        {/* Footer info */}
        <div className="p-4 bg-slate-50 text-[10px] text-center text-slate-400 uppercase tracking-widest">
          Mindful Task Decomposition System
        </div>
      </div>

      <p className="mt-8 text-slate-400 text-xs text-center max-w-sm">
        小さな一歩は、どんな大きな意志よりも強い。
      </p>
    </div>
  );
};

export default App;
