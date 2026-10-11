// opencode retries failed provider calls with exponential backoff before giving up.
// When the SDSC Open WebUI endpoint is down that's a minute of waiting for nothing,
// since the orchestrator has explorer-luna / worker-luna as backups. This vetoes
// every retry for the openwebui provider so the task fails on the first error and
// the orchestrator falls back right away. Other providers keep the default policy.
//
// Plugin.define() is an identity function, so a plain default export works and
// this file doesn't need @opencode/plugin installed.
const PROVIDER = "openwebui"

export default {
  id: "fail-fast-openwebui",
  async setup(ctx: any) {
    await ctx.session.hook("retry", (event: any) => {
      if (event.model?.providerID !== PROVIDER) return
      console.error(
        `[fail-fast-openwebui] no retry for ${event.model.providerID}/${event.model.id} ` +
          `(session ${event.sessionID}, attempt ${event.attempt}): ${event.error?.message}`,
      )
      event.decision = { retry: false }
    })
  },
}
