import type { Plugin } from "@opencode-ai/plugin";

const SOUND = {
  question: "/System/Library/Sounds/Hero.aiff",
  permission: "/System/Library/Sounds/Glass.aiff",
} as const;

const BEEP_DEBOUNCE_MS = 100;

const plugin: Plugin = async (context) => {
  let lastBeepAt = 0;
  let lastPermissionId: string | undefined;

  const beep = async (soundPath: string) => {
    const now = Date.now();
    if (now - lastBeepAt < BEEP_DEBOUNCE_MS) return;
    lastBeepAt = now;

    await context.$`afplay ${soundPath}`.nothrow();
  };

  return {
    "permission.ask": async (input) => {
      if (input.id === lastPermissionId) return;
      lastPermissionId = input.id;
      await beep(SOUND.permission);
    },

    "tool.execute.before": async (input) => {
      if (input.tool !== "question") return;
      await beep(SOUND.question);
    },
  };
};

export { plugin };
export default plugin;
