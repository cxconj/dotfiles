# docker
docker install
https://docs.docker.com/engine/install/ubuntu/

docker を一般ユーザー権限で実行する
https://docs.docker.com/engine/install/linux-postinstall/

```bash
devpod context set-options default -o SSH_INJECT_GIT_CREDENTIALS=false
devpod context set-options default -o GIT_SSH_SIGNATURE_FORWARDING=false
```

# agent skills

This repository manages shared agent skills under `skills/`. `install.sh` links these skills into `~/.agents/skills`, which is used by Claude Code and Codex.

Available skills:

- `jr`
- `ta-reviewer`
- `tta-reviewer`
