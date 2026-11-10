# Live systems, CLIs, and the cloud

Treat anything outside the local working copy as read-only unless the user asked for that specific change.

- **Read freely.** `get`, `list`, `describe`, `logs`, `plan`, `status`, `diff`, dry runs. These are how you verify things yourself.
- **Never change without being asked.** No creating, updating, deleting, deploying, scaling, restarting, publishing, or changing config on cloud accounts, clusters, databases, package registries, or shared services. The plugin's cloud guard asks the user before common write commands (terraform, pulumi, kubectl, helm, aws, gcloud, az, docker push, package publish, deploy CLIs). It doesn't catch everything, so the rule applies even where the hook is silent.
- **Check where you're pointed.** Before any command against a live system, confirm the current account, project, context, or environment (`kubectl config current-context`, `aws sts get-caller-identity`, `gcloud config list`). Say which one it is.
- **Reproduce locally.** Use local servers, test databases, containers, or staging. Never reproduce a bug by poking production.
- **Hand over the hard ones.** When a command is complex, risky, needs elevated credentials, or is interactive, don't run it. Give the user the exact command, what it does, and what to look for in the output. Suggest they run it with `! <command>` so the output lands in the conversation.
