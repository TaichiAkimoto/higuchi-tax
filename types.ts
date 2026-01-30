
export enum AppStage {
  START = 'START',
  VALIDATION = 'VALIDATION',
  MISSION_SETUP = 'MISSION_SETUP',
  GUIDE = 'GUIDE',
  FINISH = 'FINISH'
}

export interface MicroStep {
  id: string;
  label: string;
  description: string;
  completed: boolean;
}

export interface CheerMessage {
  text: string;
  type: 'empathy' | 'instruction' | 'celebration';
}
