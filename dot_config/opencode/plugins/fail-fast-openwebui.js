// opencode retries provider errors up to 5 times with exponential backoff (hardcoded,
// ~1 min total). When the SDSC Open WebUI endpoint is down that's wasted time, since
// the orchestrator has luna backups. This aborts a session on its first Open WebUI
// retry, so the task fails fast and the orchestrator falls back to explorer-luna/worker-luna.
const PATTERN = /open webui/i

export const FailFastOpenWebUI = async ({ client }) => {
  const aborted = new Set()
  return {
    event: async ({ event }) => {
      if (event.type !== "session.status") return
      const { sessionID, status } = event.properties
      if (status?.type !== "retry" || !PATTERN.test(status.message ?? "")) return
      if (aborted.has(sessionID)) return
      aborted.add(sessionID)
      await client.app
        .log({
          body: {
            service: "fail-fast-openwebui",
            level: "warn",
            message: `aborting ${sessionID} on Open WebUI error: ${status.message}`,
          },
        })
        .catch(() => {})
      await client.session.abort({ path: { id: sessionID } }).catch(() => {})
    },
  }
}
