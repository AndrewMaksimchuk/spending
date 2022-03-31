.PHONY: tmux run-client run-server

default: tmux

terminal-clear:
	clear

run-client: terminal-clear
	@echo "\033[1m\033[31mRun client development environment\033[39m\033[0m"
	@cd ./client && npm run serve

run-server: terminal-clear
	@echo "\033[1m\033[31mRun server development environment\033[39m\033[0m"
	cd ./server && npm run serve

npm-clean-cache:
	@echo "Clean npm cache"
	npm cache clean --force

# Variables
SESSION_NAME = web-dev
PROJECT_NAME = Spending

tmux: tmux-start tmux-frontend tmux-active tmux-backend tmux-focus-active-pane tmux-attach

tmux-start:
	tmux new -s ${SESSION_NAME} -d
	tmux set mouse on
	tmux rename-window -t ${SESSION_NAME} ${PROJECT_NAME}

tmux-frontend:
	tmux select-pane -T 'Client'
	tmux send-keys -t ${SESSION_NAME} 'make run-client' C-m

tmux-active:
	tmux split-window -h -t ${SESSION_NAME}
	tmux select-pane -T 'Active work'
	tmux send-keys -t ${SESSION_NAME} 'git status' C-m

tmux-backend:
	tmux split-window -h -t ${SESSION_NAME}
	tmux select-pane -T 'Server'
	tmux send-keys -t ${SESSION_NAME} 'make run-server' C-m

tmux-focus-active-pane:
	tmux select-pane -t 1

tmux-attach:
	tmux attach -t ${SESSION_NAME}

tmux-kill:
	tmux kill-server