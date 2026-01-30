
import { GoogleGenAI } from "@google/genai";

export const getEncouragement = async (userState: string): Promise<string> => {
  const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });
  try {
    const response = await ai.models.generateContent({
      model: "gemini-3-flash-preview",
      contents: `あなたは優しくて共感力の高いサポーターです。
      ユーザーは「封筒を開ける」という些細なタスクに対して、認知的な負担を感じて動けなくなっています。
      以下のユーザーの状況に対して、短く、温かく、そして「ハードルを極限まで下げる」ような励ましの言葉を1つ送ってください。
      
      ユーザーの状況: ${userState}
      
      制約：
      - 2文以内。
      - 「〜しなきゃダメ」という表現は避ける。
      - 「開けるだけで十分えらい」というニュアンスを含める。`,
    });
    return response.text || "大丈夫、一歩ずつ進んでいこう。";
  } catch (error) {
    console.error("Gemini Error:", error);
    return "大丈夫。あなたのペースで、少しずつやってみよう。";
  }
};
