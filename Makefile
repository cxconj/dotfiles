NVIM_INSTALL_DIR := $(HOME)/.local/share/nvim
NVIM_BIN         := $(HOME)/.local/bin/nvim
NVIM_BINARY      := $(NVIM_INSTALL_DIR)/bin/nvim

GITHUB_API       := https://api.github.com/repos/neovim/neovim/releases/latest
TARBALL_NAME     := nvim-linux-x86_64.tar.gz

TREE_SITTER_BIN          := $(HOME)/.local/bin/tree-sitter
TREE_SITTER_GITHUB_API   := https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest
TREE_SITTER_BOOKWORM_VER := 0.25.10
TREE_SITTER_ASSET        := tree-sitter-linux-x64.gz
TREE_SITTER_BOOKWORM_URL := https://github.com/tree-sitter/tree-sitter/releases/download/v$(TREE_SITTER_BOOKWORM_VER)/$(TREE_SITTER_ASSET)

AGENTS_SKILLS_DIR  := $(HOME)/.agents/skills
CLAUDE_SKILLS_DIR  := $(HOME)/.claude/skills

OS_CODENAME := $(shell . /etc/os-release 2>/dev/null && echo $${VERSION_CODENAME})

.PHONY: all nvim install-nvim tree-sitter skills update-skills clean

all: nvim

nvim: install-nvim tree-sitter

install-nvim:
	$(eval DOWNLOAD_URL := $(shell curl -fsSL $(GITHUB_API) \
		| jq -r '.assets[] | select(.name == "$(TARBALL_NAME)") | .browser_download_url'))
	@if [ -z "$(DOWNLOAD_URL)" ]; then echo "ERROR: download URL not found"; exit 1; fi
	rm -rf $(NVIM_INSTALL_DIR)
	mkdir -p $(NVIM_INSTALL_DIR) $(HOME)/.local/bin
	curl -fsSL -o /tmp/$(TARBALL_NAME) $(DOWNLOAD_URL)
	tar -xzf /tmp/$(TARBALL_NAME) --strip-components=1 -C $(NVIM_INSTALL_DIR)
	rm /tmp/$(TARBALL_NAME)
	@echo "installed: $(NVIM_BINARY)"
	ln -sf $(NVIM_BINARY) $(NVIM_BIN)
	@echo "symlink created: $(NVIM_BIN) -> $(NVIM_BINARY)"

tree-sitter: $(TREE_SITTER_BIN)

$(TREE_SITTER_BIN):
	$(eval RESOLVED_TREE_SITTER_URL := $(or $(TREE_SITTER_URL),$(if $(filter bookworm,$(OS_CODENAME)),$(TREE_SITTER_BOOKWORM_URL),$(shell curl -fsSL $(TREE_SITTER_GITHUB_API) \
		| jq -r '.assets[] | select(.name == "$(TREE_SITTER_ASSET)") | .browser_download_url'))))
	@if [ -z "$(RESOLVED_TREE_SITTER_URL)" ]; then echo "ERROR: tree-sitter download URL not found"; exit 1; fi
	mkdir -p $(HOME)/.local/bin
	curl -fsSL -o /tmp/tree-sitter.gz $(RESOLVED_TREE_SITTER_URL)
	gunzip -c /tmp/tree-sitter.gz > $(TREE_SITTER_BIN)
	chmod +x $(TREE_SITTER_BIN)
	rm /tmp/tree-sitter.gz
	@echo "installed: $(TREE_SITTER_BIN)"

skills update-skills:
	mkdir -p $(AGENTS_SKILLS_DIR) $(CLAUDE_SKILLS_DIR)
	for skill_dir in "$(CURDIR)"/skills/*; do \
		[ -d "$$skill_dir" ] || continue; \
		ln -sfn "$$skill_dir" "$(AGENTS_SKILLS_DIR)/$$(basename "$$skill_dir")"; \
		ln -sfn "$$skill_dir" "$(CLAUDE_SKILLS_DIR)/$$(basename "$$skill_dir")"; \
	done
	@echo "skills linked: $(AGENTS_SKILLS_DIR)"
	@echo "skills linked: $(CLAUDE_SKILLS_DIR)"

clean:
	rm -f $(NVIM_BIN)
	rm -rf $(NVIM_INSTALL_DIR)
	rm -f $(TREE_SITTER_BIN)
