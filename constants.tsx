
import React from 'react';
import { MicroStep } from './types';

export const INITIAL_STEPS: MicroStep[] = [
  { id: 'stand', label: '1. 立ち上がる', description: 'まずは物理的に体を動かしてみよう。', completed: false },
  { id: 'approach', label: '2. 封筒のところに行く', description: '封筒のそばに立つだけでOK。', completed: false },
  { id: 'touch', label: '3. 封筒に触れる', description: '「持った」と感じるだけで大きな一歩。', completed: false },
  { id: 'tool', label: '4. ハサミ（または手）を用意する', description: '開けるための道具を手に取ろう。', completed: false },
  { id: 'cut', label: '5. 端を1mmだけ切る', description: '全部じゃなくていい、ほんの少しだけ。', completed: false },
  { id: 'open', label: '6. 中身を机に出す', description: 'これで「封筒を開ける」ミッション完了！', completed: false },
];

export const VALIDATION_MESSAGES = [
  "サボってるんじゃない。今ちょっと疲れてるだけ。",
  "「開ける＝大きな仕事が始まる」と脳が勘違いしているだけなんだよ。",
  "不確実性が不安を生むのは、とても人間らしい反応です。",
  "今日は「開けるだけ」。その後のことは考えなくていいよ。"
];
