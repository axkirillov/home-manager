import type { Plugin } from "@opencode-ai/plugin";

const SOUND = {
  done: "/System/Library/Sounds/Tink.aiff",
  question: "/System/Library/Sounds/Hero.aiff",
  permission: "/System/Library/Sounds/Glass.aiff",
} as const;

const plugin: Plugin = async (context) => {
  let lastBeepAt = 0;
  let lastCompletedAssistantMessageId: string | undefined;
  let lastPermissionId: string | undefined;

  const beep = async (soundPath: string) => {
    const now = Date.now();
    if (now - lastBeepAt < 500) return;
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

    event: async (input) => {
      if (input.event.type === "message.updated") {
        const info = input.event.properties.info;
        if (info.role !== "assistant") return;
        if (info.time.completed == null) return;
        if (info.id === lastCompletedAssistantMessageId) return;
        lastCompletedAssistantMessageId = info.id;
        await beep(SOUND.done);
      }

      if (input.event.type === "session.idle") {
        await beep(SOUND.done);
      }
    },
  };
};

export { plugin };
export default plugin;
