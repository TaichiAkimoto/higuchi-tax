export interface MicroStep {
  id: string;
  label: string;
  description: string;
  emoji: string;
}

export interface StepsResponse {
  steps: MicroStep[];
}

export interface EncourageResponse {
  message: string;
}

export interface StepsRequest {
  task: string;
}

export interface EncourageRequest {
  context: string;
}
