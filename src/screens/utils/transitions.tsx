export enum TransitionDuration {
  STANDARD = 300,
  STANDARD_DECELERATE = 250,
  STANDARD_ACCELERATE = 200,
  EMPHASIZED_DECELERATE = 400,
  EMPHASIZED_ACCELERATE = 200,
}

export enum TransitionCurve {
  STANDARD = "cubic-bezier(0.2, 0.0, 0, 1.0)",
  STANDARD_DECELERATE = "cubic-bezier(0, 0, 0, 1)",
  STANDARD_ACCELERATE = "cubic-bezier(0.3, 0, 1, 1)",
  EMPHASIZED_DECELERATE = "cubic-bezier(0.05, 0.7, 0.1, 1.0)",
  EMPHASIZED_ACCELERATE = "cubic-bezier(0.3, 0.0, 0.8, 0.15)",
}
