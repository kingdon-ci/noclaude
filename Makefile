.PHONY: install-claude

claude-code-proxy:
	# There are competitive implementations of claude-code-proxy
	git clone git@github.com:1rgs/claude-code-proxy.git
	# git clone https://github.com/fuergaosi233/claude-code-proxy

install-claude:
	bun install -g @anthropic-ai/claude-code
